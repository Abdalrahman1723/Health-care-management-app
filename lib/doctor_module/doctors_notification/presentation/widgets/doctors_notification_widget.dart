import 'package:flutter/material.dart';
import '../views/doctors_notification_view.dart';

class DoctorsNotification extends StatelessWidget {
  const DoctorsNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0BDCDC),
          title:
          const Text('Notification', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const DoctorsNotificationScreen(),
      ),
    );
  }
}
