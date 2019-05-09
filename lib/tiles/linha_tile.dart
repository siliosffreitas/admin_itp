import 'package:admin_itp/screens/horarios_linha_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinhaTile extends StatelessWidget {
  DocumentSnapshot snapshot;

  final bool interable;

  LinhaTile(this.snapshot, {this.interable: true});

//  LinhaTile.fromMap(this._client, {this.interable: false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.directions_bus),
      ),
      title: Text(snapshot.data["CodigoLinha"] ?? "-"),
      subtitle: Text(
          snapshot.data["Denominacao"] ?? snapshot.data['Denomicao'] ?? "-"),
      trailing: IconButton(
          icon: Icon(Icons.access_alarms),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HorariosLinhaScreen(
                      codigoLinha: snapshot.data["CodigoLinha"],
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
