import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:intl/intl.dart';
import 'package:who_owes_me/router/route.dart' as route;

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
  Dao _dao = Dao();
  DateFormat format = DateFormat("yyyy/MM/dd");

  Future<List<Pay>>? _getAllPays;

  @override
  void initState() {
    _getAllPays = _dao.getAllPays();
    super.initState();
  }

  void updateState() {
    setState(() {
      _getAllPays = _dao.getAllPays();
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
            const Text(
              'Pays',
              style: TextStyle(
                fontSize: 24,
              ),
            ),

            // Row(
            //   spacing: 5,
            //   children: [
            //     RawChip(
            //       selected: true,
            //       label: const Text('Next pays'),
            //       onPressed: () => print('New pay'),
            //     ),
            //     RawChip(
            //       label: const Text('Paid'),
            //       onPressed: () => print('New user'),
            //     ),
            //   ],
            // ),
            FutureBuilder(
              future: _getAllPays,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  List<Pay>? pays = snapshot.data;

                  return ListView.builder(
                    itemCount: pays?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.money),
                        ),
                        title: Text(pays?[index].title ?? 'No Title'),
                        trailing: Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${pays?[index].amount ?? '0'}'),
                            PopupMenuButton(
                              icon: const Icon(Icons.more_horiz),
                              itemBuilder: (context) => [
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
                                    onPressed: () {},
                                    child: const Row(
                                      spacing: 15,
                                      children: [
                                        Icon(Icons.delete),
                                        Text('Delete')
                                      ],
                                    ),
                                  )
                                )
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(pays?[index].date != null ? format.format(pays![index].date!) : 'No date'),
                      );
                    }
                  );
                }

                return Text('No pays to show');
              }
            ),
          ]
        ),
    );
  }
}