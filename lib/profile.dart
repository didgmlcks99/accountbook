import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//회원정보
class ProfilePage extends StatefulWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => new _ProfilePage();
}


class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('회원 정보 '),
        )
    );
  }
}