import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/adm_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdministradoresScreen extends StatefulWidget {
  @override
  _AdministradoresScreenState createState() => _AdministradoresScreenState();
}

class _AdministradoresScreenState extends State<AdministradoresScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Administradores"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('administradores').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.documents == null ||
                  snapshot.data.documents.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }
              return _createListAdministradores(snapshot.data.documents);
            }
          }),
    );
  }

  _createListAdministradores(Iterable<DocumentSnapshot> documents) {
//    __printTudo(documents);
    return ListView.separated(
      itemCount: documents.length,
      itemBuilder: (content, index) {
        return AdmTile(documents.elementAt(index));
      },
      separatorBuilder: (context, index) => Divider(
            indent: 16,
            height: 1,
          ),
    );
  }

  __printTudo(List<DocumentSnapshot> docments) {
    docments.forEach((doc) {
      print(doc.data);
    });
  }
}
