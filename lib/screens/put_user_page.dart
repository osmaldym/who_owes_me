import 'package:flutter/material.dart';

class PutUserPage extends StatefulWidget {
  PutUserPage({
    super.key,
    
  });

  @override
  State<StatefulWidget> createState() => _PutUserPageState();
}

class _PutUserPageState extends State<PutUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New user'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
        child:  Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name'
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email'
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone number'
              ),
              keyboardType: TextInputType.phone,
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