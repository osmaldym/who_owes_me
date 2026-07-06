import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/user.dart';
import 'package:intl/intl.dart';
import 'package:who_owes_me/utils/utils.dart';

class PutPayPage extends StatefulWidget {
  Pay? pay;

  PutPayPage({
    super.key,
    this.pay,
  });

  @override
  State<StatefulWidget> createState() => _PutPayPageState();
}

class _PutPayPageState extends State<PutPayPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dao _dao = Dao();
  DateFormat format = DateFormat("yyyy/MM/dd");

  Future<List<User>>? _getAllUsers;
  User? _selectedUser;

  DateTime? _selectedDate;
  
  bool usersEmpty = false;
  bool _loading = false;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _date = TextEditingController();

  @override
  void initState() {
    _getAllUsers = _dao.getAllUsers();

    _selectedDate = widget.pay?.date;

    _title.text = widget.pay?.title ?? '';
    _amount.text = widget.pay?.amount != null ? widget.pay!.amount!.toString() : '';
    _date.text = _selectedDate != null ? format.format(_selectedDate!) : '';

    super.initState();
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime fiveYears = DateTime(now.year + 5, now.month, now.day);

    _selectedDate = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: _selectedDate,
      lastDate: fiveYears,
    );

    if (_selectedDate != null) {
      _date.text = format.format(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${ widget.pay != null ? 'Edit' : 'New' } pay'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Due of John Due',
                  hintFadeDuration: Duration(milliseconds: 100),
                  label: Row(
                    spacing: 5,
                    children: [
                      Text('\u2217', style: TextStyle(color: Colors.red),),
                      Text('Title'),
                    ],
                  ),
                ),
                controller: _title,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'This field cannot be empty.';
                  if (value.length < 4) return 'This field needs to be greater than 4 characters.';
                  return null;
                },
              ),
              FutureBuilder(
                future: _getAllUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    List<User>? users = snapshot.data;

                    /**
                     * This cannot be refactorized because the instances of imaginary RelatedPay will be different of
                     * the users array, throwing error if I can access to the instance of user in RelatedPay.
                     */
                    if (widget.pay?.userId != null && _selectedUser == null) {
                      _selectedUser = users?.firstWhere((user) => user.id == widget.pay!.userId!);
                    }

                    if (users?.length == 1) _selectedUser = users?.first;

                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Debtor',
                      ),
                      initialValue: _selectedUser,
                      items: users?.map<DropdownMenuItem<User>>((User user) => DropdownMenuItem(
                        value: user,
                        child: Text(user.name ?? 'Unknown user')
                      )).toList(),
                      onChanged: (obj) => _selectedUser = obj,
                    );
                  }
                  return const Text('No users to show');
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixText: "\$",
                  hintText: '1,234.56',
                  hintFadeDuration: Duration(milliseconds: 100),
                  label: Row(
                    spacing: 5,
                    children: [
                      Text('\u2217', style: TextStyle(color: Colors.red),),
                      Text('Amount'),
                    ],
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]')),
                  AmountFormatter(),
                ],
                keyboardType: TextInputType.number,
                controller: _amount,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'This field cannot be empty.';
                  if (value == '0') return 'This field cannot be 0.';
                  if (double.tryParse(value.replaceAll(',', '')) == null) return 'This field needs to be a decimal or int digits';
                  return null;
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date'
                ),
                controller: _date,
                onTap: _pickDate,
                readOnly: true,
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
              onPressed: usersEmpty ? null : () async {
                setState(() { _loading = true; });

                if (_formKey.currentState!.validate()) {
                  Pay pay = Pay(
                    id: widget.pay?.id,
                    title: _title.text,
                    userId: _selectedUser?.id,
                    date: _selectedDate,
                    amount: double.parse(_amount.text),
                  );

                  int insertedRows = await _dao.putPay(pay);
                  
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