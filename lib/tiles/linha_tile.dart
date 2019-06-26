import 'package:admin_itp/blocs/linhas_bloc.dart';
import 'package:admin_itp/blocs/rastreamento_bloc.dart';
import 'package:admin_itp/screens/horarios_linha_screen.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinhaTile extends StatelessWidget {
  DocumentSnapshot snapshot;

  final bool interable;

  Map<dynamic, dynamic> _linha;

  LinhaTile(this.snapshot, {this.interable: true}) : _linha = snapshot.data;

  LinhaTile.fromMap(this._linha, {this.interable: false});

  @override
  Widget build(BuildContext context) {
    final _rastreamentoBloc = BlocProvider.of<RastreamentoBloc>(context);
    final _linhasBloc = BlocProvider.of<LinhasBloc>(context);
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.directions_bus),
      ),
      title: Text(_linha["CodigoLinha"] ?? "-"),
      subtitle: _linha['Denomicao'] == null ? null : Text(_linha['Denomicao']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.access_alarms),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HorariosLinhaScreen(
                          codigoLinha: _linha["CodigoLinha"],
                        )));
              }),
          IconButton(
              icon: Icon(_linha['favorita'] == true
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                _linhasBloc.toogleLinhaComoFavorita(_linha["CodigoLinha"]);
              }),
        ],
      ),
      onTap: () {
        Map<String, dynamic> l = _linha.cast<String, dynamic>();

        _rastreamentoBloc.adicionarLinha(l);
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      },
    );
  }
}
