import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_care_app/core/utils/app_colors.dart';

class Constants {
  //show error dialog
  static void showErrorDialog(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  //show toast

  static void showToast({
    required String message,
    Color? color,
  }) {
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: message,
      backgroundColor: color ?? AppColors.primary,
    );
  }
}
