import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/linha_tile.dart';
import 'package:admin_itp/tiles/parada_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:admin_itp/blocs/paradas_bloc.dart';

class ParadasScreen extends StatefulWidget {
  @override
  _ParadasScreenState createState() => _ParadasScreenState();
}

class _ParadasScreenState extends State<ParadasScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _paradasBloc = BlocProvider.of<ParadasBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Paradas"),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _paradasBloc.outParadas,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return PrimeiramenteCadastreParaVer();
              }
              return _createListParadas(snapshot.data);
            }
          }),
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
}
