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

  Widget _buildTiles(BuildContext context, Budget doc, ApplicationState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Text(
            doc.category + " : " + priceFormat.format(doc.budget),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
        ),
        ListTile(
          title: Text(
            '지출 : ' + priceFormat.format(doc.used),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          subtitle: Text(
            '남은금액 : ' + priceFormat.format(doc.budget - doc.used),
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            child: const Text(
              '삭제',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () {
              appState.deleteBudget(doc.category, doc.budget, doc.used);
            },
          ),
        ),
      ],
    );

      // child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Text(
      //         doc.category + " : " + priceFormat.format(doc.budget),
      //         style: const TextStyle(
      //           color: Colors.blue,
      //         ),
      //       ),
      //       Text(
      //         '지출 : ' + priceFormat.format(doc.used),
      //         style: const TextStyle(
      //           color: Colors.red,
      //         ),
      //       ),
      //       Text(
      //         '남은금액 : ' + priceFormat.format(doc.budget - doc.used),
      //         style: const TextStyle(
      //           color: Colors.green,
      //         ),
      //       ),
      //     ],
      // ),
    // );
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
        body:

        Consumer<ApplicationState>(
          builder: (context, appState, _) => Center(
            child: Column(
              children: <Widget> [
                makeMainBudget(appState),
                _buildEachCard(context, appState)
              ],
            ),
          ),
        ),
    );
  }

  _buildEachCard(BuildContext context, ApplicationState appState){
    List<Budget> budgets = appState.budgets;

    return Expanded(
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: budgets.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: _buildTiles(context, budgets[index], appState));
          },
        ),
    );

  }

  makeMainBudget(ApplicationState appState) {
    List<Budget> mainBudget = appState.mainBudget;

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /// 둘중에 어떤 디자인이 좋은지 선
            // Padding(
            //   padding: const EdgeInsets.all(5),
            //   child: Text(
            //     mainBudget[0].category + " : " + priceFormat.format(mainBudget[0].budget),
            //     style: const TextStyle(
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(5),
            //   child: Text(
            //     '사용 금액 : ' + priceFormat.format(mainBudget[0].used),
            //     style: const TextStyle(
            //       color: Colors.red,
            //     ),
            //   ),
            // ),
            // Padding(
            //     padding: const EdgeInsets.all(5),
            //     child: Text(
            //       '남은 금액 : ' + priceFormat.format(mainBudget[0].budget - mainBudget[0].used),
            //       style: const TextStyle(
            //         color: Colors.green,
            //       ),
            //     ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                mainBudget[0].category + " : " + priceFormat.format(mainBudget[0].budget),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text(
                '사용 금액 : ' + priceFormat.format(mainBudget[0].used),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: Text(
                '남은 금액 : ' + priceFormat.format(mainBudget[0].budget - mainBudget[0].used),
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}