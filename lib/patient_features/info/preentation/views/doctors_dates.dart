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
  DateTime? selectedDate;
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
        errorMessage = '';
      });
    }
  }

  Future<void> _sendAvailability() async {
    if (selectedDay == null || selectedStartHour == null || selectedEndHour == null || selectedDate == null) {
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
      final formattedDate = '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
      final dataToSend = {
        'day': selectedDay,
        'startTimeInHours': selectedStartHour,
        'endTimeInHours': selectedEndHour,
        'availableDate': formattedDate,
        'status': 'available',
      };
      print('Sending data to backend: $dataToSend');
      final dio = Dio();
      final response = await dio.post(
        'https://healthcaresystem.runasp.net/api/Doctor/SetAvailability',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: dataToSend,
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final doctorId = prefs.getString('actorId') ?? prefs.getString('doctorId');

      if (token == null || doctorId == null) {
        throw Exception('Doctor information not found');
      }

      final avail = currentAvailabilities[index];
      final formattedDate = avail['availableDate'];

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
          'availableDate': formattedDate,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Availabilities'),
        backgroundColor: const Color(0xFF0BDCDC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        '${avail['availableDate']} | ${avail['startTimeInHours']} - ${avail['endTimeInHours']}',
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
                  child: Text(hour.toString()),
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
                  child: Text(hour.toString()),
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
            // Date Picker for Available Date
            const SizedBox(height: 16),
            const Text('Select Available Date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate == null
                          ? 'Choose a date'
                          : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
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