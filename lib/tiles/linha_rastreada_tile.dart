import 'package:admin_itp/blocs/rastreamento_bloc.dart';
import 'package:admin_itp/utils/utils.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class LinhaRastreadaTile extends StatelessWidget {
  final Map<String, dynamic> linha;

  LinhaRastreadaTile({@required this.linha});

  @override
  Widget build(BuildContext context) {
    final _rastreamentoBloc = BlocProvider.of<RastreamentoBloc>(context);
    return Chip(
      elevation: 2,
      avatar: Stack(
        alignment: Alignment(2, -1.5),
        children: <Widget>[
          Icon(
            Icons.directions_bus,
            color: determinarCorLinhaRastreada(linha['cor']),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.redAccent,
            ),
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              "${0}",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      label: Text(linha['CodigoLinha']),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      deleteIcon: Icon(Icons.close),
      onDeleted: () {
        _rastreamentoBloc.removerLinha(linha['CodigoLinha']);
      },
    );
  }
}
