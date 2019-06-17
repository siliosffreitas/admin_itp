import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class LinhasBloc implements BlocBase {

  List<DocumentSnapshot> _linhas = [];

  final _linhasController = BehaviorSubject<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get outLinhas => _linhasController.stream;

  LinhasBloc(){
    _addLinhasListener();
  }


  _addLinhasListener() {
    Firestore.instance
        .collection("linhas")
        .orderBy('CodigoLinha', descending: false)
        .snapshots()
        .listen((snapshot) {
      _linhas = snapshot.documents;
      print(_linhas.length);
      _linhasController.sink.add(_linhas);

    });
  }

  @override
  void dispose() {
    _linhasController.close();
  }

}