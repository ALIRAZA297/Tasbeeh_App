// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:adhan/adhan.dart';
// import 'package:location/location.dart';
// import 'package:intl/intl.dart';

// class PrayerController extends GetxController {
//   Rx<PrayerTimes?> prayerTimes = Rx<PrayerTimes?>(null);
//   final Location location = Location();
//   RxBool isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getLocationAndPrayerTimes();
//   }

//   Future<void> getLocationAndPrayerTimes() async {
//     try {
//       // Check if location service is enabled
//       bool serviceEnabled = await location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) return;
//       }

//       // Check/request location permission
//       PermissionStatus permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) return;
//       }

//       // Get current location
//       LocationData locationData = await location.getLocation();
//       final coordinates = Coordinates(locationData.latitude!, locationData.longitude!);

//       // Calculate prayer times
//       final params = CalculationMethod.muslim_world_league.getParameters();
//       params.madhab = Madhab.shafi;

//       prayerTimes.value = PrayerTimes.today(coordinates, params);
//     } catch (e) {
//       log('Error getting location: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   String formatTime(DateTime time) {
//     return DateFormat.jm().format(time);
//   }

//   DateTime calculateEndTime(DateTime startTime, Prayer nextPrayer) {
//     if (prayerTimes.value == null) return startTime;

//     DateTime endTime;
//     switch (nextPrayer) {
//       case Prayer.dhuhr:
//         endTime = prayerTimes.value!.sunrise;
//         break;
//       case Prayer.asr:
//         endTime = prayerTimes.value!.asr;
//         break;
//       case Prayer.maghrib:
//         endTime = prayerTimes.value!.maghrib;
//         break;
//       case Prayer.isha:
//         endTime = prayerTimes.value!.isha;
//         break;
//       case Prayer.fajr:
//         endTime = prayerTimes.value!.fajr;
//         break;
//       default:
//         endTime = startTime.add(const Duration(hours: 1));
//     }
//     return endTime.subtract(const Duration(minutes: 5));
//   }
// }

import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

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
    } catch (e) {
      log('❌ Error fetching prayer times: $e');
      Get.snackbar("Error", "Failed to fetch prayer times. Please try again later.");

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
    final now = DateTime.now();

    Prayer? lastPrayer;
    for (var prayer in Prayer.values) {
      final start = getPrayerStartTime(prayer);
      final end = getPrayerEndTime(prayer);

      if (now.isAfter(start) && now.isBefore(end)) {
        currentPrayer.value = prayer;
        return;
      }
      lastPrayer = prayer; // Store last valid prayer
    }

    // If no prayer is currently active, set the last completed one
    currentPrayer.value = lastPrayer;
  }

  Map<String, String> getCurrentPrayerTime() {
    if (currentPrayer.value == null) return {"start": "", "end": ""};

    final startTime = getPrayerStartTime(currentPrayer.value!);
    final endTime = getPrayerEndTime(currentPrayer.value!);

    log("📌 Current Prayer: ${currentPrayer.value}");
    log("   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

    return {
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
}
