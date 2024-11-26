import 'package:flutter/material.dart';


class CircularSkeleton extends StatelessWidget {
  final double? size;

  const CircularSkeleton({
    super.key,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}