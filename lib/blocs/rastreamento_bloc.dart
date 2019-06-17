import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class RastreamentoBloc implements BlocBase {
  List<Map<String, dynamic>> _linhasRastreadas = [];

  final _linhasRastreadasController =
      BehaviorSubject<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get outLinhasRastreadas =>
      _linhasRastreadasController.stream;

  adicionarLinha(Map<String, dynamic> linha) {
    if (_procuraLinha(linha['CodigoLinha']) == -1) {
      if (linha.length < 10) {
        _linhasRastreadas.add(linha);
        _linhasRastreadasController.add(_linhasRastreadas);
      }
    }
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
