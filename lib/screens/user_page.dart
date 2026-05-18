import 'package:flutter/material.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/user.dart';

class UserPage extends StatefulWidget {
  UserPageState? _state;
  
  UserPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
   UserPageState state = UserPageState();
   _state = state;
   return state;
  }

  UserPageState? getState() => _state;
}

class UserPageState extends State<UserPage> {
  Dao _dao = Dao();

  Future<List<User>>? _getAllUsers;

  @override
  void initState() {
    _getAllUsers = _dao.getAllUsers();
    super.initState();
  }

  void updateState() {
    setState(() {
      _getAllUsers = _dao.getAllUsers();
    });
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
                Expanded(
                  child: ListView.builder(
                    itemCount: users?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(users?[index].name ?? 'No name'),
                        subtitle: Text(users?[index].email ?? 'No email'),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_horiz),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {},
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
                        onTap: (){},
                      );
                    }
                  ) 
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