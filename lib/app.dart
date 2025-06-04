//the root of the app
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/config/theme/app_theme.dart';
import 'package:health_care_app/core/api/api_client.dart';
import 'package:health_care_app/core/utils/app_strings.dart';

import 'global/global_screens/auth/presentation/cubit/auth_cubit.dart';
import 'global/global_screens/login/presentation/widgets/login_widget.dart';

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  const MyApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = AuthCubit(apiClient: apiClient);
            // Temporary hardcoded token for testing
            cubit.setTokenDirectly(
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiI4ZTZhODViZS03YzVkLTRlYTctYjMxMC05ZjgxNDUxMDY1YjEiLCJVc2VyTmFtZSI6ImFiZG8iLCJyb2xlIjoiUGF0aWVudCIsIm5iZiI6MTc0ODkxNDczNywiZXhwIjoxNzQ5MDAxMTM3LCJpYXQiOjE3NDg5MTQ3MzcsImlzcyI6IkNsaW5pY1Byb2plY3QifQ.cCcoisX5TdWcQqonQdT3g46-prgvocxlJo2U5rM44CQ');
            return cubit;
          },
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
          log("===============test================");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/MainScreen');
          });
          return const Center(child: CircularProgressIndicator());
        } else {
          // Show login screen if not authenticated
          log("===============test================");
          return const LoginScreen();
        }
      },
    );
  }
}
