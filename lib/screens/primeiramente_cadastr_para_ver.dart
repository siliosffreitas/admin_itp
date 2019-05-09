import 'package:flutter/material.dart';

class PrimeiramenteCadastreParaVer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Opss, parece que não tem nada para mostrar",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Icon(
            Icons.warning,
            size: 60,
            color: Colors.orangeAccent,
          ),
          Text(
            "Primeiramente realize o cadastro do que deseja ver aqui",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            "Se você já tinha cadastrado anteriormente, tenha certeza que está conectado à internet",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
