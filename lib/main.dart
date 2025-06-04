import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_care_app/app.dart';
import 'package:health_care_app/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'core/api/api_client.dart';
import 'core/api/endpoints.dart';

void main() async {
  final apiClient = ApiClient(
    baseUrl: ApiConstants.baseUrl,
    client: http.Client(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // This must not be null
  );
  await ScreenUtil.ensureScreenSize();
  runApp(DevicePreview(
    builder: (BuildContext context) => MyApp(
      apiClient: apiClient,
    ),
    enabled: !kReleaseMode,
  ));
}
