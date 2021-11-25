import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final globalScaffoldKey = GlobalKey<ScaffoldState>();

class AddPage extends StatefulWidget{
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<AddPage>{
  _AddPage();

  //입금/지출
  List<bool> isSelected = List.generate(2, (index) => false);
  //금액
  final _pricecontroller = TextEditingController();
  //카테고리
  final _categorycontroller = TextEditingController();
  //현금/카드 선택
  // final paymentList = ['cash','nonghyup', 'kookmin']; //db에서 리스트 갖고오기..
  // var payment='cash';

  @override
  void dispose(){
    _pricecontroller.dispose();
    _categorycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference userRef = FirebaseFirestore.instance.collection('users');

    Future<void> addItem() async {
      try{
          userRef.doc(FirebaseAuth.instance.currentUser!.uid).collection('items').add({
          'category': _categorycontroller.text,
          'isIncome': (isSelected[0]==true)? true : false,
          'price': int.parse(_pricecontroller.text),
          'date': Timestamp.now(),
        });
      }catch (e){
        print(e);
      }
     }

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
            TextButton(
                child: const Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 17),),
                onPressed: (){
                  addItem();
                  Navigator.pop(context);
                }
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
                    decoration: const InputDecoration(labelText: '금액'),
                    controller: _pricecontroller,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '카테고리'),
                    controller: _categorycontroller,
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
