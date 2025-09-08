import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tasbeeh_app/Api/notification_service.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class HomeController extends GetxController {
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
      // Set location settings for balanced accuracy (faster after service toggle)
      await location.changeSettings(
        accuracy: LocationAccuracy
            .balanced, // Or LocationAccuracy.low for even faster
        interval: 10000, // 10 seconds between updates
      );

      // Check & request location permissions with retry logic
      if (!await _checkAndRequestLocationPermissionsWithRetry()) {
        throw Exception('Location permissions or service not available');
      }

      // Get current location with timeout (prevents hanging after service toggle)
      LocationData? locationData = await _getLocationWithTimeout();
      if (locationData == null ||
          locationData.latitude == null ||
          locationData.longitude == null) {
        throw Exception('Failed to get valid location data');
      }

      coordinates =
          Coordinates(locationData.latitude!, locationData.longitude!);
      debugPrint(
          "📍 Location: Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}");

      // Get correct timezone offset
      final int tzOffsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
      debugPrint("🕒 Timezone Offset: ${tzOffsetMinutes ~/ 60} hours");

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
      debugPrint('❌ Error fetching prayer times: $e');
      Get.snackbar(
        "Location Error",
        "Unable to fetch accurate prayer times. Please ensure location services are enabled and try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.orange,
        colorText: AppColors.white,
      );
      // Optional: Fallback to a default location (e.g., Mecca) for approximate times
      // _setDefaultCoordinates();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _checkAndRequestLocationPermissionsWithRetry() async {
    int maxRetries = 2;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          debugPrint(
              '❌ Location service not enabled after request (attempt $attempt)');
          if (attempt == maxRetries - 1) return false;
          await Future.delayed(
              Duration(seconds: 2)); // Brief pause before retry
          continue;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          debugPrint('❌ Permission denied (attempt $attempt)');
          if (attempt == maxRetries - 1) return false;
          await Future.delayed(Duration(seconds: 2));
          continue;
        }
      }
      debugPrint('✅ Permissions granted on attempt $attempt');
      return true;
    }
    return false;
  }

  Future<LocationData?> _getLocationWithTimeout(
      {Duration timeout = const Duration(seconds: 15)}) async {
    try {
      // Use Future.any to timeout the getLocation call
      return await Future.any<LocationData?>([
        location.getLocation(),
        Future.delayed(timeout, () => null),
      ]);
    } catch (e) {
      debugPrint('❌ getLocation error: $e');
      return null;
    }
  }
  // Future<bool> _checkAndRequestLocationPermissions() async {
  //   bool serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) return false;
  //   }

  //   PermissionStatus permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) return false;
  //   }
  //   return true;
  // }

  void updateCurrentPrayer() {
    if (prayerTimes == null) {
      debugPrint("❌ No prayer times available yet!");
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

      debugPrint(
          "🕌 Checking ${prayer.toString().split('.').last}: Start: ${formatTime(start)}, End: ${formatTime(end)}");

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
      debugPrint(
          "✅ Current Active Prayer: ${activePrayer.toString().split('.').last}");
      currentPrayer.value = activePrayer;
      isCurrentPrayerActive.value = true;
      upcomingPrayer.value = getNextPrayerAfter(activePrayer);
    } else {
      // No active prayer right now
      if (nextPrayer != null) {
        debugPrint(
            "⏭ Next Upcoming Prayer: ${nextPrayer.toString().split('.').last}");
        currentPrayer.value = null; // No current active prayer
        upcomingPrayer.value = nextPrayer;
        isCurrentPrayerActive.value = false;
      } else {
        // After Isha, next prayer is tomorrow's Fajr
        debugPrint(
            "⏭ All prayers completed for today, next is tomorrow's Fajr");
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

      debugPrint("📌 Current Active Prayer: ${currentPrayer.value}");
      debugPrint(
          "   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

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

      debugPrint("📌 Upcoming Prayer: ${upcomingPrayer.value}");
      debugPrint(
          "   Start: ${formatTime(startTime)}, End: ${formatTime(endTime)}");

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
    debugPrint("🕌 Prayer Times:");
    debugPrint(
        "   Fajr: ${formatTime(prayerTimes!.fajr)} - ${formatTime(getPrayerEndTime(Prayer.fajr))}");
    debugPrint("   Sunrise: ${formatTime(prayerTimes!.sunrise)}");
    debugPrint(
        "   Dhuhr: ${formatTime(prayerTimes!.dhuhr)} - ${formatTime(getPrayerEndTime(Prayer.dhuhr))}");
    debugPrint(
        "   Asr: ${formatTime(prayerTimes!.asr)} - ${formatTime(getPrayerEndTime(Prayer.asr))}");
    debugPrint(
        "   Maghrib: ${formatTime(prayerTimes!.maghrib)} - ${formatTime(getPrayerEndTime(Prayer.maghrib))}");
    debugPrint(
        "   Isha: ${formatTime(prayerTimes!.isha)} - ${formatTime(getPrayerEndTime(Prayer.isha))}");
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
