import 'package:admin_itp/screens/horarios_linha_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinhaTile extends StatelessWidget {
  DocumentSnapshot snapshot;

  final bool interable;

  Map<dynamic, dynamic> _linha;

  LinhaTile(this.snapshot, {this.interable: true}) : _linha = snapshot.data;

  LinhaTile.fromMap(this._linha, {this.interable: false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.directions_bus),
      ),
      title: Text(_linha["CodigoLinha"] ?? "-"),
      subtitle: _linha['Denomicao'] == null ? null : Text(_linha['Denomicao']),
      trailing: IconButton(
          icon: Icon(Icons.access_alarms),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HorariosLinhaScreen(
                      codigoLinha: _linha["CodigoLinha"],
                    )));
          }),
//      onTap: interable
//          ? () {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => DetailClientScreen(snapshot)));
//            }
//          : null,
    );
  }
}
