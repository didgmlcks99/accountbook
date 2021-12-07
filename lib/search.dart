import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dbutil.dart';
import 'itemdetail.dart';
import 'model/item.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}


class _SearchPage extends State<SearchPage> {

  Map<int, String> termforSearch = {0: '전체', 1: '이번주', 2: '이번달',};
  Map<int, String> cateforSearch = {0: '전체', 1: '식비', 2: '교통비', 3:'직접입력'};

  String category='전체';
  String term='전체';
  final _cateController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _cateController.dispose();
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  alignment: Alignment.centerLeft,

                  child: const Text("기간",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  ),),

                Container(
                  padding: const EdgeInsets.all(10),
                  child: ToggleSwitch(
                    minWidth: 300,
                    inactiveBgColor: Colors.white,
                    dividerColor: Colors.grey,
                    //initialLabelIndex: 0,
                    totalSwitches: 3,
                    labels: const ['전체', '이번주', '이번달'],
                    onToggle: (index) {
                      term = termforSearch.values.elementAt(index);
                      print('term : $term');
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  alignment: Alignment.centerLeft,

                  child: const Text("카테고리",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  ),),

                Container(
                  padding: const EdgeInsets.all(10),
                  child: ToggleSwitch(
                    minWidth: 300,
                    inactiveBgColor: Colors.white,
                    dividerColor: Colors.grey,
                    //initialLabelIndex: 0,
                    totalSwitches: 4,
                    labels: const ['전체', '식비', '교통비', '직접입력 '],
                    onToggle: (index) {
                      if(index==3) {
                        searchCategory();
                      } else {
                        category = cateforSearch.values.elementAt(index);
                      }
                      print('category : $category');
                    },
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(10),
                    color: Colors.black12,
                    child:
                    TextField(
                      decoration: const InputDecoration(
                          labelText: '메모 내용 검색',
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
                            }, child: const Text('검색'),),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context) => ItemDetailPage(i: items[index])
                  ),
                );
              }
            );
          }, separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        }
      )
    );
  }

  void searchCategory(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('카테고리 직접 입력'),
            content: SizedBox(
              height: 70,
              child:
                TextField(
                  decoration: const InputDecoration(labelText: '카테고리'),
                  controller: _cateController,
                ),
            ),
            actions: [
             TextButton(
                  child: const Text('완료'),
                  onPressed: (){
                    category = _cateController.text;
                    Navigator.pop(context);
                  },
                ),

            ],
          );
        }
    );
  }
}