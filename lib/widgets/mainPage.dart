import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/Functions/categorydb.dart';
import 'package:signup/widgets/cart.dart';
import 'package:signup/widgets/category.dart';
import 'package:signup/widgets/homepage.dart';
import 'package:signup/widgets/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Homepage(),
    const Category_page(),
    const Cart(),
    Profile_page(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
       decoration: const BoxDecoration(
        color: Colors.blueGrey,
      
       ), 
        child: BottomNavigationBar(
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromARGB(255, 144, 139, 139),
          currentIndex: _currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Hydooz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
