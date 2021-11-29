import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_calendar/table_calendar.dart';

import 'model/budget.dart';
import 'model/item.dart';
import 'src/authentication.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {

    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) async {
      if (user != null) {
        _email = user.email;
        _photoURL = user.photoURL;
        _uid = user.uid;
        _loginState = ApplicationLoginState.loggedIn;

        bool userExists = await checkUserExists(_uid!);
        print("user existence in database > " + userExists.toString() + " : " + uid!);

        if(userExists == false) addUser();

        _itemSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('items')
            .orderBy('date', descending: false)
            .snapshots()
            .listen((snapshot) {
              _items = [];
              for(var document in snapshot.docs){
                Timestamp stampDB = document.data()['date'];
                DateTime dateDB = DateTime.parse(stampDB.toDate().toString());

                if(isSameDay(dateDB, selectedDay) == true){
                  _items.add(
                    Item(
                      category: document.data()['category'].toString(),
                      memo: document.data()['memo'].toString(),
                      itemId: document.id.toString(),
                      price: document.data()['price'],
                      inOut: document.data()['inOut'],
                      date: document.data()['date'],
                    ),
                  );
                }
              }
              notifyListeners();
        });

        _budgetSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('budgets')
            .snapshots()
            .listen((snapshot){
              _budgets = [];
              for(var document in snapshot.docs){
                _budgets.add(
                  Budget(
                    budget: document.data()['budget'],
                    category: document.data()['category'].toString(),
                    used: document.data()['used'],
                    date: document.data()['date'],
                  ),
                );
              }
              notifyListeners();
        });

      } else {
        _items = [];
        _itemSubscription?.cancel();

        _budgets = [];
        _budgetSubscription?.cancel();

        print("user logged out > " + _uid!);

        _email = null;
        _photoURL = null;
        _uid = null;
        _loginState = ApplicationLoginState.loggedOut;

      }
      notifyListeners();
    });

  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _photoURL;
  String? get photoURL => _photoURL;

  String? _email;
  String? get email => _email;

  String? _uid;
  String? get uid => _uid;

  StreamSubscription<QuerySnapshot>? _itemSubscription;
  List<Item> _items = [];
  List<Item> get items => _items;

  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  StreamSubscription<QuerySnapshot>? _budgetSubscription;
  List<Budget> _budgets = [];
  List<Budget> get budgets => _budgets;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.register;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    print("user logged in > " + uid!);

    _loginState = ApplicationLoginState.loggedIn;

    notifyListeners();

    Navigator.pop(context);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    print("user logged out > " + uid!);

    _loginState = ApplicationLoginState.loggedOut;

    notifyListeners();
  }

  Future<bool> checkUserExists(String userId) async {
    try {
      var collectionRef = FirebaseFirestore.instance
          .collection('users');

      var doc = await collectionRef.doc(userId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  // 새로운 유저가 가입 했을 때
  Future<void> addUser() async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(({
      'email': FirebaseAuth.instance.currentUser!.email,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'total_asset': 0,
      'uid': uid,
    }));

    // budgets에 고정인, total_budget 만들어줘야하며 초기 값은 0으로 지정
    addBudget("total_budget", 0,);

    print("adding new user to database (with initial total_budget) > " + uid!);
  }

  // 새로 예산 정보 추가 했을 때
  // 아번 달에 해당 카테고리에 지출한거 있는지 확인하고 used 설정 (total used도 설정)
  Future<void> addBudget(String catName, int budget) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .doc(catName)
        .set({
      'category': catName,
      'budget': budget,
      'used': 0,
      'date': FieldValue.serverTimestamp(),
    });

    print("budget added to database > " + catName + " : " + budget.toString());

    if(catName != "total_budget"){
      updateTotalBudget(catName, budget);
      checkForUsed(catName, budget);
    }

  }

  // 새로운 예산 추가 되었을 때, 총 예산에 정보 반영
  Future<void> updateTotalBudget(String catName, int budget) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    var totDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .doc('total_budget')
        .get();
    
    Map<String, dynamic>? totData = totDoc.data();
    int initialTotal = totData?['budget'] ;
    int changedTotal = initialTotal + budget;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .doc('total_budget')
        .update({'budget':changedTotal});

    print("update to total_budget with new budget > +" + budget.toString());
  }

  Future<void> checkForUsed(String catName, int budget) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    // Timestamp stampCur = (FieldValue.serverTimestamp() as Timestamp);
    DateTime currDate = DateTime.now(); //DateTime.parse(stampCur.toDate().toString());

    List<int> prices = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            Timestamp stampDB = doc['date'];
            DateTime dateDB = DateTime.parse(stampDB.toDate().toString());

            String catDB = doc['category'];

            bool inOut = doc['inOut'];

            if((dateDB.year == currDate.year)
                && (dateDB.month == currDate.month)
                && (catDB == catName)
                && (inOut == true)) {
              // int outPrice = doc['price'];
              prices.add(doc['price']);
              // updateUsedBudget(catDB, outPrice);
            }

          }
        });

    int outPrice = 0;

    for(int i in prices){
      outPrice += i;
    }

    updateUsedBudget(catName, outPrice);
  }

  // 새로 지출/수입 추가 했을 때
  Future<void> addItem(String category, bool inOut, int price, String memo, Timestamp date) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .add(<String, dynamic>{
      'category': category,
      'date': date,
      'inOut': inOut,
      'memo': memo,
      'price': price,
    });

    print("item added to database > " + category + " : " + price.toString());

    Timestamp stampDB = date;
    DateTime dateDB = DateTime.parse(stampDB.toDate().toString());

    DateTime currDate = DateTime.now();

    if((dateDB.year == currDate.year)
        && (dateDB.month == currDate.month)
        && (inOut == true)){
      updateUsedBudget(category, price);
    }
  }

  Future<void> updateUsedBudget(String category, int outPrice) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    bool budgetExists = await checkBudgetExists(category);

    if(budgetExists){
      print("start updating used in budget");

      var catDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc(category)
          .get();

      Map<String, dynamic>? catData = catDoc.data();
      int initialUsed = catData?['used'];
      int changedUsed = initialUsed + outPrice;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc(category)
          .update({'used': changedUsed});

      print("updated 'used' to budget category > " + category + " : " + outPrice.toString());

      var totDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc('total_budget')
          .get();

      Map<String, dynamic>? totData = totDoc.data();
      int initTotUsed = totData?['used'] ;
      int changedTotUsed = initTotUsed + outPrice;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc('total_budget')
          .update({'used': changedTotUsed});

      print("updated used to tot_budget category > " + outPrice.toString());
    }else{
      print("the budget doesn't exist for this item's category");
    }
  }

  Future<bool> checkBudgetExists(String catId) async {
    try {
      var collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('budgets');

      var doc = await collectionRef.doc(catId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  // 지출/수입 기록 삭제 하였을 때
  Future<void> deleteItem(String itemId, String category, int outPrice, bool inOut, Timestamp? date) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .doc(itemId)
        .delete()
        .then((value) => print("item deleted from database"))
        .catchError((error) => print("failed deletion"));

    bool budgetExists = await checkBudgetExists(category);

    Timestamp stampDB = date!;
    DateTime dateDB = DateTime.parse(stampDB.toDate().toString());

    DateTime currDate = DateTime.now();

    if((dateDB.year == currDate.year)
        && (dateDB.month == currDate.month)
        && (inOut == true)){
      updateUsedBudget(category, (outPrice * -1));
    }
  }

  // 달력에서 선택된 날짜가 바뀌었을 때
  Future<void> changedDate(DateTime dateTime) async{
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    _selectedDay = dateTime;

    _items = [];
    _itemSubscription?.cancel();

    notifyListeners();

    _itemSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .orderBy('date', descending: false)
        .snapshots()
        .listen((snapshot) {
      _items = [];
      for(var document in snapshot.docs){
        Timestamp stampDB = document.data()['date'];
        DateTime dateDB = DateTime.parse(stampDB.toDate().toString());

        if(isSameDay(dateDB, selectedDay) == true){
          _items.add(
            Item(
              category: document.data()['category'].toString(),
              memo: document.data()['memo'].toString(),
              itemId: document.id.toString(),
              price: document.data()['price'],
              inOut: document.data()['inOut'],
              date: document.data()['date'],
            ),
          );
        }
      }
      notifyListeners();
    });

  }
}