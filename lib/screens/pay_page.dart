import 'package:flutter/material.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:intl/intl.dart';

class DuePage extends StatefulWidget {
  DuePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DuePageState();
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
                        trailing: Text('\$${pays?[index].amount ?? '0'}'),
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