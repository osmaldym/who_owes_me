import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
import 'package:who_owes_me/router/route.dart' as app;
import 'package:who_owes_me/screens/home_page.dart';
import 'package:who_owes_me/screens/pay_page.dart';
import 'package:who_owes_me/screens/settings_page.dart';
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
  final SettingsPage _settingsPage = SettingsPage();

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
      _settingsPage,
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
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.users,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.money),
            label: AppLocalizations.of(context)!.pays,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 || _selectedIndex == 3 ? null : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          switch (_selectedIndex) {
            case 0:
              context.push(app.Route.usersPut).then((_) {
                _userPage.getState()!.updateState();
              });
              break;
            case 2:
              context.push(app.Route.paysPut).then((_) {
                _duePage.getState()!.updateState();
              });
              break;
          }
        }
      ),
    );
  }
}