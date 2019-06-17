import 'package:flutter/material.dart';

class NadaEncontradoNaPesquisa extends StatelessWidget {
  final String query;

  NadaEncontradoNaPesquisa({@required this.query});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Nada encontrado com \"${query}\"",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Icon(
            Icons.healing,
            size: 60,
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}
