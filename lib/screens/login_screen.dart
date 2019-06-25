
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;

  bool logged = false;
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ITP"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
              width: 124,
              height: 124,
//              child: CircleAvatar(
//                  radius: 62,
//                  backgroundColor: Colors.transparent,
//                  backgroundImage:
//                  AssetImage('assets/images/bg_padrao_produto.jpg')),
            ),
            Text(
              "Onde está meu bus?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            logged
                ? Container(
              height: 50,
              child: RaisedButton(
                  child: Text("CONTINUAR"),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      // restart no app
                        MaterialPageRoute(
                            builder: (context) => MyApp(true)));
                  }),
            )
                : Container(
              height: 50,
              child: RaisedButton(
                  child: Text("ENTRAR COM O GOOGLE"),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _ensureLoggedIn();
                  }),
            ),
            message != null
                ? Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      user = await googleSignIn.signInSilently();
    }
    if (user == null) {
      user = await googleSignIn.signIn();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
      await googleSignIn.currentUser.authentication;

//      await auth.signInWithGoogle(
//          idToken: credentials.idToken, accessToken: credentials.accessToken);

      await auth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: credentials.idToken, accessToken: credentials.accessToken));


      FirebaseAuth.instance.currentUser().then((user) {
        setState(() {
          logged = true;
          message = null;
        });
      });
    }
  }
}
