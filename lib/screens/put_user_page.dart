import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/user.dart';

class PutUserPage extends StatefulWidget {
  User? user;

  PutUserPage({
    super.key,
    this.user,
  });

  @override
  State<StatefulWidget> createState() => _PutUserPageState();
}

class _PutUserPageState extends State<PutUserPage> {
  final Dao _dao = Dao();
  bool _loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.user?.name ?? '';
    _emailController.text = widget.user?.email ?? '';
    _phoneController.text = widget.user?.phone ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${ widget.user != null ? 'Edit' : 'New' } user'),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child:  Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name'
              ),
              controller: _nameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email'
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone number'
              ),
              keyboardType: TextInputType.phone,
              controller: _phoneController,
            ),
          ],
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterDecoration: const BoxDecoration(),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsetsGeometry.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(15),
            child: FilledButton(
              onPressed: _loading ? null : () async {
                setState(() { _loading = true; });

                User user = User(
                  id: widget.user?.id,
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                );

                int insertedRows = await _dao.putUser(user);

                if (insertedRows > 0 && context.mounted) context.pop();

                setState(() { _loading = false; });
              },
              child: _loading ? const CircularProgressIndicator() : const Text('Save')
            )
          ),
        )
      ],
    );
  }
}