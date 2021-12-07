import 'package:flutter/material.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  const Authentication({
    required this.loginState,
    this.email,
    required this.startLoginFlow,
    required this.signInWithGoogle,
    required this.signOut,
    required this.addBudget,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(BuildContext context) signInWithGoogle;
  final void Function() signOut;
  final void Function(
      String catName, int budget
      ) addBudget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: const Text('Google Login'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            primary: Color(0XFF22a15a)
          ),
          onPressed: () async {
            startLoginFlow();
            signInWithGoogle(context);
          },
        ),
        ElevatedButton(
          child: const Text('logout'),
          style: ElevatedButton.styleFrom(
            primary : Color(0xFFabdbb8),
          ),
          onPressed: () async {
            signOut();
          },
        ),
      ],
    );
  }

  // void _showErrorDialog(BuildContext context, String title, Exception e) {
  //   showDialog<void>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           title,
  //           style: const TextStyle(fontSize: 24),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 '${(e as dynamic).message}',
  //                 style: const TextStyle(fontSize: 18),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           StyledButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(color: Colors.deepPurple),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}