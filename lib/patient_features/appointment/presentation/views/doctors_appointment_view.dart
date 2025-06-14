import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _selectedTimeSlot;
  String _selectedGender = 'Male';
  static List<String> bookedTimeSlots = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  List<Map<String, dynamic>> _availableSlots = [];
  int? _selectedAvailabilityId;
  bool _isLoading = true;

  List<Map<String, dynamic>> _feedbackList = [];
  bool _isFeedbackLoading = false;

  @override
  void initState() {
    super.initState();
    loadBookedSlots();
    fetchDoctorAppointments();
    fetchDoctorFeedback();
  }

  Future<void> loadBookedSlots() async {
    final prefs = await SharedPreferences.getInstance();
    bookedTimeSlots = prefs.getStringList('booked_slots') ?? [];
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
      _availableSlots = data
          .where((item) =>
      item['status']?.toString().toLowerCase() == 'available')
          .map((item) {
        double start = (item['startTimeInHours'] ?? 0).toDouble();
        double end = (item['endTimeInHours'] ?? 0).toDouble();
        String day = item['day'] ?? '';
        String availableDate = item['availableDate']?.toString() ?? '';
        String formatTime(double h) {
          int hour = h.floor();
          int minute = ((h - hour) * 60).round();
          String period = hour >= 12 ? 'PM' : 'AM';
          int dispHour = hour % 12 == 0 ? 12 : hour % 12;
          return '${dispHour.toString().padLeft(2,'0')}:'
              '${minute.toString().padLeft(2,'0')} $period';
        }
        return {
          'id': item['id'] ?? item['availabilityId'],
          'availableDate': availableDate,
          'slotText':
          '$day: ${formatTime(start)} - ${formatTime(end)}',
        };
      }).toList();
    } catch (e) {
      _availableSlots = [];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> fetchDoctorFeedback() async {
    setState(() => _isFeedbackLoading = true);
    try {
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Feedback/doctor/${widget.doctorId}',
      );
      if (response.statusCode == 200 && response.data is List) {
        _feedbackList = List<Map<String, dynamic>>.from(response.data);
      } else {
        _feedbackList = [];
      }
    } catch (e) {
      _feedbackList = [];
    } finally {
      setState(() => _isFeedbackLoading = false);
    }
  }

  Future<Map<String, dynamic>> _fetchDoctorProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().get(
      'https://healthcaresystem.runasp.net/api/Patient/${widget.doctorId}',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) return response.data;
    throw Exception('Failed to load profile');
  }

  Future<void> bookAppointment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final resp = await Dio().post(
        'https://healthcaresystem.runasp.net/api/Patient/book',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }),
        data: {
          'doctorId': widget.doctorId,
          'availabilityId': _selectedAvailabilityId,
        },
      );
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final booked = prefs.getStringList('booked_slots') ?? [];
        if (_selectedTimeSlot != null &&
            !booked.contains(_selectedTimeSlot!)) {
          booked.add(_selectedTimeSlot!);
          await prefs.setStringList('booked_slots', booked);
        }
        setState(() => bookedTimeSlots = booked);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Successfully Booked'),
              backgroundColor: Colors.green),
        );
      } else {
        throw Exception('Booking failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              color: const Color(0xFF0BDCDC),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.doctorImage),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doctorName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(widget.specialty,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          FutureBuilder<Map<String, dynamic>>(
                            future: _fetchDoctorProfile(),
                            builder: (c, snap) {
                              if (snap.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                    width: 16, height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white));
                              }
                              final rating = (snap.data?['rating'] is num)
                                  ? (snap.data!['rating'].toString())
                                  : '0';
                              return Text(rating,
                                  style: const TextStyle(color: Colors.white));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Profile', color: const Color(0xFF0BDCDC)),
                    const SizedBox(height: 8),
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    _sectionTitle('Available Time'),
                    const SizedBox(height: 16),
                    _buildTimeSlots(),
                    const SizedBox(height: 24),
                    _sectionTitle('Patient Details'),
                    _buildInput('Full Name', controller: _nameController),
                    _buildInput('Age',
                        controller: _ageController, isNumber: true),
                    const SizedBox(height: 16),
                    _sectionTitle('Patient Feedback'),
                    const SizedBox(height: 16),
                    _buildFeedbackSection(),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, -5)),
                ],
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedAvailabilityId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Please select an available time slot'),
                            backgroundColor: Colors.red),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Confirm Appointment'),
                        content:
                        const Text('Do you want to confirm this appointment?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(c);
                                await bookAppointment();
                              },
                              child: const Text('Confirm')),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0BDCDC),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Save Appointment',
                      style:
                      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t, {Color color = Colors.black87}) =>
      Text(t, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color));

  Widget _buildProfileCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchDoctorProfile(),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = snap.data?['profile'] ?? '';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            profile.isNotEmpty
                ? profile
                : 'A dedicated healthcare professional committed to providing exceptional medical care...',
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
        );
      },
    );
  }

  Widget _buildTimeSlots() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_availableSlots.isEmpty) {
      return const Center(
          child: Text('No Available Appointments',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableSlots.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 4.5, mainAxisSpacing: 16),
      itemBuilder: (ctx, i) {
        final slot = _availableSlots[i];
        final isSel = slot['id'] == _selectedAvailabilityId;
        final isBooked = bookedTimeSlots.contains(slot['slotText']);
        return GestureDetector(
          onTap: !isBooked
              ? () => setState(() {
            _selectedAvailabilityId = slot['id'];
            _selectedTimeSlot = slot['slotText'];
          })
              : null,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.red.withOpacity(0.7)
                  : isSel
                  ? const Color(0xFF0BDCDC)
                  : Colors.white,
              border: Border.all(color: const Color(0xFF0BDCDC), width: 1.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (isSel) BoxShadow(color: Colors.cyan.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((slot['availableDate'] ?? '').isNotEmpty)
                  Text(slot['availableDate'],
                      style: TextStyle(
                          color: isBooked || isSel ? Colors.white : const Color(0xFF0BDCDC),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                Text(slot['slotText'],
                    style: TextStyle(
                        color: isBooked || isSel ? Colors.white : const Color(0xFF0BDCDC),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(String label,
      {required TextEditingController controller, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(border: InputBorder.none),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    if (_isFeedbackLoading) return const Center(child: CircularProgressIndicator());
    if (_feedbackList.isEmpty) {
      return const Text('No feedback yet.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _feedbackList.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (_, idx) {
        final fb = _feedbackList[idx];
        return Card(
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fb['patientName'] ?? 'Anonymous',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0BDCDC))),
                const SizedBox(height: 4),
                Text(fb['comment'] ?? '',
                    style: const TextStyle(color: Colors.black87)),
                if (fb['rating'] != null)
                  Row(
                    children: List.generate(
                        fb['rating'], (_) => const Icon(Icons.star, color: Colors.amber, size: 18)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _problemController.dispose();
    super.dispose();
  }
}
