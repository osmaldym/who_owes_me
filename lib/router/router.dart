
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/router/route.dart';
import 'package:who_owes_me/screens/main_page.dart';
import 'package:who_owes_me/screens/put_user_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Route.root,
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: Route.usersNew,
      builder: (context, state) => PutUserPage(),
    )
  ]
);