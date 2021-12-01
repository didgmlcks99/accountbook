import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dbutil.dart';
import 'model/item.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}


class _SearchPage extends State<SearchPage> {

  Map<int, String> termforSearch = {0: '전체', 1: '이번주', 2: '이번달',};
  Map<int, String> cateforSearch = {0: '전체', 1: '식비', 2: 'hospital', 3:'기타'};

  String category='전체';
  String term='전체';
  final _memoController = TextEditingController();

  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('검색'),
      ),
      body: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  alignment: Alignment.centerLeft,

                  child: Text("기간",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  ),),

                Container(
                  padding: EdgeInsets.all(10),
                  child: ToggleSwitch(
                    minWidth: 300,
                    inactiveBgColor: Colors.white,
                    dividerColor: Colors.grey,
                    //initialLabelIndex: 0,
                    totalSwitches: 3,
                    labels: ['전체', '이번주', '이번달'],
                    onToggle: (index) {
                      term = termforSearch.values.elementAt(index);
                      print('term : ${term}');
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  alignment: Alignment.centerLeft,

                  child: Text("카테고리",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  ),),

                Container(
                  padding: EdgeInsets.all(10),
                  child: ToggleSwitch(
                    minWidth: 300,
                    inactiveBgColor: Colors.white,
                    dividerColor: Colors.grey,
                    //initialLabelIndex: 0,
                    totalSwitches: 3,
                    labels: ['전체', '식비', 'hospital'],
                    onToggle: (index) {
                      category = cateforSearch.values.elementAt(index);
                      print('category : ${category}');
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    color: Colors.black12,
                    child:
                    TextField(
                      decoration: const InputDecoration(
                          labelText: '메모 내용 검색',
                          focusColor: Colors.black12,
                          prefixIcon: Icon(Icons.search,),
                      ),
                      controller: _memoController,
                    ),

                ),
                Expanded(
                  child: Consumer<ApplicationState>(
                    builder: (context, appState, _) => Center(
                        child: Column(
                          children: [
                          ElevatedButton(
                            onPressed:(){
                            appState.searchItem(term, category, _memoController.text);
                            }, child: Text('검색'),
                            ),
                          searchedList(context, appState)
                          ],
                        )
                    ),
          ),
        ),
      ]),
    );
  }
  Widget searchedList(BuildContext context, ApplicationState appState){
    var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

    List<Item> items = appState.search;

    print('num of item ${items.length}');
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
          );
          }, separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        }
      )
    );
  }
}
