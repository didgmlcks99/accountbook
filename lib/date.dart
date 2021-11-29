import 'package:accountbook/search.dart';
import 'package:accountbook/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add.dart';
//회원정보
class DatePage extends StatefulWidget{
  const DatePage({Key? key}) : super(key: key);

  @override
  _DatePage createState() => new _DatePage();
}


class _DatePage extends State<DatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.bar_chart,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StatisticsPage()
              ),
            );
          },
        ),
        title: const Text('한달내역'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage()
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPage()
                  ),
                );
              },),
          ],
        ),

      ),
    );
  }
}