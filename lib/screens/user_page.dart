import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  UserPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User page'));
  }
}