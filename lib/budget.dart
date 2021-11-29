import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dbutil.dart';
import 'model/budget.dart';

//예산관리
class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPage createState() => _BudgetPage();
}


class _BudgetPage extends State<BudgetPage> {
  //금액, 카테고리
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

  Widget _buildCards(BuildContext context, Budget doc/*DocumentSnapshot doc*/) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              doc.category + " : " + priceFormat.format(doc.budget),
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            Text(
              '지출 : ' + priceFormat.format(doc.used),
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            Text(
              '남은금액 : ' + priceFormat.format(doc.budget - doc.used),
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
          ],
      ),
    );
  }

  void addBudgetDialog(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
           title: const Text('예산 카테고리 추가하기'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: '카테고리'),
                  controller: _categoryController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: '예산금액'),
                  controller: _priceController,
                ),
              ],
            ),
            actions: [
              Consumer<ApplicationState>(
                builder: (context, appState, _) => TextButton(
                  child: const Text('추가'),
                  onPressed: (){
                    appState.addBudget(_categoryController.text, int.parse(_priceController.text));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('예산 관리 '),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () => addBudgetDialog(),
            ),
          ],
        ),
        body: Consumer<ApplicationState>(
          builder: (context, appState, _) => _buildTiles(context, appState),
        ),
    );
  }

  _buildTiles(BuildContext context, ApplicationState appState){
    List<Budget> budgets = appState.budgets;

    return ListView.builder(
      shrinkWrap: false,
      itemCount: budgets.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            child: _buildCards(context, budgets[index]));
      },
    );
  }
}