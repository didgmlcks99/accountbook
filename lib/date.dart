import 'package:accountbook/search.dart';
import 'package:accountbook/statistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add.dart';
import 'dbutil.dart';
import 'model/item.dart';
//회원정보
class DatePage extends StatefulWidget{
  const DatePage({Key? key}) : super(key: key);

  @override
  _DatePage createState() => _DatePage();
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
                  builder: (context) => const StatisticsPage()
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
                    builder: (context) => const SearchPage()
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Center(
          child: Column(
            children: [
              showCalendar(appState),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    DateFormat('yyyy-MM-dd').format(appState.selectedDay),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    )
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPage(date: Timestamp.fromDate(appState.selectedDay))
                        ),
                      );
                    },
                  ),
                ],
              ),
              _buildList(context, appState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, ApplicationState appState){
    var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

    List<Item> items = appState.items;

    return Expanded(
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index){
          final tile = items[index].itemId;
          return Dismissible(
            key: Key(items[index].category),
            onDismissed: (direction){
              setState((){
                appState.deleteItem(items[index].itemId,
                    items[index].category,
                    items[index].price,
                    items[index].inOut,
                    items[index].date,
                );
                items.removeAt(index);
              });

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$tile deleted')));
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(items[index].category),
              subtitle: Text(items[index].memo),
              trailing: Text(
                priceFormat.format(items[index].price),
                style: TextStyle(
                  color: items[index].inOut == true ? Colors.red : Colors.blue,
                ),
              ),
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      ),
    );
  }

  showCalendar(ApplicationState appState) {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = appState.selectedDay;
    DateTime _selectedDay = appState.selectedDay;

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        appState.changedDate(selectedDay);
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
    );
  }
}