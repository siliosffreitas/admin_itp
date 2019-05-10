import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/linha_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetalhesParadaScreen extends StatelessWidget {
  final int codigoParada;

  DetalhesParadaScreen({Key key, @required this.codigoParada})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parada ${codigoParada}"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('linhasDaParada')
              .where("CodigoParada", isEqualTo: codigoParada)
//          .orderBy(field)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
//              print(snapshot.data.documents);
              if (snapshot.data.documents == null ||
                  snapshot.data.documents.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }

//              print(snapshot.data.documents[0]['Linhas']);
              return _createListLinhas(snapshot.data.documents[0]['Linhas']);
              return Container();
            }
          }),
    );
  }

  _createListLinhas(List linhas) {
    return ListView.separated(
      itemCount: linhas.length,
      itemBuilder: (content, index) {
//        return ListTile(
//          leading: CircleAvatar(
//            child: Icon(Icons.directions_bus),
//          ),
//          title: Text(linhas[index]['CodigoLinha']),
//        );
        return LinhaTile.fromMap(linhas.elementAt(index));
      },
      separatorBuilder: (context, index) => Divider(
            indent: 16,
            height: 1,
          ),
    );
  }
}
