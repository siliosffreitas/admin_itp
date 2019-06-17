import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ParadasBloc implements BlocBase {

  List<DocumentSnapshot> _paradas = [];

  final _paradasController = BehaviorSubject<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get outParadas => _paradasController.stream;

  ParadasBloc(){
    _addParadasListener();
  }


  _addParadasListener() {
    Firestore.instance
        .collection("paradas")
        .orderBy('CodigoParada', descending: false)
        .snapshots()
        .listen((snapshot) {
      _paradas = snapshot.documents;
      print(_paradas.length);
      _paradasController.sink.add(_paradas);

    });
  }

  @override
  void dispose() {
    _paradasController.close();
  }

}