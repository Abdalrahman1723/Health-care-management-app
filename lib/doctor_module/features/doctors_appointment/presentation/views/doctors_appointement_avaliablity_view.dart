import 'package:flutter/material.dart';

class DoctorsAppointmentAvaliable extends StatelessWidget {
  const DoctorsAppointmentAvaliable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Make the entire column scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Appointments
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildAppointmentCard(
              'Consultation Eye',
              'Dr. David Garrison',
              '10:00 PM',
            ),
            _buildAppointmentCard(
              'Tes Swap Anti Gen',
              'Dr. Glenda Rugorin',
              '01:40 AM',
            ),

            // Next Month Appointments
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Next Month',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildAppointmentCard(
              'Medichal Check Up',
              'Dr. Andrew Morales',
              '14 March 2021',
            ),
            _buildAppointmentCard(
              'Diagnostic Heart',
              'Dr. Michael Sands',
              '20 March 2021',
            ),
            _buildAppointmentCard(
              'Consultation Nutrition',
              'Dr. Thomas Pierre',
              '27 March 2021',
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String title, String doctor, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset("lib/core/assets/images/download.jpg"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  doctor,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
