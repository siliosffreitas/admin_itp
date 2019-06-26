import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LinhasBloc implements BlocBase {
  List<DocumentSnapshot> _linhas = [];
  List<String> _linhasFavoritas = [];

  final _linhasController = BehaviorSubject<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get outLinhas => _linhasController.stream;

  LinhasBloc() {
    _addLinhasListener();
  }

  _recuperarLinhasFavoritasDoUsuario() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    if (_user != null) {
      Firestore.instance
          .collection("usuarios")
          .document(_user.email)
          .get()
          .then((userPrefs) {
        userPrefs.data['linhas_favoritas'].forEach((linhaFavorita) {
          toogleLinhaComoFavorita(linhaFavorita);
        });
      });
    }
  }

  toogleLinhaComoFavorita(String codigoLinha) async {
    Map<String, dynamic> linha = _linhas
        .where((l) => l.data['CodigoLinha'] == codigoLinha)
        .elementAt(0)
        .data;
    if (linha['favorita']) {
      linha['favorita'] = false;
      _linhasFavoritas.remove(codigoLinha);
    } else {
      linha['favorita'] = true;
      _linhasFavoritas.add(codigoLinha);
    }

    _ordenarLinhas();

    _linhasController.sink.add(_linhas);

    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('usuarios')
        .document(_user.email)
        .updateData({'linhas_favoritas': _linhasFavoritas});
  }

  void _ordenarLinhas() {
    _linhas.sort((a, b) {
      int compare = 0;

      if (a.data['favorita'] == b.data['favorita']) {
        compare = 0;
      } else if (a.data['favorita']) {
        return -1;
      } else {
        return 1;
      }

      if (compare == 0) {
        return a.data['CodigoLinha'].compareTo(b.data['CodigoLinha']);
      } else {
        return compare;
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
      _linhas.forEach((docLinha) {
        docLinha.data['favorita'] = false;
      });
      _linhasController.sink.add(_linhas);

      _recuperarLinhasFavoritasDoUsuario();
    });
  }

  @override
  void dispose() {
    _linhasController.close();
  }
}
