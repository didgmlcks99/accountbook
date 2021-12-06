import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'dbutil.dart';
import 'itemdetail.dart';
import 'model/budget.dart';
import 'model/item.dart';

class BudgetDetailPage extends StatefulWidget{
  const BudgetDetailPage({Key? key, required this.mainBudget}) : super(key: key);

  final Budget mainBudget;

  @override
  _BudgetDetailPage createState() => _BudgetDetailPage();
}

class _BudgetDetailPage extends State<BudgetDetailPage>{
  var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

  mainBudget(Budget main){
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                main.category + " : " + priceFormat.format(main.budget),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
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
                percent: getBarPercent(main.used, main.budget),
                center: getStringPercent(main.used, main.budget),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: getBarColor(main.used, main.budget),
              ),
            ),
            ListTile(
              title: Text(
                '사용 금액 : ' + priceFormat.format(main.used),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              trailing: Text(
                '남은 금액 : ' + priceFormat.format(main.budget - main.used),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('\'' + widget.mainBudget.category + '\' 예산 상세 정보'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: <Widget>[
            mainBudget(widget.mainBudget),
            buildDetailedList(context, appState),
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

  buildDetailedList(BuildContext context, ApplicationState appState) {
    List<Item> items = appState.budgetDetailItem;

    return Expanded(
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index){
          return ListTile(
              title: Text(items[index].category),
              subtitle: Text(items[index].memo),
              trailing: Text(
                priceFormat.format(items[index].price),
                style: TextStyle(
                  color: items[index].inOut == true ? Colors.red : Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetailPage(i: items[index])
                  ),
                );
              }
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}

