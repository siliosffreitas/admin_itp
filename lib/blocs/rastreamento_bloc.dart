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
    if (_procuraLinha(linha['CodigoLinha']) == -1) {
      if (_linhasRastreadas.length < MAX_LINE) {
        linha['cor'] = _procuraPrimeiraCorDisponivel();
        _linhasRastreadas.add(linha);
        _linhasRastreadasController.add(_linhasRastreadas);

        _recuperarItinerarios(linha['CodigoLinha']);
        _recuperarVeiculos();
      }
    }
  }

  _recuperarVeiculos() {
    _linhasRastreadas.forEach((linha) {
      String data = "20190619";

      Firestore.instance
          .collection("rastreamento/$data/${linha['CodigoLinha']}")
          .orderBy('CodigoVeiculo', descending: false)
          .snapshots()
          .listen((snapshot) {
        print('encontrou veiculo(s) ${snapshot.documents}');

        linha['Veiculos'] = snapshot.documents;
        _linhasRastreadasController.add(_linhasRastreadas);
      });
    });
  }

  visualizarItinerario(String idLinha, String nome){
    Map<String, dynamic> linha = _linhasRastreadas.where((l) => l['CodigoLinha'] == idLinha).elementAt(0);
    linha['Itinerarios'].forEach((it){
      if(it['NomeItinerario'] == nome){
        it['selecionado'] = true;
      } else {
        it['selecionado'] = false;
      }
    });
    _linhasRastreadasController.add(_linhasRastreadas);
  }

  _recuperarItinerarios(String idLinha) {
    Firestore.instance
        .collection("itinerarios")
        .where("CodigoLinha", isEqualTo: idLinha)
        .orderBy('NomeItinerario', descending: false)
        .snapshots()
        .listen((snapshot) {
      int position = _procuraLinha(idLinha);

      List itinerarios = [];
      snapshot.documents.forEach((it) {
        Map<String, dynamic> iter = it.data;
        if(itinerarios.isEmpty){
          iter['selecionado'] = true;
        } else {
          iter['selecionado'] = false;
        }
        itinerarios.add(iter);
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
