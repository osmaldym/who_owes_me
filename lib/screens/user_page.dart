import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/db/dao.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
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
          Text(
            AppLocalizations.of(context)!.users,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          FutureBuilder(
            future: _getAllUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<User>? users = snapshot.data;

                if (users != null && users.isEmpty) return NoDataInfo(text: AppLocalizations.of(context)!.noUsersToShow, icon: Icons.person,);

                return Expanded(
                  child: ListView.builder(
                    itemCount: users?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(users?[index].name ?? AppLocalizations.of(context)!.noName),
                        subtitle: Text(users?[index].email ?? AppLocalizations.of(context)!.noEmail),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_horiz),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {
                                  context.pop();
                                  context.push(route.Route.usersPut, extra: users?[index]).then((_) => updateState());
                                },
                                child: Row(
                                  spacing: 15,
                                  children: [
                                    const Icon(Icons.edit),
                                    Text(AppLocalizations.of(context)!.edit)
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
                                      content: Text(AppLocalizations.of(context)!.alert_delete_user(users?[index].name ?? '')),
                                      actions: [
                                        TextButton(
                                          onPressed: () => context.pop(),
                                          child: Text(AppLocalizations.of(context)!.no)
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            int deletedItems = await _dao.softDeleteUser(users![index].id!);
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
                        onTap: (){},
                      );
                    }
                  ) 
                );
              }


              return NoDataInfo(text: AppLocalizations.of(context)!.noUsersToShow, icon: Icons.person);
            }
          ),
        ],
      )
    );
  }
}