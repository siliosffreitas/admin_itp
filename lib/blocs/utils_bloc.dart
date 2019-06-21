import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UtilsBloc implements BlocBase {
  bool strans_online;

  final _stransOnlineController = BehaviorSubject<bool>();

  Stream<bool> get outStransOnline => _stransOnlineController.stream;

  UtilsBloc() {
    _recuperarStatusStrans();
  }

  @override
  void dispose() {
    _stransOnlineController.close();
  }

  _recuperarStatusStrans() {
    Firestore.instance
        .collection("utils")
        .where("nome", isEqualTo: "statusstrans")
        .snapshots()
        .listen((snapshot) {
      strans_online = snapshot.documents.elementAt(0).data['online'];

      _stransOnlineController.add(strans_online);
    });
  }
}
