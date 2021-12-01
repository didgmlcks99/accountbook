import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'dbutil.dart';
class StatisticsPage extends StatefulWidget{
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPage createState() => _StatisticsPage();
}

class _StatisticsPage extends State<StatisticsPage>{


  @override
  Widget build(BuildContext context) {
    String month = DateTime.now().month.toString() + '월';

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(month),
        ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Center(

        child: PieChart(
        dataMap: appState.categories,
        animationDuration: Duration(seconds: 2),
        chartLegendSpacing: 30,
        chartRadius: MediaQuery.of(context).size.width / 1.2,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      )
      ),
      ));
  }

}