import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dbutil.dart';

final globalScaffoldKey = GlobalKey<ScaffoldState>();

class AddPage extends StatefulWidget{
  const AddPage({Key? key, required this.date}) : super(key: key);

  final Timestamp date;

  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<AddPage>{
  _AddPage();

  //입금/지출, 금액, 카테고리, 메
  List<bool> isSelected = List.generate(2, (index) => false);
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _memoController = TextEditingController();

  //현금/카드 선택
  // final paymentList = ['cash','nonghyup', 'kookmin']; //db에서 리스트 갖고오기..
  // var payment='cash';

  @override
  void dispose(){
    _categoryController.dispose();
    _priceController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: globalScaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            child: const Text('Cancel',
              style: TextStyle(color: Colors.white, fontSize: 12),),
            onPressed: () {
              Navigator.pop(context,'');
            },
          ),
          title: const Text('Add'),
          actions: <Widget>[
            Consumer<ApplicationState>(
              builder: (context, appState, _) => TextButton(
                child: const Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: (){
                  appState.addItem(
                    _categoryController.text,
                    (isSelected[0]==true)? true : false,
                    int.parse(_priceController.text),
                    _memoController.text,
                    widget.date,
                  );
                  Navigator.pop(context);
                }
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                children: [
                  ToggleButtons(children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('지출'),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('수입'),
                    ),
                  ],
                  onPressed: (int index){
                    setState(() {
                      for(int i=0; i<isSelected.length; i++){
                        isSelected[i] = i ==index;
                      }
                    });
                  },
                    isSelected: isSelected,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '카테고리'),
                    controller: _categoryController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '금액'),
                    controller: _priceController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '메모'),
                    controller: _memoController,
                  ),
                  // DropdownButton(
                  //     value: payment,
                  //     items: paymentList.map((value){
                  //       return DropdownMenuItem(
                  //           child: Text(value),
                  //         value: value,);
                  //     },).toList(),
                  //   onChanged: (value){
                  //     setState((){
                  //       payment = value.toString();
                  //   });
                  //   }),
                ],
              ),
            )
          ],
        )
    );
  }
}
