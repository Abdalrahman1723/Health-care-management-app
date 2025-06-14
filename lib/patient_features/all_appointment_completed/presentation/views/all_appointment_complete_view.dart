import 'package:flutter/material.dart';
import '../../../all_appointement_upcoming/presentation/views/all_appointment_upcoming_view.dart';
import '../../../all_appointment_cancelled/presentation/views/all_appointment_cancelled_view.dart';

class CompleteAppointmentsScreen extends StatefulWidget {
  const CompleteAppointmentsScreen({Key? key}) : super(key: key);

  @override
  _CompleteAppointmentsScreenState createState() => _CompleteAppointmentsScreenState();
}

class _CompleteAppointmentsScreenState extends State<CompleteAppointmentsScreen> {
  int _selectedIndex = 0; // 0: Upcoming, 1: Cancelled

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF0BDCDC),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'All Appointments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildFilterButton("Upcoming", 0),
                  const SizedBox(width: 8),
                  _buildFilterButton("Cancelled", 1),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  const UpcomingAppointmentsScreen(),
                  const CancelledAppointmentsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedIndex == index ? const Color(0xFF0BDCDC) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}