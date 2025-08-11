import 'package:go_router/go_router.dart';
import 'package:project_frame/view/about/about.dart';
import 'package:project_frame/view/home/home.dart';
import 'package:project_frame/view/home/test.dart';
import 'package:project_frame/view/image_picker_tester/image_picker_test.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) => const TestScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/image-picker',
      builder: (context, state) => const ImagePickerTestPage(),
    ),
  ],
);
