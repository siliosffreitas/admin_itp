import 'package:admin_itp/screens/paradas_screen.dart';
import 'package:flutter/material.dart';

import 'administradores_screen.dart';
import 'horarios_screen.dart';
import 'linhas_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
//  FirebaseUser _user;

  @override
  Widget build(BuildContext context) {
//    FirebaseAuth.instance.currentUser().then((user) {
//      setState(() {
//        _user = user;
//      });
//    });

    DateTime now = DateTime.now();
    DateTime firstDateInActualMonth = DateTime(now.year, now.month);

    return Drawer(

      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
//                _user == null
//                    ? Container()
//                    :
                UserAccountsDrawerHeader(
                        accountName: Text("Só admins"),
                        accountEmail: Text("soadmin@email.com"),
//                        currentAccountPicture: GestureDetector(
//                          onTap: () => print('clicou na imagem de perfil'),
//                          child: CircleAvatar(
//                            backgroundImage: NetworkImage(_user.photoUrl),
//                          ),
//                        ),
                      ),
                Expanded(
                  child: Container(
                      child: ListView(
                    children: <Widget>[
//                      ListTile(
//                        leading: Icon(Icons.shopping_cart),
//                        title: Text("Pedidos"),
//                        onTap: () {
//                          Navigator.of(context).pop();
//                          Navigator.of(context).push(MaterialPageRoute(
//                              builder: (context) => PedidosScreen()));
//                        },
//                      ),
//                      ListTile(
//                        leading: Icon(Icons.account_balance_wallet),
//                        title: Row(
//                          children: <Widget>[
//                            Expanded(child: Text("Saldo Devedor")),
//                            StreamBuilder<QuerySnapshot>(
//                                stream: Firestore.instance
//                                    .collection('pedidos')
//                                    .where('pago', isEqualTo: false)
//                                    .where('data',
//                                        isLessThan: firstDateInActualMonth)
//                                    .snapshots(),
//                                builder: (context, snapshot) {
//                                  if (snapshot.hasData &&
//                                      snapshot.data.documents.isNotEmpty) {
//                                    return Container(
//                                        margin: EdgeInsets.only(right: 7),
//                                        height: 10,
//                                        width: 10,
//                                        decoration: BoxDecoration(
//                                          borderRadius:
//                                              BorderRadius.circular(5),
//                                          color: Colors.redAccent,
//                                        ));
//                                  }
//                                  return Container(
//                                    height: 10,
//                                    width: 10,
//                                  );
//                                })
//                          ],
//                        ),
//                        onTap: () {
//                          Navigator.of(context).pop();
//                          Navigator.of(context).push(MaterialPageRoute(
//                              builder: (context) => SaldoDevedorScreen()));
//                        },
//                      ),

//                      ListTile(
//                        leading: Icon(Icons.show_chart),
//                        title: Text("Análises"),
//                        onTap: () {
//                          Navigator.of(context).pop();
//                          Navigator.of(context).push(MaterialPageRoute(
//                              builder: (context) => AnalisesScreen()));
//                        },
//                      ),
                      ExpansionTile(
                        leading: Icon(Icons.format_list_bulleted),
                        title: Text("Cadastros"),
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.add_location),
                            title: Text("Paradas"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ParadasScreen()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.directions_bus),
                            title: Text("Linhas"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LinhasScreen()));
                            },
                          ),

                          ListTile(
                            leading: Icon(Icons.access_alarms),
                            title: Text("Horários"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HorariosScreen()));
                            },
                          ),

                          ListTile(
                            leading: Icon(Icons.assignment_ind),
                            title: Text("Administradores"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdministradoresScreen()));
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sair"),
            onTap: () {
              _showDialog(context);
            },
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sair da conta"),
            content: Text("Deseja realmente sair da sua conta?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "SAIR",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () async {
                  _signOut();
                },
              )
            ],
          );
        });
  }

  void _signOut() {
    Navigator.of(context).pop();
//    FirebaseAuth.instance.signOut();
//    GoogleSignIn().signOut();
//
//    Navigator.of(context).pushReplacement(
//        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
