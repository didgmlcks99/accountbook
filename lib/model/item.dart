import 'package:cloud_firestore/cloud_firestore.dart';

class Item{
  Item({
    required this.category,
    required this.memo,
    required this.itemId,
    required this.price,
    required this.inOut,
    required this.date,
  });

  final String category;
  final String memo;
  final String itemId;
  final int price;
  final bool inOut;
  final Timestamp? date;

}