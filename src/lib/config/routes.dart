import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/main.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, state) => const MyHomePage(
        title: 'test',
      ),
    )
  ],
);
