import 'package:ecomerce_ieee/features/example_on_clean_dontwritethingonit/presentation/pages/home_screen.dart';
import 'package:ecomerce_ieee/features/login/presentation/widgets/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static const String home = "/";
  static const String login = "/";


  static final router = GoRouter(

    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(), // هنا يتم تعريف صفحة تسجيل الدخول
      ),

    ],
  );



}
