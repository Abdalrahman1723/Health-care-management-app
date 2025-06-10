//the root of the app
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/config/theme/app_theme.dart';
import 'package:health_care_app/core/api/api_client.dart';
import 'package:health_care_app/core/utils/app_strings.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';

import 'global/global_screens/auth/presentation/cubit/auth_cubit.dart';
import 'global/global_screens/login/presentation/widgets/login_widget.dart';
import 'package:health_care_app/patient_features/main page/presentation/cubit/patient_cubit.dart';

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  final String authToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiJhMGVlM2JmOS00YmM1LTRjNGUtOGVlMy05ZDg0Yzc2OWI5YmMiLCJVc2VyTmFtZSI6ImFkbWluIiwicm9sZSI6IlN1cGVyQWRtaW4iLCJuYmYiOjE3NDk1MjU0NzgsImV4cCI6MTc0OTYxMTg3OCwiaWF0IjoxNzQ5NTI1NDc4LCJpc3MiOiJDbGluaWNQcm9qZWN0In0.AmyorW7lso9uBfdbg792ztgxHNnQGatiYebQhwytBTw";
  const MyApp({super.key, required this.apiClient});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          //delete it
          create: (context) {
            final cubit = AuthCubit(apiClient: apiClient);
            // Temporary hardcoded token for testing
            cubit.setTokenDirectly(authToken);
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) =>
              PatientCubit(apiClient: apiClient, authToken: authToken),
        ),
        BlocProvider(
          create: (context) =>
              UserProfileCubit(apiClient: apiClient, authToken: authToken),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: appTheme(),
        initialRoute: '/',
        routes: routes, //using routes instead of home
      ),
    );
  }
}

class RouteWrapper extends StatelessWidget {
  const RouteWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          // Redirect to dashboard if authenticated
          log("===============starting the app================");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/welcome');
          });
          return const Center(child: CircularProgressIndicator());
        } else {
          // Show login screen if not authenticated
          log("===============login failed================");
          return const LoginScreen();
        }
      },
    );
  }
}
