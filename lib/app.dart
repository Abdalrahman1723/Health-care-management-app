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
            cubit.setTokenDirectly(
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiIwMzA0OGU1OC01YWQ5LTQ1N2EtYTA3MS1lYmFlNjUzMzBkMWMiLCJVc2VyTmFtZSI6ImFiZGFscmFobWFuIiwicm9sZSI6IlBhdGllbnQiLCJuYmYiOjE3NDk0NDY5MjAsImV4cCI6MTc0OTUzMzMyMCwiaWF0IjoxNzQ5NDQ2OTIwLCJpc3MiOiJDbGluaWNQcm9qZWN0In0.s3vtI8pZcw4s-fpVi7PFzcnbgE7-Vk6fD5X6LDpRi5c');
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => PatientCubit(
            apiClient: apiClient,
            authToken:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiIwMzA0OGU1OC01YWQ5LTQ1N2EtYTA3MS1lYmFlNjUzMzBkMWMiLCJVc2VyTmFtZSI6ImFiZGFscmFobWFuIiwicm9sZSI6IlBhdGllbnQiLCJuYmYiOjE3NDk0NDY5MjAsImV4cCI6MTc0OTUzMzMyMCwiaWF0IjoxNzQ5NDQ2OTIwLCJpc3MiOiJDbGluaWNQcm9qZWN0In0.s3vtI8pZcw4s-fpVi7PFzcnbgE7-Vk6fD5X6LDpRi5c',
          ),
        ),
        BlocProvider(
          create: (context) => UserProfileCubit(
            apiClient: apiClient,
            authToken:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiIwMzA0OGU1OC01YWQ5LTQ1N2EtYTA3MS1lYmFlNjUzMzBkMWMiLCJVc2VyTmFtZSI6ImFiZGFscmFobWFuIiwicm9sZSI6IlBhdGllbnQiLCJuYmYiOjE3NDk0NDY5MjAsImV4cCI6MTc0OTUzMzMyMCwiaWF0IjoxNzQ5NDQ2OTIwLCJpc3MiOiJDbGluaWNQcm9qZWN0In0.s3vtI8pZcw4s-fpVi7PFzcnbgE7-Vk6fD5X6LDpRi5c',
          ),
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
