import 'package:flutter/material.dart';

import '../../../../config/routes/routes.dart';

class CancelledAppointmentsScreen extends StatelessWidget {
  const CancelledAppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Cancelled Appointments List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCancelledAppointmentCard(
                      'Dr. Sarah Johnson, M.D.',
                      'Neurologist',
                      'Monday, 10 June',
                      '11:30 AM - 12:00 PM',
                      'lib/core/assets/images/download.jpg',
                      context),
                  const SizedBox(height: 16),
                  _buildCancelledAppointmentCard(
                      'Dr. Michael Brown, Ph.D.',
                      'Psychiatrist',
                      'Wednesday, 12 June',
                      '2:00 PM - 2:30 PM',
                      'lib/core/assets/images/download.jpg',
                      context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledAppointmentCard(
    String name,
    String specialty,
    String date,
    String time,
    String imagePath,
    BuildContext
        context, //added context to enable navigation to add review screen
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0BDCDC),
                      ),
                    ),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.addReviewScreen);
                },
                child: const Text(
                  'Add Review',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
