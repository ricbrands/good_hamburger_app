import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_hamburger_app/controllers/navigation_controller.dart';
import 'package:good_hamburger_app/controllers/theme_controller.dart';
import 'package:good_hamburger_app/utils/app_themes.dart';
import 'package:good_hamburger_app/view/main_screen.dart';

void main() async{
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GOOD HAMBURGER',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: MainScreen(),
    );
  }
}
