import 'package:flutter/material.dart';

Widget doctorAvatar({required String? imageUrl, required double size}) {
  return CircleAvatar(
    radius: size / 2,
    backgroundColor: Colors.grey.shade200,
    backgroundImage:
        imageUrl != null && imageUrl.isNotEmpty && imageUrl.contains("jpg")
            ? AssetImage(imageUrl)
            : NetworkImage(imageUrl!),
    child: imageUrl.isEmpty
        ? Icon(Icons.person, size: size * 0.6, color: Colors.grey)
        : null,
  );
}
