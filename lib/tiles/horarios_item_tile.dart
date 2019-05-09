import 'package:admin_itp/screens/horarios_linha_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorarioItemTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const HorarioItemTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.access_alarms),
      ),
      title: Text(snapshot.data["CodigoLinha"]),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HorariosLinhaScreen(
                  codigoLinha: snapshot.data["CodigoLinha"],
                )));
      },
    );
  }
}
