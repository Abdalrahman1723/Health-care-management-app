import 'package:ecomerce_ieee/core/utils/app_color.dart';
import 'package:ecomerce_ieee/features/Info/presentation/views/doctors_info_view.dart';
import 'package:ecomerce_ieee/features/login_and_signup/presentation/views/login_and_signup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class DoctorsInfoWidget extends StatelessWidget {
  const DoctorsInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: DoctorsInfo(),
    );
  }
}
