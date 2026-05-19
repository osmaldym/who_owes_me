import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/models/user.dart';
import 'package:who_owes_me/router/route.dart' as route;
import 'package:who_owes_me/widgets/no_data_info.dart';

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
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          FutureBuilder(
            future: _getAllUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<User>? users = snapshot.data;

                if (users != null && users.isEmpty) return NoDataInfo(text: 'No users to show', icon: Icons.person,);

                return Expanded(
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
                                onPressed: () {
                                  context.pop();
                                  context.push(route.Route.usersPut, extra: users?[index]).then((_) => updateState());
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
                                    title: const Text("Are you sure?"),
                                      content: Text("Are you sure to delete the user \"${ users?[index].name ?? '' }\"? His dues will be deleted too and this action cannot be undone."),
                                      actions: [
                                        TextButton(
                                          onPressed: () => context.pop(),
                                          child: const Text('No')
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            int deletedItems = await _dao.softDeleteUser(users![index].id!);
                                            if (deletedItems > 0) updateState();
                                            if (context.mounted) context.pop();
                                          },
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )
                                        )
                                      ],
                                    )
                                  );
                                },
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
                );
              }


              return NoDataInfo(text: 'No users to show', icon: Icons.person);
            }
          ),
        ],
      )
    );
  }
}