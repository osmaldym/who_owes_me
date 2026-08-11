import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:intl/intl.dart';
import 'package:who_owes_me/router/route.dart' as route;
import 'package:who_owes_me/widgets/no_data_info.dart';

class DuePage extends StatefulWidget {
  _DuePageState? _state;

  DuePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    _DuePageState state = _DuePageState();
    _state = state;
    return state;
  }

  _DuePageState? getState() => _state;
}

class _DuePageState extends State<DuePage> {
  final Dao _dao = Dao();
  DateFormat format = DateFormat("yyyy/MM/dd");
  NumberFormat nFormat = NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2);
  bool _all = true;
  bool _paid = false;
  bool _unpaid = false;

  Future<List<Pay>>? _getAllPays;

  void setFilter({ bool all = false, bool paid = false, bool unpaid = false }) {
    if (!all && !paid && !unpaid) all = true;

    setState(() {
      _all = all;
      _paid = paid;
      _unpaid = unpaid;
      _updatePaysList();
    });
  }

  void _updatePaysList(){
    _getAllPays = _dao.getAllPays(all: _all, paid: _paid);
  }

  @override
  void initState() {
    _updatePaysList();
    super.initState();
  }

  void updateState() {
    setState(() {
      _updatePaysList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.pays,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            Row(
              spacing: 5,
              children: [
                InputChip(
                  label: Text(AppLocalizations.of(context)!.all),
                  onSelected: (bool selected) => setFilter(all: selected),
                  selected: _all,
                ),
                InputChip(
                  label: Text(AppLocalizations.of(context)!.paid),
                  onSelected: (bool selected) => setFilter(paid: selected),
                  selected: _paid,
                ),
                InputChip(
                  label: Text(AppLocalizations.of(context)!.unpaid),
                  onSelected: (bool selected) => setFilter(unpaid: selected),
                  selected: _unpaid,
                ),
              ],
            ),
            FutureBuilder(
              future: _getAllPays,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  List<Pay>? pays = snapshot.data;

                  if (pays != null && pays.isEmpty) return NoDataInfo(text: AppLocalizations.of(context)!.noPaysToShow);

                  return Expanded(
                    child: ListView.builder(
                      itemCount: pays?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Badge(
                              padding: const EdgeInsets.all(3),
                              label: Row(
                                spacing: 3,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    (pays?[index].paid ?? false) ? Icons.attach_money_outlined : Icons.money_off_outlined,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              backgroundColor: (pays?[index].paid ?? false) ? Colors.green : Colors.red,
                              child: const CircleAvatar(
                                child: Icon(Icons.money),
                              ),
                            ),
                          title: Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pays?[index].title ?? AppLocalizations.of(context)!.noTitle),
                            ],
                          ),
                          trailing: Row(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton(
                                icon: const Icon(Icons.more_horiz),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: TextButton(
                                      onPressed: () async {
                                        int updatedItems = await _dao.setPaid(pays![index].id!, paid: !(pays[index].paid ?? false));
                                        if (updatedItems > 0) updateState();
                                        if (context.mounted) context.pop();
                                      },
                                      child: Row(
                                        spacing: 15,
                                        children: [
                                          Icon(pays?[index].paid ?? false ? Icons.money_off_outlined : Icons.attach_money_outlined),
                                          Text(pays?[index].paid ?? false ? AppLocalizations.of(context)!.unpaid : AppLocalizations.of(context)!.paid)
                                        ],
                                      ),
                                    )
                                  ),
                                  PopupMenuItem(
                                    child: TextButton(
                                      onPressed: () {
                                        context.pop();
                                        context.push(route.Route.paysPut, extra: pays?[index]).then((_) => updateState());
                                      },
                                      child: const Row(
                                        spacing: 15,
                                        children: [
                                          Icon(Icons.edit),
                                          Text('Edit')
                                        ],
                                      ),
                                    )
                                  ),
                                  PopupMenuItem(
                                    child: TextButton(
                                      onPressed: () {
                                        context.pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                          title: Text(AppLocalizations.of(context)!.areYouSure),
                                            content: Text(AppLocalizations.of(context)!.alert_delete_user(pays?[index].title ?? '')),
                                            actions: [
                                              TextButton(
                                                onPressed: () => context.pop(),
                                                child: Text(AppLocalizations.of(context)!.no)
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  int deletedItems = await _dao.softDeletePay(pays![index].id!);
                                                  if (deletedItems > 0) updateState();
                                                  if (context.mounted) context.pop();
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.yes,
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                )
                                              )
                                            ],
                                          )
                                        );
                                      },
                                      child: Row(
                                        spacing: 15,
                                        children: [
                                          const Icon(Icons.delete),
                                          Text(AppLocalizations.of(context)!.delete)
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(pays?[index].date != null ? format.format(pays![index].date!) : AppLocalizations.of(context)!.noDate),
                              const Text('•'),
                              Text('\$${nFormat.format(pays?[index].amount ?? 0)}'),
                            ],
                          ),
                        );
                      }
                    )
                  );
                }

                return NoDataInfo(text: AppLocalizations.of(context)!.noPaysToShow);
              }
            ),
          ]
        ),
    );
  }
}