import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
import 'package:who_owes_me/models/realated_pay.dart';
import 'package:who_owes_me/router/route.dart' as app;
import 'package:intl/intl.dart';
import 'package:who_owes_me/widgets/no_data_info.dart';

class HomePage extends StatefulWidget {
  _HomePageState? _state;

  HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    _HomePageState state = _HomePageState();
    _state = state;
    return state;
  }

  _HomePageState? getState() => _state;
}

class _HomePageState extends State<HomePage> {
  final Dao dao = Dao();
  DateFormat format = DateFormat("yyyy/MM/dd");
  NumberFormat nFormat = NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2);
  DateTime now = DateTime.now();

  Future<double>? _totalDue;
  Future<List<RelatedPay>>? _nextPays;
  Future<List<Map<String, Object?>>>? _oweMost;

  @override
  void initState() {
    refreshAllFutures();
    super.initState();
  }

  void refreshAllFutures() {
    _totalDue = dao.getTotalDue();
    _nextPays = dao.getNextPays();
    _oweMost = dao.getUsersOweMost();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _totalDue,
              builder: (context, snapshot) {
                double totalDouble = 0;
                
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  totalDouble = snapshot.data ?? 0;
                }

                String total = nFormat.format(totalDouble);
                return Text(
                    AppLocalizations.of(context)!.total_due(total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  );
              }
            ),
            Row(
              spacing: 5,
              children: [
                RawChip(
                  avatar: const Icon(Icons.person),
                  label: Text(AppLocalizations.of(context)!.newUser),
                  onPressed: () => context.push(app.Route.usersPut),
                ),
                RawChip(
                  avatar: const Icon(Icons.money),
                  label: Text(AppLocalizations.of(context)!.newPay),
                  onPressed: () => context.push(app.Route.paysPut).then((_) {
                    setState(() {
                      refreshAllFutures();
                    });
                  }),
                ),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.nextPays,
              style: const TextStyle(
                fontSize: 26
              ),
            ),
            Card(
              child: FutureBuilder(
                future: _nextPays,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    List<RelatedPay>? relatedPays = snapshot.data;

                    if (relatedPays != null && relatedPays.isEmpty){
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          NoDataInfo(
                            padding: const EdgeInsetsGeometry.all(35),
                            icon: Icons.person,
                            text: AppLocalizations.of(context)!.noUsersToShow,
                            showMessage: false,
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        for (RelatedPay rPay in relatedPays!)
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(rPay.user?.name ?? AppLocalizations.of(context)!.unknownUser),
                            trailing: Text('\$${nFormat.format(rPay.amount ?? 0)}'),
                            subtitle: rPay.date != null ? Text(format.format(rPay.date!)) : null,
                          )
                      ],
                    );
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      NoDataInfo(
                        padding: const EdgeInsetsGeometry.all(35),
                        icon: Icons.person,
                        text: AppLocalizations.of(context)!.noUsersToShow,
                        showMessage: false,
                      ),
                    ],
                  );
                }
              ),
            ),
            Text(
              AppLocalizations.of(context)!.usersWhoOweTheMost,
              style: const TextStyle(
                fontSize: 26
              ),
            ),
            Card(
              child: FutureBuilder(
                future: _oweMost,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    List<Map<String, Object?>>? relatedPays = snapshot.data;

                    if (relatedPays != null && relatedPays.isEmpty){
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          NoDataInfo(
                            padding: const EdgeInsetsGeometry.all(35),
                            text: AppLocalizations.of(context)!.noPaysToShow,
                            showMessage: false,
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        for (Map<String, Object?> rPay in relatedPays!)
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(rPay['name'] as String? ?? AppLocalizations.of(context)!.unknownUser),
                            subtitle: rPay['owe_total'] != null ? Text(nFormat.format(rPay['owe_total'] as double?)) : null,
                          )
                      ],
                    );
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      NoDataInfo(
                        padding: const EdgeInsetsGeometry.all(35),
                        text: AppLocalizations.of(context)!.noPaysToShow,
                        showMessage: false,
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}