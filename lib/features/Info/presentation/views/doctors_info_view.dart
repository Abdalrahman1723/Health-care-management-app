// ignore_for_file: unnecessary_brace_in_string_interps, unused_field

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorsInfo extends StatefulWidget {
  const DoctorsInfo({Key? key}) : super(key: key);

  @override
  _DoctorsInfoState createState() => _DoctorsInfoState();
}

class _DoctorsInfoState extends State<DoctorsInfo> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _firstDay = DateTime.utc(2023, 1, 1);
  final DateTime _lastDay = DateTime.utc(2025, 12, 31);

  String _selectedWeek = '';
  String _selectedMonth = '';
  String _selectedDayString = '';
  String _selectedDateText = 'Mon - Sat / 9 AM - 4 PM'; // Default text

  @override
  void initState() {
    super.initState();
    _focusedDay = _focusedDay.isAfter(_lastDay) ? _lastDay : _focusedDay;
    _selectedDay = _focusedDay;
    _updateDateInfo(_focusedDay); // Initialize with the current date
  }

  void _updateDateInfo(DateTime selectedDay) {
    // Update selected day, month, and week
    setState(() {
      _selectedDayString = "${selectedDay.day} ${selectedDay.month} ${selectedDay.year}";
      _selectedMonth = "${selectedDay.month}";
      _selectedWeek = "Week ${_getWeekOfYear(selectedDay)}";  // Calculate the week number
    });
  }

  // Method to calculate the week number of the year
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(firstDayOfYear).inDays;
    final weekNumber = ((difference / 7).floor() + 1);
    return weekNumber;
  }

  // Method to update selected date and time
  void _saveSelectedDate() {
    setState(() {
      if (_selectedDay != null) {
        _selectedDateText =
        '${_selectedDay!.day} / ${_selectedDay!.month} / ${_selectedDay!.year} - 9 AM - 4 PM';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 AppBar

              // 🔹 Doctor Info Card
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                color: const Color(0xFF0BDCDC),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('lib/core/assets/images/download.jpg'),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Emma Hall, M.D.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'General Doctor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Schedule Time
              Container(
                margin: EdgeInsets.all(screenWidth * 0.04),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFF0BDCDC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF0BDCDC), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _selectedDateText,  // Display the selected date text
                      style: const TextStyle(
                        color: Color(0xFF0BDCDC),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Profile Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0BDCDC),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco.',
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Calendar Section
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _saveSelectedDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0BDCDC),
                            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),  // Save the selected date and update the text
                          child: const Text('Save Selected Date', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TableCalendar(
                      firstDay: _firstDay,
                      lastDay: _lastDay,
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day); // تأكد من عدم إبقاء اللون على اليوم القديم
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: const TextStyle(color: Colors.black), // لون النص الأساسي
                        weekendTextStyle: const TextStyle(color: Colors.red), // لون نص عطلة نهاية الأسبوع
                        selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // لون النص عند التحديد
                        todayTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // لون اليوم الحالي
                        selectedDecoration: const BoxDecoration(
                          color: Color(0xFF0BDCDC), // لون خلفية اليوم المحدد
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF0BDCDC).withOpacity(0.3), // لون اليوم الحالي
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false, // إخفاء الأيام خارج الشهر
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),




                    // 🔹 Display Selected Date Info
                    const SizedBox(height: 20),
                    // 🔹 Button to save selected date
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
