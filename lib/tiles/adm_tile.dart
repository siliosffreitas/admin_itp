import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdmTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const AdmTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.alternate_email),),
      title: Text(snapshot.data["email"]),
    );
  }
}
