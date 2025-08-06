import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class QiblaController extends GetxController {
  Future<void> initializeLocationServices(
      StateSetter setState,
      Function(bool) setLocationServiceEnabled,
      Function(bool) setHasLocationPermission,
      Function(String?) setErrorMessage,
      Function(bool) setIsLoading) async {
    setState(() {
      setIsLoading(true);
      setErrorMessage(null);
    });

    try {
      // Check location service first
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

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          setHasLocationPermission(false);
          setErrorMessage(permission == LocationPermission.deniedForever
              ? 'Location permission permanently denied. Please enable in app settings.'
              : 'Location permission denied. Please allow location access.');
          setIsLoading(false);
        });
        return;
      }

      setState(() {
        setHasLocationPermission(true);
        setIsLoading(false);
      });
    } catch (e) {
      setState(() {
        setErrorMessage(
            'Error initializing location services: ${e.toString()}');
        setIsLoading(false);
      });
    }
  }

  Future<void> requestLocationPermission(
      Future<void> Function() initializeLocationServices) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await initializeLocationServices();
    }
  }

  Future<void> openLocationSettings(
      Future<void> Function() initializeLocationServices) async {
    await Geolocator.openLocationSettings();
    // Wait a bit and re-check
    await Future.delayed(const Duration(seconds: 2));
    await initializeLocationServices();
  }
}
