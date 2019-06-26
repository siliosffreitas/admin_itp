import 'package:admin_itp/blocs/linhas_bloc.dart';
import 'package:admin_itp/delegates/linhas_search.dart';
import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/linha_tile.dart';
import 'package:admin_itp/utils/utils.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'nada_contrado_na_pesquisa.dart';

class LinhasScreen extends StatefulWidget {
  @override
  _LinhasScreenState createState() => _LinhasScreenState();
}

class _LinhasScreenState extends State<LinhasScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LinhasBloc _linhasBloc;

  String _query;

  _callSearch() async {
    String result = await showSearch(
        context: context, delegate: LinhasSearch(), query: _query);

    setState(() {
      _query = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    _linhasBloc = BlocProvider.of<LinhasBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _query != null && _query.trim().isNotEmpty
            ? InkWell(
                onTap: _callSearch,
                child: Text(_query),
              )
            : Text("Linhas"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _callSearch,
            tooltip: "Pesquisar linha",
          )
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _linhasBloc.outLinhas,
          builder: (context, snapshotLinhas) {
            if (!snapshotLinhas.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (_query != null && _query.trim().isNotEmpty) {
                // filtra localmente
                var documents = snapshotLinhas.data.where((snapshot) => snapshot
                    .data['CodigoLinha']
                    .toLowerCase()
                    .toString()
                    .contains(removeDiacritics(_query.toLowerCase())));

                if (documents == null || documents.isEmpty) {
                  return NadaEncontradoNaPesquisa(query: _query);
                }

                return _createListLinhas(documents);
              }
              if (snapshotLinhas.data == null || snapshotLinhas.data.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }
              return _createListLinhas(snapshotLinhas.data);
            }
          }),
    );
  }

  _createListLinhas(Iterable<DocumentSnapshot> documents) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StreamBuilder<List<String>>(
            stream: _linhasBloc.outLinhasFavoritas,
            builder: (context, snapshotFavoritas) {
              if (!snapshotFavoritas.hasData ||
                  snapshotFavoritas.data.isEmpty) {
                return Container();
              }

              List linhasFavoritasEncontradas = documents
                  .where((linha) =>
                      snapshotFavoritas.data.contains(linha["CodigoLinha"]))
                  .toList();

              if (linhasFavoritasEncontradas.isEmpty) {
                return Container();
              }

              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Suas linhas favoritas"),
                  ),
                  Column(
                    children: linhasFavoritasEncontradas.map((linha) {
                      return LinhaTile(linha);
                    }).toList(),
                  )
                ],
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                title: Text("Linhas de Teresina"),
              ),
            ]..add(Column(
                children: documents.map((linha) {
                  return LinhaTile(linha);
                }).toList(),
              )),
          )
        ],
      ),
    );

//    return SingleChildScrollView(
//      child: Column(
//        children: <Widget>[
//          StreamBuilder<List<String>>(
//            stream: _linhasBloc.outLinhasFavoritas,
//
//          )
//        ],
//      ),
//    );

//    return ListView(
//      children: Stre,
//    );
//    return ListView.separated(
//      itemCount: documents.length,
//      itemBuilder: (content, index) {
//        return LinhaTile(documents.elementAt(index));
//      },
//      separatorBuilder: (context, index) => Divider(
//            indent: 16,
//            height: 1,
//          ),
//    );
  }
}
