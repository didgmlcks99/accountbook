import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//계좌 목록
class AccountPage extends StatefulWidget{
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPage createState() => new _AccountPage();
}


class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('카드'),
        )
    );
  }
}