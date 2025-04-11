import 'package:flutter/material.dart';
import 'package:health_care_app/admin_module/core/utils/admin_app_bar.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/widgets/appointments_details_section.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/widgets/doctors_details_section.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar(context: context, title: "Admin Dashboard"),
      //---------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //----------appointment details section
              appointmentDetailsSection(context: context),
              const SizedBox(
                height: 4,
              ),
              doctorDetailsSection(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
