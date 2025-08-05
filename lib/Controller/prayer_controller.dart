// import 'dart:developer';

// import 'package:adhan/adhan.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
// import 'package:tasbeeh_app/Api/notification_service.dart';

// class PrayerController extends GetxController {
//   var isLoading = true.obs;
//   late Coordinates coordinates;
//   PrayerTimes? prayerTimes;
//   var currentPrayer = Rxn<Prayer>();
//   final Location location = Location();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchPrayerTimes();
//   }

//   Future<void> fetchPrayerTimes() async {
//     isLoading.value = true;
//     try {
//       // Check & request location permissions
//       if (!await _checkAndRequestLocationPermissions()) return;

//       // Get current location
//       LocationData locationData = await location.getLocation();
//       coordinates =
//           Coordinates(locationData.latitude!, locationData.longitude!);
//       log("📍 Location: Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}");

//       // Get correct timezone offset
//       final int tzOffsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
//       log("🕒 Timezone Offset: ${tzOffsetMinutes ~/ 60} hours");

//       // Select appropriate calculation method
//       final params = CalculationMethod.muslim_world_league.getParameters();
//       params.madhab = Madhab.hanafi;

//       // Get prayer times with correct UTC date
//       final today = DateComponents.from(DateTime.now().toUtc());
//       prayerTimes = PrayerTimes(coordinates, today, params);

//       // Log prayer times for debugging
//       printPrayerTimes();

//       // Update current prayer
//       updateCurrentPrayer();

//       // Schedule daily notifications
//       scheduleDailyPrayerNotifications();
//     } catch (e) {
//       log('❌ Error fetching prayer times: $e');
//       Get.snackbar(
//           "Error", "Failed to fetch prayer times. Please try again later.");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> _checkAndRequestLocationPermissions() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return false;
//     }

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return false;
//     }
//     return true;
//   }

//   void updateCurrentPrayer() {
//     if (prayerTimes == null) {
//       log("❌ No prayer times available yet!");
//       return;
//     }
//     final now = DateTime.now();

//     Prayer? activePrayer;
//     Prayer? nextPrayer;

//     for (var prayer in Prayer.values) {
//       if (prayer == Prayer.none || prayer == Prayer.sunrise) {
//         continue; // ✅ Skip invalid ones
//       }

//       final start = getPrayerStartTime(prayer);
//       final end = getPrayerEndTime(prayer);

//       log("🕌 Checking ${prayer.toString().split('.').last}: Start: ${formatTime(start)}, End: ${formatTime(end)}");

//       if (now.isAfter(start) && now.isBefore(end)) {
//         activePrayer = prayer; // ✅ If the prayer is ongoing, set it
//         break;
//       }

//       if (now.isBefore(start) && nextPrayer == null) {
//         nextPrayer = prayer; // ✅ Set the first upcoming prayer
//       }
//     }

//     // ✅ If no active prayer, set the next upcoming prayer
//     if (activePrayer != null) {
//       log("✅ Current Active Prayer: ${activePrayer.toString().split('.').last}");
//       currentPrayer.value = activePrayer;
//     } else {
//       // If no active prayer, set to the next upcoming prayer
//       if (nextPrayer != null) {
//         log("⏭ Next Upcoming Prayer: ${nextPrayer.toString().split('.').last}");
//         currentPrayer.value = nextPrayer;
//       } else {
//         // Default to Fajr for the next day if after Isha
//         log("⏭ Defaulting to Fajr (next day)");
//         currentPrayer.value = Prayer.fajr;
//       }
//     }
//   }

//   Prayer getUpcomingPrayer() {
//     final now = DateTime.now();

//     for (var prayer in Prayer.values) {
//       if (prayer == Prayer.none) continue;

//       final start = getPrayerStartTime(prayer);
//       if (now.isBefore(start)) {
//         return prayer;
//       }
//     }

//     return Prayer.fajr; // Default to next Fajr after Isha
//   }

//   Map<String, String> getCurrentPrayerTime() {
//     if (currentPrayer.value == null) {
//       Prayer nextPrayer = getUpcomingPrayer(); // ✅ Show next prayer
//       return {
//         "name": nextPrayer.toString().split('.').last,
//         "start": formatTime(getPrayerStartTime(nextPrayer)),
//         "end": formatTime(getPrayerEndTime(nextPrayer)),
//       };
//     }

//     final startTime = getPrayerStartTime(currentPrayer.value!);
//     final endTime = getPrayerEndTime(currentPrayer.value!);

//     log("📌 Current Prayer: ${currentPrayer.value}");
//     log("   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

//     return {
//       "name": currentPrayer.value.toString().split('.').last,
//       "start": formatTime(startTime),
//       "end": formatTime(endTime),
//     };
//   }

//   bool isMorning() {
//     if (prayerTimes == null) {
//       return true;
//     }

//     final now = DateTime.now();
//     return now.isBefore(prayerTimes!.maghrib);
//   }

