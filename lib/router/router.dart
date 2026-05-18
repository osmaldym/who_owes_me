
import 'package:go_router/go_router.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/user.dart';
import 'package:who_owes_me/router/route.dart';
import 'package:who_owes_me/screens/main_page.dart';
import 'package:who_owes_me/screens/put_pay_page.dart';
import 'package:who_owes_me/screens/put_user_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Route.root,
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: Route.usersPut,
      builder: (context, state) => PutUserPage(user: state.extra as User?,),
    ),
    GoRoute(
      path: Route.paysPut,
      builder: (context, state) => PutPayPage(pay: state.extra as Pay?,),
    )
  ]
);