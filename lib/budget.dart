import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'budgetdetail.dart';
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
        Row(children: [
          Container(
            width: 330,
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text(
              doc.category + " : " + priceFormat.format(doc.budget),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0XFF108030),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              appState.deleteBudget(doc.category, doc.budget, doc.used);

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(doc.category + ' deleted')));
            },
            icon: const Icon(Icons.delete_outlined,
            color: Colors.grey,
            ),
          ),
        ],),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 50,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: getBarPercent(doc.used, doc.budget),
            center: getStringPercent(doc.used, doc.budget),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: getBarColor(doc.used, doc.budget),
          ),
        ),
        ListTile(
          title: Text(
            '지출 : ' + priceFormat.format(doc.used),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          trailing: Text(
            '남은금액 : ' + priceFormat.format(doc.budget - doc.used),
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  void addBudgetDialog(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
           title: const Text('예산 카테고리 추가하기'),
            content: SizedBox(
              height: 130,
              child: Column(
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
            return InkWell(
              child: Card(
                  child: _buildTiles(context, budgets[index], appState)
              ),
              onTap: (){
                appState.budgetDetail(budgets[index].category, DateTime.now());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context) => BudgetDetailPage(mainBudget: budgets[index],)
                  ),
                );
              },
            );
          },
        ),
    );

  }

  makeMainBudget(ApplicationState appState) {
    List<Budget> mainBudget = appState.mainBudget;

    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                "총 예산 : " + priceFormat.format(mainBudget[0].budget),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0XFF108030),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: getBarPercent(mainBudget[0].used, mainBudget[0].budget),
                center: getStringPercent(mainBudget[0].used, mainBudget[0].budget),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: getBarColor(mainBudget[0].used, mainBudget[0].budget),
              ),
            ),
            ListTile(
              title: Text(
                '총 지출 : ' + priceFormat.format(mainBudget[0].used),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                '남은 금액 : ' + priceFormat.format(mainBudget[0].budget - mainBudget[0].used),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBarPercent(int used, int budget) {
    if(used > budget){
      return 1.0;
    }else if(budget == 0){
      return 0.0;
    }else{
      return used / budget;
    }
  }

  getBarColor(int used, int budget) {
    double d;

    if(budget == 0){
      return Colors.greenAccent;
    }else{
      d = ((used / budget)*100);

      if(d < 20.0){
        return Colors.greenAccent;
      }else if(d >= 20 && d < 40){
        return Colors.lightGreenAccent;
      }else if(d >= 40 && d < 60){
        return Colors.limeAccent;
      }else if(d >= 60 && d < 80){
        return Colors.deepOrangeAccent;
      }else if(d >= 80 && d < 90){
        return Colors.redAccent;
      }else if(d >= 90){
        return Colors.red;
      }

    }
  }

  getStringPercent(int used, int budget) {
    if(budget == 0){
      return const Text("0.00%");
    }else{
      return Text(((used / budget)*100).toStringAsFixed(2) + "%");
    }
  }

}