import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class RastreamentoBloc implements BlocBase {
  final int MAX_LINE = 10;
  List<Map<String, dynamic>> _linhasRastreadas = [];

  final _linhasRastreadasController =
      BehaviorSubject<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get outLinhasRastreadas =>
      _linhasRastreadasController.stream;

  adicionarLinha(Map<String, dynamic> linha) {
    print("adicionarLinha");
    if (_procuraLinha(linha['CodigoLinha']) == -1) {
      if (linha.length < MAX_LINE) {
        linha['cor'] = _procuraPrimeiraCorDisponivel();
        _linhasRastreadas.add(linha);
        _linhasRastreadasController.add(_linhasRastreadas);

        _recuperarItinerarios(linha['CodigoLinha']);
      }
    }
  }

  _recuperarItinerarios(String idLinha) {
    print(idLinha);
    Firestore.instance
        .collection("itinerarios")
        .where("CodigoLinha", isEqualTo: idLinha)
        .orderBy('NomeItinerario', descending: false)
        .snapshots()
        .listen((snapshot) {
      int position = _procuraLinha(idLinha);

      List itinerarios = [];
      snapshot.documents.forEach((it) {
        itinerarios.add(it.data);
//        print(it.data);
      });

//      print("AA: ${idLinha} :: ${itinerarios}");
      _linhasRastreadas.elementAt(position)['Itinerarios'] = itinerarios;
      _linhasRastreadasController.add(_linhasRastreadas);


    });
  }

  _procuraPrimeiraCorDisponivel() {
    for (int cor = 0; cor < MAX_LINE; cor++) {
      bool encontrouCor = false;
      for (int linha = 0; linha < _linhasRastreadas.length; linha++) {
        if (cor == _linhasRastreadas.elementAt(linha)['cor']) {
          encontrouCor = true;
        }
      }

      if (!encontrouCor) {
        return cor;
      }
    }
    return MAX_LINE;
  }

  removerLinha(String id) {
    int position = _procuraLinha(id);
    if (position != -1) {
      _linhasRastreadas.removeAt(position);
      _linhasRastreadasController.add(_linhasRastreadas);
    }
  }

  _procuraLinha(String id) {
    for (int i = 0; i < _linhasRastreadas.length; i++) {
      if (_linhasRastreadas.elementAt(i)['CodigoLinha'] == id) {
        return i;
      }
    }
    return -1;
  }

  @override
  void dispose() {
    _linhasRastreadasController.close();
  }
}
