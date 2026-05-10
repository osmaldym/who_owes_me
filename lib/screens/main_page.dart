import 'package:flutter/material.dart';
import 'package:who_owes_me/screens/home_page.dart';
import 'package:who_owes_me/screens/pay_page.dart';
import 'package:who_owes_me/screens/user_page.dart';

class MainPage extends StatefulWidget {
  MainPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final PageController _pageController = PageController(initialPage: 1);
  int _selectedIndex = 1;

  // This list stores the screens for each tab
  final List<Widget> _screens = [
    PayPage(),
    HomePage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello World')),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _selectedIndex = index;
        }),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Pays',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}