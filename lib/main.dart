import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';
import 'package:tasbeeh_app/Controller/kalma_controller.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/Controller/quran_controller.dart';
import 'package:tasbeeh_app/Controller/tasbeeh_controller.dart';
import 'package:tasbeeh_app/Controller/theme_controller.dart';
import 'package:tasbeeh_app/splas_screen.dart';

void main() {
  Get.put(ThemeController()); 
  Get.put(PrayerController());
  Get.put(QuranController());
  Get.put(CounterController());
  Get.put(TasbeehController());
  Get.put(DuaController());
  Get.put(KalimaController());
  // Get.put(QiblaController());
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Obx(() => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeController.themeMode.value,
              home: const SplashScreen(),
            ));
      },
    );
  }
}
