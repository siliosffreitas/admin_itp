import 'package:admin_itp/blocs/paradas_bloc.dart';
import 'package:admin_itp/screens/home.dart';
import 'package:admin_itp/screens/login_screen.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'blocs/linhas_bloc.dart';
import 'blocs/rastreamento_bloc.dart';
import 'blocs/utils_bloc.dart';

void main() async {
  runApp(MyApp(await _checkUserLoged()));
}

Future<bool> _checkUserLoged() async {
  FirebaseUser _user = await FirebaseAuth.instance.currentUser();
  return _user != null;
}

class MyApp extends StatelessWidget {
  final bool logged;

  const MyApp(this.logged);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: UtilsBloc(),
      child: BlocProvider(
        bloc: ParadasBloc(),
        child: BlocProvider(
          bloc: LinhasBloc(),
          child: BlocProvider(
            bloc: RastreamentoBloc(),
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: !logged
                  ? LoginScreen()
                  : MyHomePage(title: 'Paradas próximas'),
            ),
          ),
        ),
      ),
    );
  }
}
