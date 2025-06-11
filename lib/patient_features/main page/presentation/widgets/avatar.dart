//displays the user profile icon
//and a small edit icon on the bottom right corner of the profile icon
import 'dart:io';

import 'package:flutter/material.dart';

Widget avatar(
    {required BuildContext context,
    String? imageUrl,
    required double editIconSize,
    required double avatarSize,
    String route = ''}) {
  return InkWell(
    onTap: () {
      if (route.isNotEmpty) {
        Navigator.pushNamed(context, route);
      }
    },
    child: Stack(
      children: [
        CircleAvatar(
          backgroundImage: imageUrl != null
              ? FileImage(File(imageUrl))
              : const AssetImage('assets/images/man.png') as ImageProvider,
          radius: avatarSize,
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
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Icons.edit_outlined,
                color: Colors.black,
                size: editIconSize,
                // size: 8,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