//   DateTime getPrayerStartTime(Prayer prayer) {
//     if (prayerTimes == null) {
//       return DateTime.now(); // Return current time if null
//     }
//     switch (prayer) {
//       case Prayer.fajr:
//         return prayerTimes!.fajr;
//       case Prayer.dhuhr:
//         return prayerTimes!.dhuhr;
//       case Prayer.asr:
//         return prayerTimes!.asr;
//       case Prayer.maghrib:
//         return prayerTimes!.maghrib;
//       case Prayer.isha:
//         return prayerTimes!.isha;
//       default:
//         return prayerTimes!.fajr;
//     }
//   }

//   DateTime getPrayerEndTime(Prayer prayer) {
//     if (prayerTimes == null) {
//       return DateTime.now(); // Return current time if null
//     }
//     switch (prayer) {
//       case Prayer.fajr:
//         return prayerTimes!.sunrise;
//       case Prayer.dhuhr:
//         return prayerTimes!.asr;
//       case Prayer.asr:
//         return prayerTimes!.maghrib;
//       case Prayer.maghrib:
//         return prayerTimes!.isha;
//       case Prayer.isha:
//         return prayerTimes!.fajr.add(const Duration(days: 1));
//       default:
//         return prayerTimes!.dhuhr;
//     }
//   }

//   String formatTime(DateTime time) {
//     return DateFormat.jm().format(time);
//   }

//   void printPrayerTimes() {
//     log("🕌 Prayer Times:");
//     log("   Fajr: ${formatTime(prayerTimes!.fajr)}");
//     log("   Sunrise: ${formatTime(prayerTimes!.sunrise)}");
//     log("   Dhuhr: ${formatTime(prayerTimes!.dhuhr)}");
//     log("   Asr: ${formatTime(prayerTimes!.asr)}");
//     log("   Maghrib: ${formatTime(prayerTimes!.maghrib)}");
//     log("   Isha: ${formatTime(prayerTimes!.isha)}");
//   }

//   void scheduleDailyPrayerNotifications() {
//     if (prayerTimes == null) return;

//     final prayers = {
//       0: {'title': 'Fajr', 'time': prayerTimes!.fajr},
//       1: {'title': 'Dhuhr', 'time': prayerTimes!.dhuhr},
//       2: {'title': 'Asr', 'time': prayerTimes!.asr},
//       3: {'title': 'Maghrib', 'time': prayerTimes!.maghrib},
//       4: {'title': 'Isha', 'time': prayerTimes!.isha},
//     };

