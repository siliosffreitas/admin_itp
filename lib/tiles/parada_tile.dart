import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParadaTile extends StatelessWidget {
  DocumentSnapshot snapshot;

  final bool interable;

  ParadaTile(this.snapshot, {this.interable: true});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("${snapshot.data["CodigoParada"]}" ?? "-"),
      title: Text(
          snapshot.data["Denominacao"] ?? snapshot.data['Denomicao'] ?? "-"),
      subtitle: Text(snapshot.data["Endereco"] ?? "-"),
    );
  }
}
