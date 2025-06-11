import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/get_weekday_name.dart';
import 'package:intl/intl.dart'; // Import the intl package

Widget appointmentDetails(
    {required String doctorName,
    required DateTime selectedDate,
    required double startTimeInHours,
    required double endTimeInHours,
    required BuildContext context}) {
  return Column(
    children: [
      Text(
        getWeekdayName(selectedDate.weekday),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("from ${formatTimeInHour(startTimeInHours)}"),
              Text("to ${formatTimeInHour(endTimeInHours)}"),
            ],
          ), //later we will change this to a dynamic value
          Text(
            doctorName,
          ),
        ],
      ),
      Text(
        DateFormat('dd/MMM/yyyy').format(selectedDate),
      ),
    ],
  );
}

String formatTimeInHour(double timeInHours) {
  // Convert hours to hours and minutes
  int hours = timeInHours.floor();
  int minutes = ((timeInHours - hours) * 60).round();

  // Create DateTime object for easier formatting
  final now = DateTime.now();
  final time = DateTime(now.year, now.month, now.day, hours, minutes);

  // Format time in 12-hour format with AM/PM
  return DateFormat('h:mm a').format(time);
}
