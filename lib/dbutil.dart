import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'model/budget.dart';
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
        print(user.uid + ': User is signed in!');

        bool userExists = await checkUserExists(_uid!);
        print("User exists in Firestore? " + userExists.toString());

        if(userExists == false) addUser();

        // _productSubscription = FirebaseFirestore.instance
        //     .collection('products')
        //     .orderBy('productPrice', descending: false)
        //     .snapshots()
        //     .listen((snapshot){
        //   _products = [];
        //   for(var document in snapshot.docs){
        //     print("Products: " + document.id);
        //     _products.add(
        //       Product(
        //         picUrl: document.data()['picUrl'].toString(),
        //         ownerId: document.data()['ownerId'].toString(),
        //         ownerName: document.data()['ownerName'].toString(),
        //         productCreated: document.data()['productCreated'],
        //         productModified: document.data()['productModified'],
        //         docId: document.id.toString(),
        //         productName: document.data()['productName'].toString(),
        //         productPrice: document.data()['productPrice'].toString(),
        //         productDesc: document.data()['productDesc'].toString(),
        //         productLikes: document.data()['productLikes'].toString(),
        //       ),
        //     );
        //   }
        //   notifyListeners();
        // });

      } else {
        _loginState = ApplicationLoginState.loggedOut;

        print(': User is currently signed out!');
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

    _loginState = ApplicationLoginState.loggedIn;

    print(_loginState.toString());

    notifyListeners();

    Navigator.pop(context);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    _loginState = ApplicationLoginState.loggedOut;
    print(_loginState.toString());
    notifyListeners();
  }

  Future<bool> checkUserExists(String userId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users');

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

    FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .set(({
      'email': FirebaseAuth.instance.currentUser!.email,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'total_asset': 0,
      'uid': uid,
    }));

    // budgets에 고정인, total_budget 만들어줘야하며 초기 값은 0으로 지정
    addBudget("total_budget", 0,);

    print("user added to database, with default total_budget");
  }

  // 새로 예산 정보 추가 했을 때
  //아번 달에 해당 카테고리에 지출한거 있는지 확인하고 used 설정 (total used도 설정)
  Future<void> addBudget(String catName, int budget) async {
    print(_loginState.toString());

    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    print("budget added to database");

    if(catName != "total_budget"){
      updateTotalBudget(budget);
      print("updated total_budget");
    }

    return FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection('budgets')
        .doc(catName)
        .set({
      'category': catName,
      'budget': budget,
      'used': 0,
    });

  }

  Future<void> updateTotalBudget(int budget) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    var ds = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .doc('total_budget')
        .get();
    
    Map<String, dynamic>? data = ds.data();
    int initialTotal = data?['budget'] ;
    int changedTotal = initialTotal + budget;

    return FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection('budgets')
        .doc('total_budget')
        .update({'budget':changedTotal});
  }


  // 계정 새로 추가 했을 때
  Future<void> addAccount(String accName, String bankName, String accNum) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    print("account added to database");

    return FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection('accounts')
        .doc(accName)
        .set({
      'bank_name': bankName,
      'account_num': accNum,
      'current_asset': 0,
    });
  }

  // 새로 지출/수입 추가 했을 때
  Future<DocumentReference> addItem(String accName, String category, bool inOut, String memo, int price) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    print("item added to database");

    return FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection('items')
        .add(<String, dynamic>{
      'account': accName,
      'category': category,
      'date': FieldValue.serverTimestamp(),
      'in_out': inOut,
      'memo': memo,
      'price': price,
    });
  }
}