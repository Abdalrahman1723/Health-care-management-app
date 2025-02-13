import 'package:flutter/material.dart';

class AllAppointmentsScreen extends StatefulWidget {
  const AllAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AllAppointmentsScreen> createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {
  String _selectedFilter = 'Complete';

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
                    'All Appointment',
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
                  _buildFilterButton('Complete'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Upcoming'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Cancelled'),
                ],
              ),
            ),

            // Appointments List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _getAppointmentsList(),
              ),
            ),

          ],
        ),
      ),
    );
  }

  List<Widget> _getAppointmentsList() {
    switch (_selectedFilter) {
      case 'Upcoming':
        return [
          _buildUpcomingAppointmentCard(
            'Dr. Madison Clark, Ph.D.',
            'General Doctor',
            'Sunday, 12 June',
            '9:30 AM - 10:00 AM',
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildUpcomingAppointmentCard(
            'Dr. Logan Williams, M.D.',
            'Dermatology',
            'Friday, 20 June',
            '2:30 PM - 3:00 PM',
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildUpcomingAppointmentCard(
            'Dr. Chloe Green, M.D.',
            'Gynecology',
            'Tuesday, 15 June',
            '9:30 AM - 10:00 AM',
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildUpcomingAppointmentCard(
            'Dr. Daniel Rodriguez',
            'Cardiology',
            'Friday, 20 June',
            '2:30 PM - 3:00 PM',
            'lib/core/assets/images/download.jpg',
          ),
        ];
      case 'Complete':
        return [
          _buildCompletedAppointmentCard(
            'Dr. Emma Hall, M.D.',
            'General Doctor',
            5,
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildCompletedAppointmentCard(
            'Dr. Jacob Lopez, M.D.',
            'Surgical Dermatology',
            4,
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildCompletedAppointmentCard(
            'Dr. Quinn Cooper, M.D.',
            'Menopausal and Geriatric Gynecology',
            5,
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildCompletedAppointmentCard(
            'Dr. Lucy Perez, Ph.D.',
            'Clinical Dermatology',
            4,
            'lib/core/assets/images/download.jpg',
          ),
        ];
      case 'Cancelled':
        return [
          _buildCancelledAppointmentCard(
            'Dr. Sarah Johnson, M.D.',
            'Neurologist',
            'Monday, 10 June',
            '11:30 AM - 12:00 PM',
            'lib/core/assets/images/download.jpg',
          ),
          const SizedBox(height: 16),
          _buildCancelledAppointmentCard(
            'Dr. Michael Brown, Ph.D.',
            'Psychiatrist',
            'Wednesday, 12 June',
            '2:00 PM - 2:30 PM',
            'lib/core/assets/images/download.jpg',
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildFilterButton(String text) {
    final isSelected = _selectedFilter == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0BDCDC) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(
      String name,
      String specialty,
      String date,
      String time,
      String imagePath,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0BDCDC)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Color(0xFF0BDCDC)),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Color(0xFF0BDCDC),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0BDCDC)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Color(0xFF0BDCDC)),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF0BDCDC),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0BDCDC),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedAppointmentCard(
      String name,
      String specialty,
      int rating,
      String imagePath,
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
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0BDCDC)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Re-Book',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0BDCDC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0BDCDC)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Add Review',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0BDCDC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledAppointmentCard(
      String name,
      String specialty,
      String date,
      String time,
      String imagePath,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
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
            child: const Text(
              'Cancelled',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0BDCDC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
