import 'package:flutter/material.dart';

class PutPayPage extends StatefulWidget {
  PutPayPage({
    super.key,
    
  });

  @override
  State<StatefulWidget> createState() => _PutPayPageState();
}

class _PutPayPageState extends State<PutPayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New pay'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
        child:  Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title'
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Debtor'
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount'
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date'
              ),
            ),
          ],
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsetsGeometry.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FilledButton(
            onPressed: (){},
            child: const Text('Save')
          ),
        )
      ],
    );
  }
}