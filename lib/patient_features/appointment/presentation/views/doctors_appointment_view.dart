import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../all_appointement_upcoming/presentation/views/all_appointment_upcoming_view.dart';
import '../../../doctors/presentation/widgets/doctors_widget.dart';
import 'dart:convert';


class DoctorsAppointment extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String doctorImage;
  final int doctorId;

  const DoctorsAppointment({
    Key? key,
    required this.doctorName,
    required this.specialty,
    required this.doctorImage,
    required this.doctorId,
  }) : super(key: key);

  @override
  _DoctorsAppointmentState createState() => _DoctorsAppointmentState();
}

class _DoctorsAppointmentState extends State<DoctorsAppointment> {
  int _selectedDayIndex = 2; // Default to Wednesday
  String? _selectedTimeSlot;
  String _selectedGender = 'Male';

  static List<String> bookedTimeSlots = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  List<Map<String, dynamic>> _availableSlots = [];
  List<String> _availableTimeSlots = [];
  int? _selectedAvailabilityId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookedSlots();
    fetchDoctorAppointments();
  }

  Future<void> loadBookedSlots() async {
    final prefs = await SharedPreferences.getInstance();
    final booked = prefs.getStringList('booked_slots') ?? [];
    setState(() {
      bookedTimeSlots = booked;
    });
  }

  Future<void> fetchDoctorAppointments() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Patient/doctor/${widget.doctorId}/appointments',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data;
      final List<Map<String, dynamic>> slots = data
          .where((item) => item['status'] != null && item['status'].toString().toLowerCase() == 'available')
          .map<Map<String, dynamic>>((item) {
        double start = (item['startTimeInHours'] ?? 0).toDouble();
        double end = (item['endTimeInHours'] ?? 0).toDouble();
        String day = item['day'] ?? '';
        String formatTime(double hour) {
          int h = hour.floor();
          int m = ((hour - h) * 60).round();
          String period = h >= 12 ? 'PM' : 'AM';
          int displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
          return '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
        }
        String slotText = '$day: ${formatTime(start)} - ${formatTime(end)}';
        return {
          'id': item['id'] ?? item['availabilityId'],
          'text': slotText,
          'raw': item,
        };
      }).toList();
      setState(() {
        _availableSlots = slots;
        _availableTimeSlots = slots.map((e) => e['text'] as String).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _availableSlots = [];
        _availableTimeSlots = [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              color: const Color(0xFF0BDCDC),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.doctorImage),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.specialty,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('5', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Profile', color: const Color(0xFF0BDCDC)),
                    const SizedBox(height: 8),
                    _buildProfileCard(),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Available Time'),
                    const SizedBox(height: 16),
                    _buildTimeSlotGrid(),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Patient Details'),
                    const SizedBox(height: 16),
                    _buildInputLabel('Full Name'),
                    _buildInputField(_nameController),
                    const SizedBox(height: 16),
                    _buildInputLabel('Age'),
                    _buildInputField(_ageController, isNumber: true),
                    const SizedBox(height: 16),
                    _buildInputLabel('Gender'),
                    _buildGenderSelector(),
                    const SizedBox(height: 16),
                    _buildInputLabel('Describe your problem'),
                    _buildInputField(_problemController, maxLines: 4),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Button
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
                  onPressed: () async {
                    if (_selectedAvailabilityId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an available time slot'), backgroundColor: Colors.red),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Appointment'),
                        content: Text('Do you want to confirm this appointment?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close dialog
                              await bookAppointment();
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    );

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

  Widget _buildSectionTitle(String title, {Color color = Colors.black87}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Dr. Emma Hall is a highly experienced General Doctor with over 10 years of practice. She specializes in preventive care, chronic disease management, and women\'s health. Dr. Hall is known for her compassionate approach and thorough examinations.',
        style: TextStyle(color: Colors.grey, height: 1.5),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_availableTimeSlots.isEmpty) {
      return const Center(
        child: Text(
          'No Available Appointments',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableTimeSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final slot = _availableSlots[index];
        final isSelected = slot['id'] == _selectedAvailabilityId;
        final isBooked = bookedTimeSlots.contains(slot['text']);

        return GestureDetector(
          onTap: () {
            if (!isBooked) {
              setState(() {
                _selectedTimeSlot = slot['text'];
                _selectedAvailabilityId = slot['id'];
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.red.withOpacity(0.7)
                  : isSelected
                  ? const Color(0xFF0BDCDC)
                  : Colors.transparent,
              border: Border.all(color: const Color(0xFF0BDCDC)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              slot['text'],
              style: TextStyle(
                color: isBooked || isSelected ? Colors.white : const Color(0xFF0BDCDC),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: ['Male', 'Female'].map((gender) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = gender),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedGender == gender ? const Color(0xFF0BDCDC) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0BDCDC)),
              ),
              child: Text(
                gender,
                style: TextStyle(
                  color: _selectedGender == gender ? Colors.white : const Color(0xFF0BDCDC),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> bookAppointment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('User token not found');

      final bookResponse = await Dio().post(
        'https://healthcaresystem.runasp.net/api/Patient/book',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
        data: {
          'doctorId': widget.doctorId,
          'availabilityId': _selectedAvailabilityId,
        },
      );

      if (bookResponse.statusCode == 200 || bookResponse.statusCode == 201) {
        // ✅ Store the booked time slot locally
        final bookedSlot = _selectedTimeSlot;
        if (bookedSlot != null) {
          List<String> booked = prefs.getStringList('booked_slots') ?? [];
          if (!booked.contains(bookedSlot)) {
            booked.add(bookedSlot);
            await prefs.setStringList('booked_slots', booked);
          }
          setState(() {
            bookedTimeSlots = booked;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Booked'), backgroundColor: Colors.green),
        );
        // لا ترجع للصفحة السابقة تلقائياً
      } else {
        throw Exception('Booking failed: ${bookResponse.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
