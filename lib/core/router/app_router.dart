import 'package:go_router/go_router.dart';
import 'package:project_frame/view/about/about.dart';
import 'package:project_frame/view/home/home.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
  ],
);