//     prayers.forEach((id, data) {
//       NotificationService.schedulePrayerNotification(
//         id: id,
//         title: data['title'] as String,
//         dateTime: data['time'] as DateTime,
//       );
//     });
//   }
// }

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
  var upcomingPrayer =
      Rxn<Prayer>(); // Add separate tracking for upcoming prayer
  var isCurrentPrayerActive =
      false.obs; // Track if current prayer is actually active
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

  void updateCurrentPrayer() {
    if (prayerTimes == null) {
      log("❌ No prayer times available yet!");
      return;
    }
    final now = DateTime.now();

    Prayer? activePrayer;
    Prayer? nextPrayer;

    // Check all prayers to find active and upcoming ones
    for (var prayer in Prayer.values) {
      if (prayer == Prayer.none || prayer == Prayer.sunrise) {
        continue; // Skip invalid ones
      }

      final start = getPrayerStartTime(prayer);
      final end = getPrayerEndTime(prayer);

      log("🕌 Checking ${prayer.toString().split('.').last}: Start: ${formatTime(start)}, End: ${formatTime(end)}");

      // Check if prayer is currently active (within prayer window)
      if (now.isAfter(start) && now.isBefore(end)) {
        activePrayer = prayer;
        break; // Found active prayer, no need to continue
      }

      // Find the next upcoming prayer
      if (now.isBefore(start) && nextPrayer == null) {
        nextPrayer = prayer;
      }
    }

    // Set current prayer and active status
    if (activePrayer != null) {
      log("✅ Current Active Prayer: ${activePrayer.toString().split('.').last}");
      currentPrayer.value = activePrayer;
      isCurrentPrayerActive.value = true;
      upcomingPrayer.value = getNextPrayerAfter(activePrayer);
    } else {
      // No active prayer right now
      if (nextPrayer != null) {
        log("⏭ Next Upcoming Prayer: ${nextPrayer.toString().split('.').last}");
        currentPrayer.value = null; // No current active prayer
        upcomingPrayer.value = nextPrayer;
        isCurrentPrayerActive.value = false;
      } else {
        // After Isha, next prayer is tomorrow's Fajr
        log("⏭ All prayers completed for today, next is tomorrow's Fajr");
        currentPrayer.value = null;
        upcomingPrayer.value = Prayer.fajr;
        isCurrentPrayerActive.value = false;
      }
    }
  }

  Prayer? getNextPrayerAfter(Prayer currentPrayer) {
    final prayers = [
      Prayer.fajr,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha
    ];
    final currentIndex = prayers.indexOf(currentPrayer);

    if (currentIndex != -1 && currentIndex < prayers.length - 1) {
      return prayers[currentIndex + 1];
    }

    // If it's Isha, next is tomorrow's Fajr
    return Prayer.fajr;
  }

  Prayer getUpcomingPrayer() {
    final now = DateTime.now();

    for (var prayer in Prayer.values) {
      if (prayer == Prayer.none || prayer == Prayer.sunrise) continue;

      final start = getPrayerStartTime(prayer);
      if (now.isBefore(start)) {
        return prayer;
      }
    }

    return Prayer.fajr; // Default to next Fajr after Isha
  }

  Map<String, String> getCurrentPrayerTime() {
    // If there's an active prayer, return its details
    if (isCurrentPrayerActive.value && currentPrayer.value != null) {
      final startTime = getPrayerStartTime(currentPrayer.value!);
      final endTime = getPrayerEndTime(currentPrayer.value!);

      log("📌 Current Active Prayer: ${currentPrayer.value}");
      log("   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

      return {
        "name": currentPrayer.value.toString().split('.').last,
        "start": formatTime(startTime),
        "end": formatTime(endTime),
        "status": "current", // Indicate this is the current active prayer
      };
    }

    // If no active prayer, return upcoming prayer details
    if (upcomingPrayer.value != null) {
      final startTime = getPrayerStartTime(upcomingPrayer.value!);
      final endTime = getPrayerEndTime(upcomingPrayer.value!);

      log("📌 Upcoming Prayer: ${upcomingPrayer.value}");
      log("   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

      return {
        "name": upcomingPrayer.value.toString().split('.').last,
        "start": formatTime(startTime),
        "end": formatTime(endTime),
        "status": "upcoming", // Indicate this is the upcoming prayer
      };
    }

    // Fallback
    Prayer nextPrayer = getUpcomingPrayer();
    return {
      "name": nextPrayer.toString().split('.').last,
      "start": formatTime(getPrayerStartTime(nextPrayer)),
      "end": formatTime(getPrayerEndTime(nextPrayer)),
      "status": "upcoming",
    };
  }

  // New method to get specifically the current active prayer (or null if none)
  Map<String, String>? getActivePrayerTime() {
    if (isCurrentPrayerActive.value && currentPrayer.value != null) {
      final startTime = getPrayerStartTime(currentPrayer.value!);
      final endTime = getPrayerEndTime(currentPrayer.value!);

      return {
        "name": currentPrayer.value.toString().split('.').last,
        "start": formatTime(startTime),
        "end": formatTime(endTime),
      };
    }
    return null;
  }

  // New method to get specifically the upcoming prayer
  Map<String, String> getUpcomingPrayerTime() {
    final upcoming = upcomingPrayer.value ?? getUpcomingPrayer();
    final startTime = getPrayerStartTime(upcoming);
    final endTime = getPrayerEndTime(upcoming);

    return {
      "name": upcoming.toString().split('.').last,
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
      return DateTime.now();
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
      return DateTime.now();
    }
    const fiveMinutes = Duration(minutes: 5);
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes!.sunrise;
      case Prayer.dhuhr:
        return prayerTimes!.asr.subtract(fiveMinutes);
      case Prayer.asr:
        return prayerTimes!.maghrib.subtract(fiveMinutes);
      case Prayer.maghrib:
        return prayerTimes!.isha.subtract(fiveMinutes);
      case Prayer.isha:
        // For Isha, end time is 5 minutes before next day's Fajr
        final nextDay = DateTime.now().add(const Duration(days: 1));
        final nextDayComponents = DateComponents.from(nextDay.toUtc());
        final nextDayPrayerTimes = PrayerTimes(
            coordinates, nextDayComponents, prayerTimes!.calculationParameters);
        return nextDayPrayerTimes.fajr.subtract(fiveMinutes);
      default:
        return prayerTimes!.dhuhr;
    }
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  void printPrayerTimes() {
    log("🕌 Prayer Times:");
    log("   Fajr: ${formatTime(prayerTimes!.fajr)} - ${formatTime(getPrayerEndTime(Prayer.fajr))}");
    log("   Sunrise: ${formatTime(prayerTimes!.sunrise)}");
    log("   Dhuhr: ${formatTime(prayerTimes!.dhuhr)} - ${formatTime(getPrayerEndTime(Prayer.dhuhr))}");
    log("   Asr: ${formatTime(prayerTimes!.asr)} - ${formatTime(getPrayerEndTime(Prayer.asr))}");
    log("   Maghrib: ${formatTime(prayerTimes!.maghrib)} - ${formatTime(getPrayerEndTime(Prayer.maghrib))}");
    log("   Isha: ${formatTime(prayerTimes!.isha)} - ${formatTime(getPrayerEndTime(Prayer.isha))}");
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
