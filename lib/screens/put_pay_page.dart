import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
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
        title: Text(widget.pay != null ?  AppLocalizations.of(context)!.editPay :  AppLocalizations.of(context)!.newPay),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.dueOfJohnDue,
                  hintFadeDuration: const Duration(milliseconds: 100),
                  label: Row(
                    spacing: 5,
                    children: [
                      const Text('\u2217', style: TextStyle(color: Colors.red),),
                      Text( AppLocalizations.of(context)!.title),
                    ],
                  ),
                ),
                controller: _title,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.thisFieldCannotBeEmpty;
                  if (value.length < 4) return AppLocalizations.of(context)!.this_field_needs_to_be_greather_than(4);
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.debtor,
                      ),
                      initialValue: _selectedUser,
                      items: users?.map<DropdownMenuItem<User>>((User user) => DropdownMenuItem(
                        value: user,
                        child: Text(user.name ?? AppLocalizations.of(context)!.unknownUser)
                      )).toList(),
                      onChanged: (obj) => _selectedUser = obj,
                    );
                  }
                  return Text(AppLocalizations.of(context)!.noUsersToShow);
                }
              ),
              TextFormField(
                decoration: InputDecoration(
                  prefixText: "\$",
                  hintText: '1,234.56',
                  hintFadeDuration: const Duration(milliseconds: 100),
                  label: Row(
                    spacing: 5,
                    children: [
                      const Text('\u2217', style: TextStyle(color: Colors.red),),
                      Text(AppLocalizations.of(context)!.amount),
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
                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.thisFieldCannotBeEmpty;
                  if (value == '0') return AppLocalizations.of(context)!.this_field_cannot_be('0');
                  if (double.tryParse(value.replaceAll(',', '')) == null) return AppLocalizations.of(context)!.thisFieldNeedsToBeDecimalOrIntDigits;
                  return null;
                }
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText:  AppLocalizations.of(context)!.date
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
                    amount: double.tryParse(_amount.text.replaceAll(',', '')),
                  );

                  int insertedRows = await _dao.putPay(pay);

                  if (insertedRows > 0 && context.mounted) context.pop();
                }

                setState(() { _loading = false; });
              },
              child: _loading ? const CircularProgressIndicator() : Text( AppLocalizations.of(context)!.save)
            )
          ),
        )
      ],
    );
  }
}