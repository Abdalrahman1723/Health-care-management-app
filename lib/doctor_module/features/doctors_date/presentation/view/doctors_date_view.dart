import 'package:flutter/material.dart';
import 'package:calendar_day_slot_navigator/calendar_day_slot_navigator.dart';

class DoctorsDates extends StatefulWidget {
  const DoctorsDates({Key? key}) : super(key: key);

  @override
  State<DoctorsDates> createState() => _DoctorsDatesState();
}

class _DoctorsDatesState extends State<DoctorsDates> {
  DateTime _selectedDate = DateTime.now();
  String? selectedTimeSlot;

  final List<String> timeSlots = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '12:00 PM', '12:30 PM', '01:30 PM', '02:00 PM',
    '03:00 PM', '04:30 PM', '05:00 PM', '05:30 PM',
  ];

  void _updateDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _showConfirmationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الـ Dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الـ Dialog بعد التأكيد
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$title confirmed"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0BDCDC),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Selector
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 60.0, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CalendarDaySlotNavigator(
                  isGoogleFont: false,
                  slotLength: 6,
                  dayBoxHeightAspectRatio: 4,
                  dayDisplayMode: DayDisplayMode.outsideDateBox,
                  headerText: "Select Date",
                  onDateSelect: (selectedDate) {
                    _updateDate(selectedDate);
                  },
                ),
              ],
            ),
          ),

          // Available Time Section
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 38.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final isSelected = timeSlots[index] == selectedTimeSlot;
                    return _buildTimeSlot(timeSlots[index], isSelected);
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom Buttons with Dialogs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog("Receiving reservations", "Are you sure you want to start receiving reservations?");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0BDCDC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Receiving reservations', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog("Booking stopped", "Are you sure you want to stop booking?");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF0BDCDC)),
                      ),
                    ),
                    child: const Text('Booking stopped', style: TextStyle(color: Color(0xFF0BDCDC), fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeSlot = time;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Text(
          time,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey[700], fontSize: 14),
        ),
      ),
    );
  }
}
