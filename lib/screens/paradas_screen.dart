
import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/linha_tile.dart';
import 'package:admin_itp/tiles/parada_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../paradas_bloc.dart';

class ParadasScreen extends StatefulWidget {
  @override
  _ParadasScreenState createState() => _ParadasScreenState();
}

class _ParadasScreenState extends State<ParadasScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  String _query;

//  _callSearch() async {
//    String result = await showSearch(
//        context: context, delegate: ClienteSearch(), query: _query);
//
//    setState(() {
//      _query = result;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final _paradasBloc = BlocProvider.of<ParadasBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:
//        _query != null && _query.trim().isNotEmpty
//            ? InkWell(
////                onTap: _callSearch,
//                child: Text(_query),
//              )
//            :
        Text("Paradas"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed: _callSearch,
//            tooltip: "Pesquisar cliente",
//          )
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _paradasBloc.outParadas,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
//              _editandoTodosProdutos(snapshot.data.documents);
//              __printTudo(snapshot.data.documents);
//              if (_query != null && _query.trim().isNotEmpty) {
//                // filtra localmente
//                var documents = snapshot.data.documents.where((snapshot) =>
//                    snapshot.data['ordenacao_pesquisa']
//                        .toString()
//                        .contains(removeDiacritics(_query)));
//
//                if (documents == null || documents.isEmpty) {
//                  return NadaEncontradoNaPesquisa(query: _query);
//                }
//
//                return _createListClients(documents);
//              }
              if (snapshot.data == null ||
                  snapshot.data.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }
              return _createListParadas(snapshot.data);
            }
          }),
//      floatingActionButton: FloatingActionButton(
//        tooltip: "Adicionar um novo cliente",
//        onPressed: () async {
//          final bool done = await Navigator.of(context).push(
//              MaterialPageRoute(builder: (context) => EditClientScreen()));
//        },
//        child: Icon(Icons.person_add),
//      ),
    );
  }

  _createListParadas(List<DocumentSnapshot> documents) {
    return ListView.separated(
      itemCount: documents.length,
      itemBuilder: (content, index) {
        return ParadaTile(documents.elementAt(index));
      },
      separatorBuilder: (context, index) => Divider(
            indent: 16,
            height: 1,
          ),
    );
  }

//  __printTudo(List<DocumentSnapshot> docments){
//    docments.forEach((doc) {
//      print(doc.data);
//    });
//  }
//
//  _editandoTodosProdutos(List<DocumentSnapshot> docs) {
//    docs.forEach((doc) {
//      Firestore.instance
//          .collection("clientes")
//          .document(doc.documentID)
//          .updateData({
//        "ordenacao_pesquisa": removeDiacritics(doc.data['nome'])
//      }).then((_doc) {
//        print(doc.data['nome']);
//      });
//    });
//  }
}
