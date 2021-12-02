import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'dbutil.dart';
import 'model/item.dart';
class DetailPage extends StatefulWidget{
  final Item i;
  const DetailPage(this.i);

  @override
  _DetailPage createState() => _DetailPage(this.i);
}

class _DetailPage extends State<DetailPage>{
  final Item i;
  _DetailPage(this.i);

  @override
  Widget build(BuildContext context) {

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('detail'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(formatter.format(i.date!.toDate()),
              style: TextStyle(fontSize: 20),),
              Text(i.category,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              Row(
                children: [
                  Text('금액',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                  Container(
                    alignment: Alignment(1,0),
                    padding: EdgeInsets.all(20),
                    width: 310,
                    child: Text(priceFormat.format(i.price),
                        style: TextStyle(fontSize: 30,
                          color: i.inOut == true ? Colors.red : Colors.blue,)),
                  )
                ],
              ),

              Row(
                children: [
                  Text('메모',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                  Container(
                      alignment: Alignment(1,0),
                      padding: EdgeInsets.all(20),
                    width: 310,
                      child: Text(i.memo,
                          style: TextStyle(fontSize: 20,
                          ))),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text('위치',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                  ],
              ),
              SizedBox(height: 30,),
           ],
          ),
        ),
    );
  }

}

/*
 FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('items').doc(id)
        .get().then((DocumentSnapshot ds){
          i= new
            Item(
                category: ds["category"],date: ds["date"],memo:ds["memo"],
                inOut: ds["inOut"], price:ds["price"], itemId: id
            );

        });
 */