import 'package:admin_itp/blocs/linhas_bloc.dart';
import 'package:admin_itp/utils/utils.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinhasSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _linhasBloc = BlocProvider.of<LinhasBloc>(context);
    if (query.isEmpty) {
      return Container();
    }
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: _linhasBloc.outLinhas,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            // o firebase nao tem pesquisa por 'contains' por isso decidiu-se trazer
            // tudo e filtrar localmente
            var documents = snapshot.data.where((snapshot) => snapshot
                .data['CodigoLinha']
                .toString().toLowerCase()
                .contains(removeDiacritics(query.toLowerCase())));

            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (content, index) {
                  return ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text(documents.elementAt(index)['CodigoLinha']),
                    subtitle: Text(documents.elementAt(index)['Denomicao']),
                    onTap: () {
                      close(context, documents.elementAt(index)['CodigoLinha']);
                    },
                  );
                });
          }
        });
  }

  suggestions(String search) {}
}
