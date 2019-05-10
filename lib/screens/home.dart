import 'package:admin_itp/utils/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'custom_drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firestore.instance.settings(timestampsInSnapshotsEnabled: true);


//    FirebaseFirestore firestore = FirebaseFirestore.getInstance();
//    FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
//        .setTimestampsInSnapshotsEnabled(true)
//       .build();
//    firestore.setFirestoreSettings(settings);
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text("Montar linhas"), onPressed: null //_montarLinhas,
                  ),
              RaisedButton(
                  child: Text("Montar paradas"),
                  onPressed: null //_montarParadas,
                  ),
              RaisedButton(
                  child: Text("Montar horários"),
                  onPressed: null //_montarHorarios,
                  ),
              RaisedButton(
                child: Text("Montar linhas da parada"),
                onPressed: null//_montarLinhasDaParada,
              )
            ],
          ),
        )
// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  _montarLinhas() {
    List<Map<String, dynamic>> _linhas = linhas;
    try {
      _linhas.forEach((map) {
        Firestore.instance.collection("linhas").add(map).then((doc) {
//        cartProduct.cid = doc.documentID;
          print(map['CodigoLinha']);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _montarParadas() {
    List<Map<String, dynamic>> _paradas = paradas;
    try {
      _paradas.forEach((map) {
        Firestore.instance.collection("paradas").add(map).then((doc) {
          print(map['CodigoParada']);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _montarHorarios() {
    Map<String, Map<String, dynamic>> _horarios = horarios;
    _horarios.keys.forEach((linha) {
      Map<String, dynamic> horarioMap = _horarios[linha];
      horarioMap['CodigoLinha'] = linha;

      Firestore.instance.collection("horarios").add(horarioMap).then((doc) {
        print(linha);
      });
    });
  }

  _montarLinhasDaParada() {
    List<List<Map<String, dynamic>>> _linhasDaParada = linhasDaParada;
    for (int parada = 0; parada < _linhasDaParada.length; parada++) {
      if (_linhasDaParada[parada] != null) {
        Map<String, dynamic> linhaParada = {
          'CodigoParada': parada,
          'Linhas': []
        };
//        print("--- inicio ${parada}");
        for (int linha = 0; linha < _linhasDaParada[parada].length; linha++) {
//          print("  * ${parada} ${_linhasDaParada[parada][linha]['CodigoLinha']}");
          Map<String, dynamic> linhaMap = {
            'CodigoLinha': _linhasDaParada[parada][linha]['CodigoLinha'],
          };
          List ds = linhaParada['Linhas'];
          ds.add(linhaMap);
          linhaParada['Linhas'] = ds;
        }

//        print("--- fim ${parada}");
//      print(linhaParada);
        Firestore.instance.collection("linhasDaParada").add(linhaParada).then((doc) {
          print(parada);
        });
      }
    }

//    Map<String, Map<String, dynamic>> _horarios = horarios;
//    _horarios.keys.forEach((linha) {
//      Map<String, dynamic> horarioMap = _horarios[linha];
//      horarioMap['CodigoLinha'] = linha;
//
//      Firestore.instance.collection("horarios").add(horarioMap).then((doc) {
//        print(linha);
//      });
//    });
  }
}
