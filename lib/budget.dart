import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dbutil.dart';

//예산관리
class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPage createState() => new _BudgetPage();
}


class _BudgetPage extends State<BudgetPage> {
  ApplicationState _applicationState = new ApplicationState();
  //금액
  final _pricecontroller = TextEditingController();
  //카테고리
  final _categorycontroller = TextEditingController();

  Widget _buildCards(BuildContext context, DocumentSnapshot doc) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${doc['category']} : ${doc['budget'].toString()} 원'),
            Text('지출 : ${doc['used'].toString()} 원'),
            Text('남은금액 : ${(doc['budget'] - doc['used']).toString()} 원'),
          ]
      ),
    );
  }

  void addBudgetDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(

           title: const Text('예산 카테고리 추가하기'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: '카테고리'),
                  controller: _categorycontroller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: '예산금액'),
                  controller: _pricecontroller,
                ),
              ],
            ),
            actions: [
              TextButton(
                  child: Text('추가'),
                onPressed: (){
                  _applicationState.addBudget(_categorycontroller.text, int.parse(_pricecontroller.text));
                    Navigator.pop(context);
                },
              )
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

        body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('budgets')
              .snapshots(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
          return ListView.builder(
            shrinkWrap: false,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: _buildCards(context, snapshot.data!.docs[index]));
            },
          );
        })
      ),
    );
  }
}