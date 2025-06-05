import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/global_screens/login/domain/usecases/login_usecase.dart';
import 'package:health_care_app/global/global_screens/login/presentation/cubit/login_cubit.dart';

import '../../data/datasources/login_remote_data_source.dart';
import '../../data/repositories/login_repository_impl.dart';
import '../views/login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BDCDC),
        title: const Text(
          'Log In',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: BlocProvider(
        create: (context) => LoginCubit(
          LoginUseCase(
           LoginRepositoryImpl(
              LoginRemoteDataSource(Dio()),
            ),
          ),
        ),
        child: LoginView(),
      )
    );
  }
}
