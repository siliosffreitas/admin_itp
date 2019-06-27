import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LinhasBloc implements BlocBase {
  List<DocumentSnapshot> _linhas = [];
  List<String> _linhasFavoritas = [];

  final _linhasController = BehaviorSubject<List<DocumentSnapshot>>();
  final _linhasFavoritasController = BehaviorSubject<List<String>>();

  Stream<List<DocumentSnapshot>> get outLinhas => _linhasController.stream;

  Stream<List<String>> get outLinhasFavoritas =>
      _linhasFavoritasController.stream;

  LinhasBloc() {
    _addLinhasListener();
    _recuperarLinhasFavoritasDoUsuario();
  }

  _recuperarLinhasFavoritasDoUsuario() async {
    print("_recuperarLinhasFavoritasDoUsuario");
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    if (_user != null) {
      Firestore.instance
          .collection("usuarios")
          .where("email_usuario", isEqualTo: _user.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          _linhasFavoritas = [];
          snapshot.documents
              .elementAt(0)
              .data['linhas_favoritas']
              .forEach((fav) {
            _linhasFavoritas.add(fav);
          });

          print('_linhasFavoritas : ${_linhasFavoritas}');
          _linhasFavoritasController.add(_linhasFavoritas);
        }
      });
    }
  }

  toogleLinhaComoFavorita(String codigoLinha) {
    if (_linhasFavoritas.contains(codigoLinha)) {
      _linhasFavoritas =
          _linhasFavoritas.where((linha) => linha != codigoLinha).toList();
    } else {
      _linhasFavoritas.add(codigoLinha);
    }
    _linhasFavoritasController.add(_linhasFavoritas);
    print(_linhasFavoritas);
    _salvarFavoritoNoFirebase();
  }

  void _salvarFavoritoNoFirebase() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection("usuarios")
        .where("email_usuario", isEqualTo: _user.email)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isEmpty) {
        Firestore.instance.collection("usuarios").add({
          'email_usuario': _user.email,
          'linhas_favoritas': _linhasFavoritas
        }).then((doc) {
          print("salvou linhas favoritas");
        });
      } else {
        Firestore.instance
            .collection('usuarios')
            .document(docs.documents.elementAt(0).documentID)
            .updateData({'linhas_favoritas': _linhasFavoritas}).then((doc) {
          print("atualizou linhas favoritas");
        });
      }
    });
  }

  _addLinhasListener() {
    Firestore.instance
        .collection("linhas")
        .orderBy('CodigoLinha', descending: false)
        .snapshots()
        .listen((snapshot) {
      _linhas = snapshot.documents;
      _linhasController.sink.add(_linhas);
    });
  }

  @override
  void dispose() {
    _linhasController.close();
    _linhasFavoritasController.close();
  }
}
