import 'package:flutter/material.dart';

class PayPage extends StatefulWidget {
  PayPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Pay page'));
  }
}