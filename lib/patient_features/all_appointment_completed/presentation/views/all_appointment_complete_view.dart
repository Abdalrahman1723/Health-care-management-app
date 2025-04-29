import 'package:flutter/material.dart';
import '../../../all_appointement_upcoming/presentation/views/all_appointment_upcoming_view.dart';
import '../../../all_appointment_cancelled/presentation/views/all_appointment_cancelled_view.dart';

class CompleteAppointmentsScreen extends StatefulWidget {
  const CompleteAppointmentsScreen({Key? key}) : super(key: key);

  @override
  _CompleteAppointmentsScreenState createState() => _CompleteAppointmentsScreenState();
}

class _CompleteAppointmentsScreenState extends State<CompleteAppointmentsScreen> {
  int _selectedIndex = 0; // 0: Complete, 1: Upcoming, 2: Cancelled

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
                  _buildFilterButton("Complete", 0),
                  const SizedBox(width: 8),
                  _buildFilterButton("Upcoming", 1),
                  const SizedBox(width: 8),
                  _buildFilterButton("Cancelled", 2),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildCompletedAppointments(),
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

  Widget _buildCompletedAppointments() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCompletedAppointmentCard(
          'Dr. Emma Hall, M.D.',
          'General Doctor',
          'lib/core/assets/images/download.jpg',
        ),
        const SizedBox(height: 16),
        _buildCompletedAppointmentCard(
          'Dr. Jacob Lopez, M.D.',
          'Surgical Dermatology',
          'lib/core/assets/images/download.jpg',
        ),
        const SizedBox(height: 16),
        _buildCompletedAppointmentCard(
          'Dr. Quinn Cooper, M.D.',
          'Menopausal and Geriatric Gynecology',
          'lib/core/assets/images/download.jpg',
        ),
        const SizedBox(height: 16),
        _buildCompletedAppointmentCard(
          'Dr. Lucy Perez, Ph.D.',
          'Clinical Dermatology',
          'lib/core/assets/images/download.jpg',
        ),
      ],
    );
  }

  Widget _buildCompletedAppointmentCard(String name, String specialty, String imagePath) {
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
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0BDCDC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Re-Book", style: TextStyle(color: Colors.white,fontSize: 16)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Add Review", style: TextStyle(color: Colors.black,fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
