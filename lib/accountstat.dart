import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//계좌 통게
class AccountStatPage extends StatelessWidget{
  const AccountStatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('카드별 월 통계'),
        )
    );
  }

}