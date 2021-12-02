import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dbutil.dart';
//회원정보
class ProfilePage extends StatefulWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}


class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('회원 정보'),
      ),
      body: Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children: <Widget>[
              const SizedBox(height: 30.0),
              proPic(appState.photoURL),
              const SizedBox(height: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            ifEmail(appState.email),
                          ),
                          subtitle: Text(
                            ifName(appState.name),
                          )
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            child: const Text(
                              '로그아웃',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  proPic(String? photoURL) {
    if(photoURL != null){
      return Image.network(
        photoURL,
        width: 200,
        height: 200,
        fit: BoxFit.fill,
      );
    }
    else{
      return Image.network(
        'https://handong.edu/site/handong/res/img/logo.png',
        width: 200,
        height: 200,
        fit: BoxFit.fill,
      );
    }
  }

  ifEmail(String? email) {
    if(email != null){
      return email;
    }else{
      return "Anonymous";
    }
  }

  String ifName(String? name) {
    if(name != null){
      return name;
    }else{
      return "이름 없음";
    }
  }
}