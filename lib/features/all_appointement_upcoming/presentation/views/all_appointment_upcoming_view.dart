import 'package:flutter/material.dart';

class UpcomingAppointmentsScreen extends StatelessWidget {
  const UpcomingAppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
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
                ],
              ),
            ),
          ],
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
                flex: 2, // جعل ال Container الخاص بـ "Details" أكبر
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFF0BDCDC), // لون الحواف
                    ),
                  ),
                  child: const Center( // محاذاة النص في المنتصف
                    child: Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // تكبير حجم الخط
                        fontWeight: FontWeight.bold, // جعل النص عريضًا
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16), // ترك مسافة بين "Details" والرموز
              Expanded(
                flex: 1, // جعل هذا العنصر أصغر
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0BDCDC),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8), // تقليل المسافة بين علامتي الصح والخطأ
              Expanded(
                flex: 1, // جعل هذا العنصر أصغر أيضًا
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
          )
        ],
      ),
    );
  }
}
