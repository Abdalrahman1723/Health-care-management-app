import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';

Widget header({
  required BuildContext context,
  required String title,
  required String buttonText,
  required String route,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GradientBackground.gradientText(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, route);
              },
              child: GradientBackground.gradientText(
                buttonText,
                style: const TextStyle(
                    decoration: TextDecoration.underline, color: Colors.white),
              ),
            )
          ],
        ),
      ),
      //------------ divider
      Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        indent: 15,
        endIndent: 15,
      ),
    ],
  );
}
