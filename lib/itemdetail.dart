
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/item.dart';

class ItemDetailPage extends StatefulWidget{
  const ItemDetailPage({Key? key, required this.i}) : super(key: key);

  final Item i;

  @override
  _ItemDetailPage createState() => _ItemDetailPage();
}

class _ItemDetailPage extends State<ItemDetailPage>{

  @override
  Widget build(BuildContext context) {

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('detail'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              formatter.format(widget.i.date!.toDate()),
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              widget.i.category,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50,),
            Row(
              children: [
                const Text(
                  '금액',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey
                  ),
                ),
                Container(
                  alignment: const Alignment(1,0),
                  padding: const EdgeInsets.all(20),
                  width: 310,
                  child: Text(
                      priceFormat.format(widget.i.price),
                      style: TextStyle(
                        fontSize: 30,
                        color: widget.i.inOut == true ? Colors.red : Colors.blue,
                      ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '메모',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Container(
                  alignment: const Alignment(1,0),
                  padding: const EdgeInsets.all(20),
                  width: 310,
                  child: Text(
                    widget.i.memo,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
            Row(
              children: [
                const Text(
                  '위치',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey
                  ),
                ),
                Container(
                  alignment: const Alignment(1,0),
                  padding: const EdgeInsets.all(20),
                  width: 310,
                  child: Text(
                    widget.i.address,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),

         ],
        ),
      ),
    );
  }
}

