import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_care_app/app.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(DevicePreview(
    builder: (BuildContext context) => const MyApp(),
    enabled: !kReleaseMode,
  ));
} 
