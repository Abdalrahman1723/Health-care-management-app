
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

abstract class Helper {
  static String timeToString(TimeOfDay time) {
    try {
      final DateTime now = DateTime.now();
      final date = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      final formatType = DateFormat.jm();
      return formatType.format(date);
    } catch (e) {
      return '12:00';
    }
  }

  static String dateToString(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

 static  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xffE4DFDF)),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
