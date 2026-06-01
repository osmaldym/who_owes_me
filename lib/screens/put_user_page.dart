import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/user.dart';
import 'package:who_owes_me/utils/utils.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dao _dao = Dao();
  bool _loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final _phoneRegex = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');

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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
          child:  Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'John Due',
                  hintFadeDuration: Duration(milliseconds: 100),
                  label: Row(
                    spacing: 5,
                    children: [
                      Text('\u2217', style: TextStyle(color: Colors.red)),
                      Text('Name'),
                    ],
                  ),
                ),
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'This field cannot be empty.';
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'john.due@whoowesme.com',
                  hintFadeDuration: Duration(milliseconds: 100),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if ((value != null && value.isNotEmpty) && !_emailRegex.hasMatch(value)) return 'Invalid email.';
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '+10000000000',
                  hintFadeDuration: Duration(milliseconds: 100),
                  labelText: 'Phone number'
                ),
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneNumberFormatter(),
                ],
                validator: (value) {
                  if ((value != null && value.isNotEmpty) && !_phoneRegex.hasMatch(value)) return 'Invalid phone number.';
                  return null;
                },
              ),
            ],
          ),
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

                if (_formKey.currentState!.validate()) {
                  User user = User(
                    id: widget.user?.id,
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                  );

                  int insertedRows = await _dao.putUser(user);

                  if (insertedRows > 0 && context.mounted) context.pop();
                }

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