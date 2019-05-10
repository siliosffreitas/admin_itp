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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('paradas')
                    .where("CodigoParada", isEqualTo: codigoParada)
//          .orderBy(field)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.documents == null ||
                        snapshot.data.documents.isEmpty) {
                      return PrimeiramenteCadastreParaVer();
                    }

//                    return _createListLinhas(
//                        snapshot.data.documents[0]['Linhas']);
                    return _desenharParada(snapshot.data.documents[0]);
                  }
                }),
            Container(
              height: 10,
              color: Colors.grey[200],
            ),
            Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Text(
                  "Linhas",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('linhasDaParada')
                    .where("CodigoParada", isEqualTo: codigoParada)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.documents == null ||
                        snapshot.data.documents.isEmpty) {
                      return PrimeiramenteCadastreParaVer();
                    }

                    return _createListLinhas(
                        snapshot.data.documents[0]['Linhas']);
                  }
                }),
          ],
        ),
      ),
    );
  }

  _desenharParada(DocumentSnapshot parada) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 150,
          child: Column(
            children: <Widget>[
              Text("lat ${parada.data['Lat']}"),
              Text("long ${parada.data['Long']}"),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${parada.data['Denomicao']}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text("${parada.data['Endereco']}"),
            ],
          ),
        )
      ],
    );
  }

  _createListLinhas(List linhas) {
    return Column(
      children: linhas.map((linha) {
        return LinhaTile.fromMap(linha);
      }).toList(),
    );

//    return ListView.separated(
//      itemCount: linhas.length,
//      itemBuilder: (content, index) {
////        return ListTile(
////          leading: CircleAvatar(
////            child: Icon(Icons.directions_bus),
////          ),
////          title: Text(linhas[index]['CodigoLinha']),
////        );
//        return LinhaTile.fromMap(linhas.elementAt(index));
//      },
////      separatorBuilder: (context, index) => Divider(
////            indent: 16,
////            height: 1,
////          ),
//    );
  }
}
