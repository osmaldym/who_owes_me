import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/router/route.dart' as app;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateFormat format = DateFormat("yyyy/MM/dd");
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total due: \$23,000.00',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              spacing: 5,
              children: [
                RawChip(
                  avatar: const Icon(Icons.person),
                  label: const Text('New user'),
                  onPressed: () => context.push(app.Route.usersNew),
                ),
                RawChip(
                  avatar: const Icon(Icons.money),
                  label: const Text('New pay'),
                  onPressed: () => context.push(app.Route.paysNew),
                ),
              ],
            ),
            const Text(
              'Next pays',
              style: TextStyle(
                fontSize: 26
              ),
            ),
            Card(
              child: Column(
                children: [
                  for (var i = 0; i < 5; i++)
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: const Text('John Due'),
                      trailing: const Text('\$50,000.00'),
                      subtitle: Text(format.format(now)),
                    ),
                ],
              )
            ),
            const Text(
              'Users who owe the most',
              style: TextStyle(
                fontSize: 26
              ),
            ),
            Card(
              child: Column(
                children: [
                  for (var i = 0; i < 5; i++)
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('John Due'),
                      subtitle: Text('\$25,000.00'),
                    ),
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}