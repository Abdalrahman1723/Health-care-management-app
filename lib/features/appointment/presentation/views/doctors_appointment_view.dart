// ignore_for_file: unnecessary_brace_in_string_interps, unused_field

import 'package:flutter/material.dart';
import '../../../doctors/presentation/widgets/doctors_widget.dart';

class DoctorsAppointment extends StatefulWidget {
  const DoctorsAppointment({Key? key}) : super(key: key);

  @override
  _DoctorsAppointmentState createState() => _DoctorsAppointmentState();
}

class _DoctorsAppointmentState extends State<DoctorsAppointment> {
  int _selectedDayIndex = 2; // Default to Wednesday (index 2)
  String? _selectedTimeSlot;
  String _selectedPatientType = 'Yourself';
  String _selectedGender = 'Male';

  // Static list to track booked appointments across instances
  static List<String> bookedTimeSlots = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  final List<String> _timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM',
    '11:30 AM', '12:00 M', '12:30 M', '1:00 PM', '1:30 PM',
    '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM',
  ];

  // Highlighted time slots that are available
  final List<String> _highlightedTimeSlots = [
    '10:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:30 PM', '3:00 PM'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              color: const Color(0xFF0BDCDC),
              child: Column(
                children: [
                  // Doctor info and actions
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('lib/core/assets/images/download.jpg'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dr. Emma Hall, M.D.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'General Doctor',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.white, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '5',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0BDCDC),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Dr. Emma Hall is a highly experienced General Doctor with over 10 years of practice. She specializes in preventive care, chronic disease management, and women\'s health. Dr. Hall is known for her compassionate approach and thorough examinations.',
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Available Time
                      const Text(
                        'Available Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Time slots grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _timeSlots.length,
                        itemBuilder: (context, index) {
                          bool isSelected = _timeSlots[index] == _selectedTimeSlot;
                          bool isHighlighted = _highlightedTimeSlots.contains(_timeSlots[index]);
                          bool isBooked = bookedTimeSlots.contains(_timeSlots[index]);

                          // Determine the color based on status
                          Color backgroundColor;
                          Color textColor;

                          if (isBooked) {
                            // Booked slots
                            backgroundColor = Colors.red.withOpacity(0.7);
                            textColor = Colors.white;
                          } else if (isSelected) {
                            // Selected slot
                            backgroundColor = const Color(0xFF0BDCDC);
                            textColor = Colors.white;
                          } else {
                            // Regular slots
                            backgroundColor = Colors.transparent;
                            textColor = const Color(0xFF0BDCDC);
                          }

                          return GestureDetector(
                            onTap: () {
                              // Only allow selection if not already booked
                              if (!isBooked) {
                                setState(() {
                                  _selectedTimeSlot = _timeSlots[index];
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF0BDCDC),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _timeSlots[index],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Patient Details
                      const Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Full Name
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Age
                      const Text(
                        'Age',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Gender
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildGenderButton('Male', _selectedGender == 'Male', () {
                            setState(() {
                              _selectedGender = 'Male';
                            });
                          }),
                          const SizedBox(width: 12),
                          _buildGenderButton('Female', _selectedGender == 'Female', () {
                            setState(() {
                              _selectedGender = 'Female';
                            });
                          }),

                        ],
                      ),

                      const SizedBox(height: 16),

                      // Problem Description
                      const Text(
                        'Describe your problem',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _problemController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Enter Your Problem Here...',
                            hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedTimeSlot != null) {
                      _showConfirmationDialog(context);
                    } else {
                      // Show error if no time slot is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an available time slot',style: TextStyle(color: Colors.white,fontSize: 20),),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0BDCDC),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    "Save Appointment",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0BDCDC) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0BDCDC),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0BDCDC),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0BDCDC) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0BDCDC),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0BDCDC),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),

              // Title
              const Text(
                "Appointment Confirmed!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                "Your appointment has been successfully booked for ${_selectedTimeSlot}.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close Dialog
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.red.shade400,
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // OK Button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Add the selected time slot to the booked list
                        if (_selectedTimeSlot != null) {
                          bookedTimeSlots.add(_selectedTimeSlot!);
                        }

                        Navigator.of(context).pop(); // Close Dialog

                        // Navigate to the DoctorsScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const DoctorsScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green.shade500,
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
