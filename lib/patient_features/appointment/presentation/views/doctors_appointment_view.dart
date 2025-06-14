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

  // Feedback variables
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
        String availableDate = item['availableDate']?.toString() ?? '';
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
          'availableDate': availableDate,
          'slotText': slotText,
          'raw': item,
        };
      }).toList();
      setState(() {
        _availableSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _availableSlots = [];
        _isLoading = false;
      });
    }
  }

  Future<void> fetchDoctorFeedback() async {
    setState(() {
      _isFeedbackLoading = true;
    });
    try {
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Feedback/doctor/${widget.doctorId}',
      );
      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          _feedbackList = List<Map<String, dynamic>>.from(response.data);
          _isFeedbackLoading = false;
        });
      } else {
        setState(() {
          _feedbackList = [];
          _isFeedbackLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _feedbackList = [];
        _isFeedbackLoading = false;
      });
      print('Error fetching feedback: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchDoctorProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Authentication token not found');

      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Patient/${widget.doctorId}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load doctor profile');
      }
    } catch (e) {
      print('Error fetching doctor profile: $e');
      rethrow;
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
                    const SizedBox(height: 24),
                    _buildSectionTitle('Patient Feedback'),
                    const SizedBox(height: 16),
                    _buildFeedbackList(),
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
                        title: const Text('Confirm Appointment'),
                        content: const Text('Do you want to confirm this appointment?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close dialog
                              await bookAppointment();
                            },
                            child: const Text('Confirm'),
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchDoctorProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'A dedicated healthcare professional committed to providing exceptional medical care. With extensive experience in their field, they focus on delivering personalized treatment plans and maintaining the highest standards of patient care.',
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          );
        }

        final profile = snapshot.data?['profile'] ?? '';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            (profile ?? '').isNotEmpty
                ? profile
                : 'A dedicated healthcare professional committed to providing exceptional medical care. With extensive experience in their field, they focus on delivering personalized treatment plans and maintaining the highest standards of patient care.',
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
        );
      },
    );
  }

  Widget _buildTimeSlotGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_availableSlots.isEmpty) {
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
      itemCount: _availableSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4.5,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final slot = _availableSlots[index];
        final isSelected = slot['id'] == _selectedAvailabilityId;
        final isBooked = bookedTimeSlots.contains(slot['slotText']);
        final availableDate = slot['availableDate'];

        return GestureDetector(
          onTap: () {
            if (!isBooked) {
              setState(() {
                _selectedTimeSlot = slot['slotText'];
                _selectedAvailabilityId = slot['id'];
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 70,
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.red.withOpacity(0.7)
                  : isSelected
                  ? const Color(0xFF0BDCDC)
                  : Colors.white,
              border: Border.all(color: const Color(0xFF0BDCDC), width: 1.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((availableDate ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      availableDate,
                      style: TextStyle(
                        color: isBooked || isSelected ? Colors.white : const Color(0xFF0BDCDC),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                Text(
                  slot['slotText'],
                  style: TextStyle(
                    color: isBooked || isSelected ? Colors.white : const Color(0xFF0BDCDC),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
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

  Widget _buildFeedbackList() {
    if (_isFeedbackLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_feedbackList.isEmpty) {
      return const Text(
        'No feedback yet.',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _feedbackList.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final feedback = _feedbackList[index];
        return Card(
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback['patientName'] ?? 'Anonymous',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0BDCDC),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feedback['comment'] ?? '',
                  style: const TextStyle(color: Colors.black87),
                ),
                if (feedback['rating'] != null)
                  Row(
                    children: List.generate(
                      feedback['rating'] ?? 0,
                          (i) => const Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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