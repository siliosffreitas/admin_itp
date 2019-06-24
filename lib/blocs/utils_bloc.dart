import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UtilsBloc implements BlocBase {
  Map configs = {};

  final _configsController = BehaviorSubject<Map>();

  Stream<Map> get outConfigs => _configsController.stream;

  UtilsBloc() {
    _recuperarStatusStrans();
  }

  @override
  void dispose() {
    _configsController.close();
  }

  _recuperarStatusStrans() {
    Firestore.instance.collection("utils").snapshots().listen((snapshot) {
      snapshot.documents.forEach((field) {
        configs[field['nome']] = field['valor'];
      });

      _configsController.add(configs);
    });
  }
}
