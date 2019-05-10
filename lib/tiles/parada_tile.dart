import 'package:admin_itp/screens/detalhes_parada_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParadaTile extends StatelessWidget {
  DocumentSnapshot snapshot;

  Map<dynamic, dynamic> _parada;

  final bool interable;

  ParadaTile(this.snapshot, {this.interable: true}) : _parada = snapshot.data;

  ParadaTile.fromMap(this._parada, {this.interable: false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("${_parada["CodigoParada"]}" ?? "-"),
      title: Text(_parada["Denominacao"] ?? _parada['Denomicao'] ?? null),
      subtitle: Text(_parada["Endereco"] ?? "-"),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhesParadaScreen(
                  codigoParada: _parada["CodigoParada"],
                )));
      },
    );
  }
}
