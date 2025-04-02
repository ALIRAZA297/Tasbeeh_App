import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';
import 'package:tasbeeh_app/Controller/kalma_controller.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/Controller/quran_controller.dart';
import 'package:tasbeeh_app/Controller/tasbeeh_controller.dart';
import 'package:tasbeeh_app/splas_screen.dart';

void main() {
  Get.put(CounterController());
  Get.put(QuranController());
  Get.put(PrayerController());
  Get.put(TasbeehController());
  Get.put(DuaController());
  Get.put(KalimaController());
  // Get.put(QiblaController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasbeeh',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
