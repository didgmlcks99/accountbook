import 'package:accountbook/src/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dbutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 200.0),
            // Column(
            //   children: <Widget>[
            //     Image.asset('assets/diamond.png'),
            //     const SizedBox(height: 16.0),
            //     const Text('SHRINE'),
            //   ],
            // ),
            const SizedBox(height: 120.0),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => Authentication(
                email: appState.email,
                loginState: appState.loginState,
                startLoginFlow: appState.startLoginFlow,
                signInWithGoogle: appState.signInWithGoogle,
                signOut: appState.signOut,
                addBudget: appState.addBudget,
              )
            ),
            const SizedBox(height: 12.0),
            ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('NEXT'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}