// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tasbeeh_app/Controller/counter_controller.dart';
// import 'package:tasbeeh_app/Controller/kalma_controller.dart';
// import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
// import 'package:tasbeeh_app/Controller/prayer_controller.dart';
// import 'package:tasbeeh_app/Controller/quran_controller.dart';
// import 'package:tasbeeh_app/Controller/tasbeeh_controller.dart';
// import 'package:tasbeeh_app/Controller/theme_controller.dart';
// import 'package:tasbeeh_app/splas_screen.dart';

// void main() {
//   Get.put(ThemeController());
//   Get.put(PrayerController());
//   Get.put(QuranController());
//   Get.put(CounterController());
//   Get.put(TasbeehController());
//   Get.put(DuaController());
//   Get.put(KalimaController());
//   // Get.put(QiblaController());
//   runApp(const MyApp());
// }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetMaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
// //         useMaterial3: true,
// //       ),
// //       home: const SplashScreen(),
// //     );
// //   }
// // }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ThemeController>(
//       builder: (themeController) {
//         return Obx(() => GetMaterialApp(
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData.light(),
//               darkTheme: ThemeData.dark(),
//               themeMode: themeController.themeMode.value,
//               home: const SplashScreen(),
//             ));
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Api/notification_service.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';
import 'package:tasbeeh_app/Controller/kalma_controller.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/Controller/quran_controller.dart';
import 'package:tasbeeh_app/Controller/tasbeeh_controller.dart';
import 'package:tasbeeh_app/Controller/theme_controller.dart';
import 'package:tasbeeh_app/splas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService.cancelAll();

  final isAllowed = await AwesomeNotifications().isNotificationAllowed();
  log("Initial notification permission status: $isAllowed");
  if (!isAllowed) {
    log("Requesting notification permission...");
    await AwesomeNotifications().requestPermissionToSendNotifications();
    final permissionAfterRequest =
        await AwesomeNotifications().isNotificationAllowed();
    log("Permission after request: $permissionAfterRequest");
  }

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'zikr_channel',
        channelName: 'Zikr Notifications',
        channelDescription: 'Daily zikr reminders',
        defaultColor: Colors.green,
        importance: NotificationImportance.Max,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'prayer_channel',
        channelName: 'Prayer Notifications',
        channelDescription: 'Daily Namaz reminders',
        defaultColor: Colors.blue,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
    ],
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction receivedAction) async {
      // Clear the badge when a notification is tapped
      await AwesomeNotifications().resetGlobalBadge();
      await AwesomeNotifications().decrementGlobalBadgeCounter();
    },
  );

  Get.put(ThemeController());
  Get.put(PrayerController());
  Get.put(QuranController());
  Get.put(CounterController());
  Get.put(TasbeehController());
  Get.put(DuaController());
  Get.put(KalimaController());

  // Run the app
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  // handle the action here
  debugPrint(
      'Notification action received: ${receivedAction.buttonKeyPressed}');
}

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
