import 'dart:developer';

import 'package:get/get.dart';
import 'package:adhan/adhan.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class PrayerController extends GetxController {
  Rx<PrayerTimes?> prayerTimes = Rx<PrayerTimes?>(null);
  final Location location = Location();
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getLocationAndPrayerTimes();
  }

  Future<void> getLocationAndPrayerTimes() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      // Check/request location permission
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      // Get current location
      LocationData locationData = await location.getLocation();
      final coordinates = Coordinates(locationData.latitude!, locationData.longitude!);
      
      // Calculate prayer times
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      prayerTimes.value = PrayerTimes.today(coordinates, params);
    } catch (e) {
      log('Error getting location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  DateTime calculateEndTime(DateTime startTime, Prayer nextPrayer) {
    if (prayerTimes.value == null) return startTime;
    
    DateTime endTime;
    switch (nextPrayer) {
      case Prayer.dhuhr:
        endTime = prayerTimes.value!.sunrise;
        break;
      case Prayer.asr:
        endTime = prayerTimes.value!.asr;
        break;
      case Prayer.maghrib:
        endTime = prayerTimes.value!.maghrib;
        break;
      case Prayer.isha:
        endTime = prayerTimes.value!.isha;
        break;
      case Prayer.fajr:
        endTime = prayerTimes.value!.fajr;
        break;
      default:
        endTime = startTime.add(const Duration(hours: 1));
    }
    return endTime.subtract(const Duration(minutes: 5));
  }
}