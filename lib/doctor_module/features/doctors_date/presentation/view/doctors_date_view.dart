import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorsDates extends StatefulWidget {
  const DoctorsDates({Key? key}) : super(key: key);

  @override
  State<DoctorsDates> createState() => _DoctorsDatesState();
}

class _DoctorsDatesState extends State<DoctorsDates> {
  final List<String> days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  final List<double> hours = [
    6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
  ];

  String? selectedDay;
  double? selectedStartHour;
  double? selectedEndHour;
  bool isLoading = false;
  List<Map<String, dynamic>> currentAvailabilities = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentAvailabilities();
  }

  Future<void> _loadCurrentAvailabilities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final doctorId = prefs.getString('actorId') ?? prefs.getString('doctorId');

      if (token == null || doctorId == null) {
        throw Exception('Doctor information not found');
      }

      print('Loading availabilities for doctor ID: $doctorId');

      final dio = Dio();
      final response = await dio.get(
        'https://healthcaresystem.runasp.net/api/Doctor/$doctorId/availability',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          currentAvailabilities = List<Map<String, dynamic>>.from(response.data);
          errorMessage = null;
        });
        print('Loaded ${currentAvailabilities.length} availabilities');
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading availabilities: $e');
      setState(() {
        errorMessage = 'Failed to load availabilities';
      });
    }
  }

  Future<void> _sendAvailability() async {
    if (selectedDay == null || selectedStartHour == null || selectedEndHour == null) {
      setState(() {
        errorMessage = 'Please select all fields';
      });
      return;
    }

    if (selectedEndHour! <= selectedStartHour!) {
      setState(() {
        errorMessage = 'End time must be after start time';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final doctorId = prefs.getString('actorId') ?? prefs.getString('doctorId');

      if (token == null || doctorId == null) {
        throw Exception('Doctor information not found');
      }

      // Check for overlaps
      final hasOverlap = currentAvailabilities.any((avail) {
        return avail['day'] == selectedDay &&
            ((selectedStartHour! < avail['endTimeInHours'] &&
                selectedEndHour! > avail['startTimeInHours']));
            });

      if (hasOverlap) {
        throw Exception('This time overlaps with an existing availability');
      }

      final dio = Dio();
      final response = await dio.post(
        'https://healthcaresystem.runasp.net/api/Doctor/SetAvailability?doctorId=$doctorId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'day': selectedDay,
          'startTimeInHours': selectedStartHour,
          'endTimeInHours': selectedEndHour,
          'status': 'available',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _loadCurrentAvailabilities();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Availability added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to save: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving availability: $e');
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAvailability(int index) async {
    final availability = currentAvailabilities[index];

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final doctorId = prefs.getString('actorId') ?? prefs.getString('doctorId');

      if (token == null || doctorId == null) {
        throw Exception('Doctor information not found');
      }

      final dio = Dio();
      final response = await dio.delete(
        'https://healthcaresystem.runasp.net/api/Doctor/RemoveAvailability?doctorId=$doctorId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'day': availability['day'],
          'startTimeInHours': availability['startTimeInHours'],
          'endTimeInHours': availability['endTimeInHours'],
        },
      );

      if (response.statusCode == 200) {
        await _loadCurrentAvailabilities();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Availability removed'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(double hour) {
    int h = hour.floor();
    int m = ((hour - h) * 60).round();
    String period = h >= 12 ? 'PM' : 'AM';
    int displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Availabilities
            if (currentAvailabilities.isNotEmpty) ...[
              const Text(
                'Your Current Availabilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0BDCDC),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: currentAvailabilities.length,
                  itemBuilder: (context, index) {
                    final avail = currentAvailabilities[index];
                    return ListTile(
                      title: Text(
                        avail['day'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${_formatTime(avail['startTimeInHours'])} - ${_formatTime(avail['endTimeInHours'])}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAvailability(index),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 32),
            ],

            // Add New Availability
            const Text(
              'Add New Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0BDCDC),
              ),
            ),
            const SizedBox(height: 16),

            // Day Selection
            const Text('Select Day'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDay,
              items: days.map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Start Time
            const SizedBox(height: 16),
            const Text('Start Time'),
            const SizedBox(height: 8),
            DropdownButtonFormField<double>(
              value: selectedStartHour,
              items: hours.map((hour) {
                return DropdownMenuItem(
                  value: hour,
                  child: Text(_formatTime(hour)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStartHour = value;
                  selectedEndHour = null;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // End Time
            const SizedBox(height: 16),
            const Text('End Time'),
            const SizedBox(height: 8),
            DropdownButtonFormField<double>(
              value: selectedEndHour,
              items: hours.where((h) {
                return selectedStartHour == null || h > selectedStartHour!;
              }).map((hour) {
                return DropdownMenuItem(
                  value: hour,
                  child: Text(_formatTime(hour)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedEndHour = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Error Message
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            // Submit Button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _sendAvailability,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0BDCDC),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'SAVE AVAILABILITY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}