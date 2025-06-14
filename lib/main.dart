import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_care_app/app.dart';
import 'core/api/api_client.dart';
import 'core/api/endpoints.dart';

void main() async {
  final apiClient = ApiClient(
    baseUrl: PatientApiConstants.baseUrl,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(DevicePreview(
    builder: (BuildContext context) => MyApp(
      apiClient: apiClient,
    ),
    enabled: !kReleaseMode,
  ));
}
