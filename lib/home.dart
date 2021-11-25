import 'package:accountbook/search.dart';
import 'package:accountbook/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add.dart';
//날짜별관
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.bar_chart,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StatisticsPage()
              ),
            );
          },
        ),
        title: const Text('한달내역'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchPage()
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPage()
                  ),
                );
              },
            ),
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.layers_outlined),
              label: '계좌별 관리'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_cal_outlined),
              label: '날짜별 관리'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined),
              label: '예산 관리'
          ),
        ],
      ),
    );
  }
}
