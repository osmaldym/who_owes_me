import 'package:flutter/material.dart';

class MainProvider extends InheritedWidget {
  final ValueNotifier<ThemeMode> notifier;

  const MainProvider({
    super.key,
    required this.notifier,
    required super.child,
  });

  static MainProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MainProvider>();

  @override
  bool updateShouldNotify(covariant MainProvider oldWidget) => notifier != oldWidget.notifier;
}