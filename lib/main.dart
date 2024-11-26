import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:ecomerce_ieee/core/services/loading_service.dart';
import 'package:ecomerce_ieee/core/utils/bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes/routes.dart';
import 'core/di/config.dart';

void main() async {
  configureDependencies();
  configureEasyLoading();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  runApp(DevicePreview(
    builder: (BuildContext context) => MyApp(),
    enabled: !kReleaseMode,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(builder: DevicePreview.appBuilder),
          routerConfig: AppRoute.router,
        );
      },
    );
  }
}
