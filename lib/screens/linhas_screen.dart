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
    final _linhasBloc = BlocProvider.of<LinhasBloc>(context);
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
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (_query != null && _query.trim().isNotEmpty) {
                // filtra localmente
                var documents = snapshot.data.where((snapshot) => snapshot
                    .data['CodigoLinha']
                    .toString()
                    .contains(removeDiacritics(_query)));

                if (documents == null || documents.isEmpty) {
                  return NadaEncontradoNaPesquisa(query: _query);
                }

                return _createListLinhas(documents);
              }
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }
              return _createListLinhas(snapshot.data);
            }
          }),
    );
  }

  _createListLinhas(Iterable<DocumentSnapshot> documents) {
    return ListView.separated(
      itemCount: documents.length,
      itemBuilder: (content, index) {
        return LinhaTile(documents.elementAt(index));
      },
      separatorBuilder: (context, index) => Divider(
            indent: 16,
            height: 1,
          ),
    );
  }
}
