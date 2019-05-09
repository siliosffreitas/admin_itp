
import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/horarios_item_tile.dart';
import 'package:admin_itp/tiles/linha_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorariosScreen extends StatefulWidget {
  @override
  _HorariosScreenState createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
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
        Text("Horários"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed: _callSearch,
//            tooltip: "Pesquisar cliente",
//          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('horarios')
              .orderBy('CodigoLinha', descending: false)
              .snapshots(),
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
              if (snapshot.data.documents == null ||
                  snapshot.data.documents.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }
              return _createListHorarios(snapshot.data.documents);
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

  _createListHorarios(Iterable<DocumentSnapshot> documents) {
    return ListView.separated(
      itemCount: documents.length,
      itemBuilder: (content, index) {
        return HorarioItemTile(documents.elementAt(index));
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
