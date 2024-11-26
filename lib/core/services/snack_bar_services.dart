import 'package:flutter/material.dart';



import '../utils/app_color.dart';
import '../utils/app_style.dart';

class SnackBarServices {
  static void showUnLoggedMessage(BuildContext context) {
    var snackBar = SnackBar(
      content: Text(
        "you Must Login First",
      ),
      padding: const EdgeInsets.all(15),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        textColor: Colors.black,
        label: "Login",
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
