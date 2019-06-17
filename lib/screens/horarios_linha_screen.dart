import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorariosLinhaScreen extends StatelessWidget {
  final String codigoLinha;

  HorariosLinhaScreen({@required this.codigoLinha});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('horarios')
            .where("CodigoLinha", isEqualTo: codigoLinha)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _montarTela(
                body: Center(child: CircularProgressIndicator()));
          } else {
            if (snapshot.data.documents == null ||
                snapshot.data.documents.isEmpty) {
              return _montarTela(body: PrimeiramenteCadastreParaVer());
            }
            int count = 0;

            var tabs = List<Widget>();
            var children = List<Widget>();
//            print(snapshot.data.documents[0]['times']['week']);
            if (snapshot.data.documents[0]['times']['week'] != null) {
              count++;
              tabs.add(Tab(
                text: "SEMANA",
              ));
              children.add(_gridTab(snapshot.data.documents[0]['times']['week'] ));
            }
            if (snapshot.data.documents[0]['times']['saturday'] != null) {
              count++;
              tabs.add(Tab(
                text: "SÁBADO",
              ));
              children.add(_gridTab(snapshot.data.documents[0]['times']['saturday'] ));
            }

            if (snapshot.data.documents[0]['times']['sunday'] != null) {
              count++;
              tabs.add(Tab(

                text: "DOMINGO",
              ));
              children.add(_gridTab(snapshot.data.documents[0]['times']['sunday'] ));
            }

//            return _montarTela(body: Container());
            return DefaultTabController(
              length: count,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Horários de ${codigoLinha}"),
//                  title:

//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: Platform.isAndroid
//                        ? CrossAxisAlignment.start
//                        : CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Text("Horários de ${_line.code}",
//                          style: TextStyle(fontSize: 22)),
//                      Text(
//                        "Ponto inicial: ${snapshot.data.value['startPoint']}",
//                        style: TextStyle(fontSize: 12),
//                      )
//                    ],
//                  ),
                  bottom: TabBar(
                    tabs: tabs,
                  ),
                  actions: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.help_outline),
//                      onPressed: () {
//                        _getDetailsTimes();
//                      },
//                      tooltip: "Ajuda",
//                    ),
                  ],
                ),
                body: TabBarView(
                  children: children,
                ),
              ),
            );
          }
        });
  }

  Widget _gridTab(String horariosStr) {
    List<String> horarios = horariosStr.split(",");
    return GridView.builder(
        padding: EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 3,
        ),
        itemCount: horarios.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.access_time),
            title: Text(horarios[index]),
          );
        });
  }

  Scaffold _montarTela({@required Widget body}) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Horários de ${codigoLinha}"),
        ),
        body: body);
  }
}
