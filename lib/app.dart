//the root of the app
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/admin_module/features/add_doctor/presentation/cubit/add_doctor_cubit.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/cubit/admin_main_page_cubit.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/config/theme/app_theme.dart';
import 'package:health_care_app/core/api/api_client.dart';
import 'package:health_care_app/core/utils/app_strings.dart';
import 'package:health_care_app/patient_features/ML_predection/presentation/cubit/prediction_cubit.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';
import 'package:health_care_app/patient_features/main page/presentation/cubit/patient_cubit.dart';

import 'patient_features/add_review/presentation/cubit/add_review_cubit.dart';

class MyApp extends StatelessWidget {
  final ApiClient apiClient;

  const MyApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //patient main page
        BlocProvider(
          create: (context) => PatientCubit(apiClient: apiClient),
        ),
        //patient profile provider
        BlocProvider(
          create: (context) => UserProfileCubit(apiClient: apiClient),
        ),
        //admin provider
        BlocProvider(
          create: (context) => AdminMainPageCubit(apiClient: apiClient),
        ),
        //add doctor provider
        BlocProvider(
          create: (context) => AddDoctorCubit(apiClient: apiClient),
        ),
        //predict provider
        BlocProvider(
          create: (context) => PredictionCubit(apiClient: apiClient),
        ),
        //notification provider
        BlocProvider(
          create: (context) => NotificationCubit(apiClient: apiClient),
        ),
        //notification provider
        BlocProvider(
          create: (context) => NotificationCubit(apiClient: apiClient),
        ),
        //add review provider
        BlocProvider(
          create: (context) => AddReviewCubit(apiClient: apiClient),
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
