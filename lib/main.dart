import 'package:authexample/app/data/services/personal_info_service.dart';
import 'package:authexample/app/data/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';

import 'app/data/services/user_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await initServices();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> initServices() async {
  await Get.putAsync(() async => StorageService());
  await Get.putAsync(() async => UserService());
  await Get.putAsync(() async => PersonalInfoService());
}