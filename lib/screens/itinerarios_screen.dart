import 'dart:convert';

import 'package:admin_itp/utils/consts2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItinerariosScreen extends StatefulWidget {
  @override
  _ItinerariosScreenState createState() => _ItinerariosScreenState();
}

class _ItinerariosScreenState extends State<ItinerariosScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _salvarIt();
  }

  _salvarIt(){
    Map<String, dynamic> it = itnerarios;
    print("comecou");

    for (int k = 0; k < it.keys.length; k++) {
      print("iniciando linha ${it.keys.elementAt(k)}");

      Map<String, dynamic> linhaMap =
      json.decode(json.encode(it[it.keys.elementAt(k)]));

      for (int i = 0; i < linhaMap.keys.length; i++) {

        Map<String, dynamic> itMap={};
        String nomeIt = linhaMap.keys.elementAt(i);
//        print(nomeIt);

        itMap['NomeItinerario'] = nomeIt;
        itMap['CodigoLinha'] = it.keys.elementAt(k);
        itMap['Caminho'] = linhaMap[nomeIt];

//        print(itMap);

        Firestore.instance.collection("itinerarios").add(itMap).then((doc) {
//        cartProduct.cid = doc.documentID;
          print("terminou itinerario ${nomeIt}");
        });
      }
    }

    print("terminou");
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text("Itinerários"),
        ),
        body: Container());
  }
}
