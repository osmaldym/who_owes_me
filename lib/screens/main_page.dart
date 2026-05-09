import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // This list stores the screens for each tab
  final List<Widget> _screens = [
    Center(child: Text('Pay Screen')),
    Center(child: Text('Home Screen')),
    Center(child: Text('User Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello World')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight the selected tab
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
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