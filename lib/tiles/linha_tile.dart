
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinhaTile extends StatelessWidget {
  DocumentSnapshot snapshot;

  final bool interable;

  LinhaTile(this.snapshot, {this.interable: true}) ;

//  LinhaTile.fromMap(this._client, {this.interable: false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.directions_bus),),
      title: Text(snapshot.data["CodigoLinha"]??"-"),
      subtitle: Text(snapshot.data["Denominacao"]??snapshot.data['Denomicao']??"-"),
//      trailing: interable
//          ? Icon(Icons.keyboard_arrow_right)
//          : Container(
//              width: 0,
//              height: 0,
//            ),
//      onTap: interable
//          ? () {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => DetailClientScreen(snapshot)));
//            }
//          : null,
    );
  }
}
