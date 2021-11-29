import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  const Budget({
    required this.budget,
    required this.category,
    required this.used,
    required this.date,
  });

  final int budget;
  final String category;
  final int used;
  final Timestamp? date;
}
