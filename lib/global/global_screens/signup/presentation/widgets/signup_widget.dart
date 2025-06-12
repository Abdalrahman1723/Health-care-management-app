import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/register_remote_data_source.dart';
import '../../data/repositories/register_repository_impl.dart';
import '../../domain/usecases/register_usecase.dart';
import '../cubit/register_cubit.dart';
import '../views/signup_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0BDCDC),
          title: const Text(
            'New Account',
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
          create: (context) => RegisterCubit(
            RegisterUseCase(
              RegisterRepositoryImpl(
                RegisterRemoteDataSource(Dio()),
              ),
            ),
          ),
          child: const SignupView(),
        )
      ),
    );
  }
}
