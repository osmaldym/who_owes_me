import 'package:flutter/material.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/user.dart';

class UserPage extends StatefulWidget {
  UserPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Dao _dao = Dao();

  Future<List<User>>? _getAllUsers;

  @override
  void initState() {
    _getAllUsers = _dao.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
      child: FutureBuilder(
        future: _getAllUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            List<User>? users = snapshot.data;

            return Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                ListView.builder(
                  itemCount: users?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(users?[index].name ?? 'No name'),
                      subtitle: Text(users?[index].email ?? 'No email'),
                      onTap: (){},
                    );
                  }
                )
              ],
            );
          }


          return Text('No users to show');
        }
      ),
    );
  }
}