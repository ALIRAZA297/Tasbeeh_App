import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tasbeeh_app/Api/notification_service.dart';

class PrayerController extends GetxController {
  var isLoading = true.obs;
  late Coordinates coordinates;
  PrayerTimes? prayerTimes;
  var currentPrayer = Rxn<Prayer>();
  final Location location = Location();

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;
    try {
      // Check & request location permissions
      if (!await _checkAndRequestLocationPermissions()) return;

      // Get current location
      LocationData locationData = await location.getLocation();
      coordinates =
          Coordinates(locationData.latitude!, locationData.longitude!);
      log("📍 Location: Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}");

      // Get correct timezone offset
      final int tzOffsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
      log("🕒 Timezone Offset: ${tzOffsetMinutes ~/ 60} hours");

      // Select appropriate calculation method
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.hanafi;

      // Get prayer times with correct UTC date
      final today = DateComponents.from(DateTime.now().toUtc());
      prayerTimes = PrayerTimes(coordinates, today, params);

      // Log prayer times for debugging
      printPrayerTimes();

      // Update current prayer
      updateCurrentPrayer();

      // Schedule daily notifications
      scheduleDailyPrayerNotifications();
    } catch (e) {
      log('❌ Error fetching prayer times: $e');
      Get.snackbar(
          "Error", "Failed to fetch prayer times. Please try again later.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _checkAndRequestLocationPermissions() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

// void updateCurrentPrayer() {
//   final now = DateTime.now();

//   for (var prayer in Prayer.values) {
//     if (prayer == Prayer.none || prayer == Prayer.sunrise) continue; // ✅ Skip invalid ones

//     final start = getPrayerStartTime(prayer);
//     final end = getPrayerEndTime(prayer);

//     if (now.isAfter(start) && now.isBefore(end)) {
//       currentPrayer.value = prayer;
//       return;
//     }
//   }

//   // If no current prayer, fallback to closest previous one (like Isha at night)
//   if (now.isAfter(prayerTimes!.isha)) {
//     currentPrayer.value = Prayer.isha;
//   } else {
//     currentPrayer.value = Prayer.fajr;
//   }
// }

  void updateCurrentPrayer() {
    if (prayerTimes == null) {
      log("❌ No prayer times available yet!");
      return;
    }
    final now = DateTime.now();

    Prayer? activePrayer;
    Prayer? nextPrayer;

    for (var prayer in Prayer.values) {
      if (prayer == Prayer.none || prayer == Prayer.sunrise)
        continue; // ✅ Skip invalid ones

      final start = getPrayerStartTime(prayer);
      final end = getPrayerEndTime(prayer);

      log("🕌 Checking ${prayer.toString().split('.').last}: Start: ${formatTime(start)}, End: ${formatTime(end)}");

      if (now.isAfter(start) && now.isBefore(end)) {
        activePrayer = prayer; // ✅ If the prayer is ongoing, set it
        break;
      }

      if (now.isBefore(start) && nextPrayer == null) {
        nextPrayer = prayer; // ✅ Set the first upcoming prayer
      }
    }

    // ✅ If no active prayer, set the next upcoming prayer
    if (activePrayer != null) {
      log("✅ Current Active Prayer: ${activePrayer.toString().split('.').last}");
      currentPrayer.value = activePrayer;
    } else {
      log("⏭ Next Upcoming Prayer: ${nextPrayer.toString().split('.').last}");
      currentPrayer.value = null; // ✅ Only set next prayer if no active one
    }
  }

  Prayer getUpcomingPrayer() {
    final now = DateTime.now();

    for (var prayer in Prayer.values) {
      if (prayer == Prayer.none) continue;

      final start = getPrayerStartTime(prayer);
      if (now.isBefore(start)) {
        return prayer;
      }
    }

    return Prayer.fajr; // Default to next Fajr after Isha
  }

//   Map<String, String> getCurrentPrayerTime() {
// if (currentPrayer.value == null) {
//   Prayer nextPrayer = getUpcomingPrayer();
//   return {
//     "name": nextPrayer.toString().split('.').last,
//     "start": formatTime(getPrayerStartTime(nextPrayer)),
//     "end": formatTime(getPrayerEndTime(nextPrayer)),
//   };
// }

//     final startTime = getPrayerStartTime(currentPrayer.value!);
//     final endTime = getPrayerEndTime(currentPrayer.value!);

//     log("📌 Current Prayer: ${currentPrayer.value}");
//     log("   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

//     return {
//   "name": currentPrayer.value.toString().split('.').last,
//   "start": formatTime(startTime),
//   "end": formatTime(endTime),
// };

//   }

  Map<String, String> getCurrentPrayerTime() {
    if (currentPrayer.value == null) {
      Prayer nextPrayer = getUpcomingPrayer(); // ✅ Show next prayer
      return {
        "name": nextPrayer.toString().split('.').last,
        "start": formatTime(getPrayerStartTime(nextPrayer)),
        "end": formatTime(getPrayerEndTime(nextPrayer)),
      };
    }

    final startTime = getPrayerStartTime(currentPrayer.value!);
    final endTime = getPrayerEndTime(currentPrayer.value!);

    log("📌 Current Prayer: ${currentPrayer.value}");
    log("   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

    return {
      "name": currentPrayer.value.toString().split('.').last,
      "start": formatTime(startTime),
      "end": formatTime(endTime),
    };
  }

  bool isMorning() {
    if (prayerTimes == null) {
      return true;
    }

    final now = DateTime.now();
    return now.isBefore(prayerTimes!.maghrib);
  }

  DateTime getPrayerStartTime(Prayer prayer) {
    if (prayerTimes == null) {
      return DateTime.now(); // Return current time if null
    }
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes!.fajr;
      case Prayer.dhuhr:
        return prayerTimes!.dhuhr;
      case Prayer.asr:
        return prayerTimes!.asr;
      case Prayer.maghrib:
        return prayerTimes!.maghrib;
      case Prayer.isha:
        return prayerTimes!.isha;
      default:
        return prayerTimes!.fajr;
    }
  }

  DateTime getPrayerEndTime(Prayer prayer) {
    if (prayerTimes == null) {
      return DateTime.now(); // Return current time if null
    }
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes!.sunrise;
      case Prayer.dhuhr:
        return prayerTimes!.asr;
      case Prayer.asr:
        return prayerTimes!.maghrib;
      case Prayer.maghrib:
        return prayerTimes!.isha;
      case Prayer.isha:
        return prayerTimes!.fajr.add(const Duration(days: 1));
      default:
        return prayerTimes!.dhuhr;
    }
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  void printPrayerTimes() {
    log("🕌 Prayer Times:");
    log("   Fajr: ${formatTime(prayerTimes!.fajr)}");
    log("   Sunrise: ${formatTime(prayerTimes!.sunrise)}");
    log("   Dhuhr: ${formatTime(prayerTimes!.dhuhr)}");
    log("   Asr: ${formatTime(prayerTimes!.asr)}");
    log("   Maghrib: ${formatTime(prayerTimes!.maghrib)}");
    log("   Isha: ${formatTime(prayerTimes!.isha)}");
  }

  void scheduleDailyPrayerNotifications() {
    if (prayerTimes == null) return;

    final prayers = {
      0: {'title': 'Fajr', 'time': prayerTimes!.fajr},
      1: {'title': 'Dhuhr', 'time': prayerTimes!.dhuhr},
      2: {'title': 'Asr', 'time': prayerTimes!.asr},
      3: {'title': 'Maghrib', 'time': prayerTimes!.maghrib},
      4: {'title': 'Isha', 'time': prayerTimes!.isha},
    };

    prayers.forEach((id, data) {
      NotificationService.schedulePrayerNotification(
        id: id,
        title: data['title'] as String,
        dateTime: data['time'] as DateTime,
      );
    });
  }
}
