import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_care_app/app.dart';
import 'package:health_care_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // This must not be null
  );
  await ScreenUtil.ensureScreenSize();
  runApp(DevicePreview(
    builder: (BuildContext context) => const MyApp(),
    enabled: !kReleaseMode,
  ));
} 
