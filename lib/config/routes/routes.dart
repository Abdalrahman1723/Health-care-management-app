import 'package:ecomerce_ieee/features/login/presentation/widgets/login_widget.dart';
import 'package:ecomerce_ieee/features/login_and_signup/presentation/views/login_and_signup_view.dart';
import 'package:ecomerce_ieee/features/signup/presentation/widgets/signup_widget.dart';
import 'package:ecomerce_ieee/features/welcome/welcome.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static const String login = "/";
  static const String loginAndSignup = "/";
  static const String welcome = "/";
  static const String signup = "/";


  static final router = GoRouter(

    routes: [

      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: loginAndSignup,
        builder: (context, state) => const LoginAndSignupScreen(), // هنا يتم تعريف صفحة تسجيل الدخول
      ),

      GoRoute(
        path:signup ,
        builder: (context, state) => const SignUpScreen(), // هنا يتم تعريف صفحة تسجيل الدخول
      ),

      GoRoute(
        path:login ,
        builder: (context, state) => const LoginScreen(), // هنا يتم تعريف صفحة تسجيل الدخول
      ),



    ],
  );



}
