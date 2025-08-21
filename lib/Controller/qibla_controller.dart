import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class QiblaController extends GetxController {
  Future<void> initializeLocationServices(
    StateSetter setState,
    Function(bool) setLocationServiceEnabled,
    Function(bool) setHasLocationPermission,
    Function(String?) setErrorMessage,
    Function(bool) setIsLoading,
  ) async {
    setState(() {
      setIsLoading(true);
      setErrorMessage(null);
    });

    try {
      // 🔹 Step 1: Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      setState(() {
        setLocationServiceEnabled(serviceEnabled);
      });

      if (!serviceEnabled) {
        setState(() {
          setErrorMessage('Location services are disabled. Please enable GPS.');
          setIsLoading(false);
        });
        return;
      }

      // 🔹 Step 2: Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          setHasLocationPermission(false);
          setErrorMessage(
              'Location permission denied. Please allow location access.');
          setIsLoading(false);
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          setHasLocationPermission(false);
          setErrorMessage(
              'Location permission permanently denied. Please enable it from app settings.');
          setIsLoading(false);
        });
        return;
      }

      // 🔹 If permission granted
      setState(() {
        setHasLocationPermission(true);
        setIsLoading(false);
      });
    } catch (e) {
      setState(() {
        setErrorMessage('Error initializing location services: $e');
        setIsLoading(false);
      });
    }
  }

  /// Request permission and retry
  Future<void> requestLocationPermission(
      Future<void> Function() initializeLocationServices) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await initializeLocationServices();
    } else if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Permission Required",
        "Please enable location access from app settings.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Open location settings and retry
  Future<void> openLocationSettings(
      Future<void> Function() initializeLocationServices) async {
    await Geolocator.openLocationSettings();
    await Future.delayed(const Duration(seconds: 2));
    await initializeLocationServices();
  }
}
