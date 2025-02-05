//displayes the user profile icon 
//and a small edit icon on the bottom right corner of the profile icon
import 'package:flutter/material.dart';

Widget avatar() {
  return InkWell(
    onTap: () {
      // Handle user profile icon press
    },
    child: Stack(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/man.png'),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 4),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 3,
                  ),
                ]),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(
                Icons.edit_outlined,
                color: Colors.black,
                size: 8,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
