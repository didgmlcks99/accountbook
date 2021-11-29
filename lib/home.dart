import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'budget.dart';
import 'date.dart';
import 'package:accountbook/profile.dart';

//navigation bar
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex=0;
  final List<Widget> _pagelist =[DatePage(), BudgetPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pagelist[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_cal_outlined),
              label: '날짜별 관리'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined),
              label: '예산 관리'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.layers_outlined),
              label: '회원 정보'
          ),
        ],
      ),
    );
  }
}
