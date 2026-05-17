import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/router/route.dart' as app;
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
  final UserPage _userPage = UserPage();
  final HomePage _homePage = HomePage();
  final DuePage _duePage = DuePage();

  final PageController _pageController = PageController(initialPage: 1);
  int _selectedIndex = 1;

  // This list stores the screens for each tab
  List<Widget>? _screens;

  @override
  void initState() {
    _screens = [
      _userPage,
      _homePage,
      _duePage,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Who Owes Me')),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _selectedIndex = index;
        }),
        children: _screens!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Pays',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 ? null : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          switch (_selectedIndex) {
            case 0:
              context.push(app.Route.usersNew).then((_) {
                _userPage.getState()!.updateState();
              });
              break;
            case 2:
              context.push(app.Route.paysNew).then((_) {
                _duePage.getState()!.updateState();
              });
              break;
          }
        }
      ),
    );
  }
}