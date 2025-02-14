import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/get_weekday_name.dart';
import 'package:intl/intl.dart'; // Import the intl package

Widget appointmentDetails(
    {required String doctorName,
    required DateTime selectedDate,
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
          const Text('8:00 AM'), //later we will change this to a dynamic value
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
