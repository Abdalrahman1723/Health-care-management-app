import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/doctor_home_view.dart';

class DoctorHomeWidget extends StatefulWidget {
  const DoctorHomeWidget({super.key});

  @override
  State<DoctorHomeWidget> createState() => _DoctorHomeWidgetState();
}

class _DoctorHomeWidgetState extends State<DoctorHomeWidget> {
  String? doctorId;
  String? token;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorId = prefs.getString('actorId');
      token = prefs.getString('token');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (doctorId == null || token == null) {
      return const Scaffold(
        body: Center(child: Text("")),
      );
    }

    return Scaffold(
      body: DoctorHomeView(
        doctorId: doctorId!,
        token: token!,
      ),
    );
  }
}
