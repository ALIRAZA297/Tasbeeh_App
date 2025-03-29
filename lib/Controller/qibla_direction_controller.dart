// // import 'package:flutter_qiblah/flutter_qiblah.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:get/get.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // class QiblaController extends GetxController {
// //   // Observable variables
// //   var isLoading = true.obs;
// //   var errorMessage = RxString('');
// //   final qiblahStream = FlutterQiblah.qiblahStream;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     checkAndRequestPermissions();
// //   }

// //   /// Check and request location permissions, and ensure location services are enabled
// //   Future<void> checkAndRequestPermissions() async {
// //     try {
// //       // Check if location services are enabled
// //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //       if (!serviceEnabled) {
// //         errorMessage.value = "Please enable location services.";
// //         isLoading.value = false;
// //         return;
// //       }

// //       // Check location permission
// //       PermissionStatus status = await Permission.location.status;
// //       if (status.isDenied) {
// //         status = await Permission.location.request();
// //       }

// //       if (status.isGranted) {
// //         isLoading.value = false;
// //       } else if (status.isPermanentlyDenied) {
// //         errorMessage.value = "Location permission is permanently denied. Please enable it in settings.";
// //         isLoading.value = false;
// //         await openAppSettings();
// //       } else {
// //         errorMessage.value = "Location permission denied.";
// //         isLoading.value = false;
// //       }
// //     } catch (e) {
// //       errorMessage.value = "Error initializing Qibla: $e";
// //       isLoading.value = false;
// //     }
// //   }
// // }

// import 'dart:developer';

// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class QiblaController extends GetxController {
//   // Observable variables
//   var isLoading = true.obs;
//   var errorMessage = ''.obs; // Initialize as an empty string with .obs
//   final qiblahStream = FlutterQiblah.qiblahStream;

//   @override
//   void onInit() {
//     super.onInit();
//     checkAndRequestPermissions();
//   }

//   /// Check and request location permissions, and ensure location services are enabled
//   Future<void> checkAndRequestPermissions() async {
//     try {
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         errorMessage.value = "Please enable location services.";
//         isLoading.value = false;
//         return;
//       }

//       // Check location permission
//       PermissionStatus status = await Permission.location.status;
//       if (status.isDenied) {
//         status = await Permission.location.request();
//       }

//       if (status.isGranted) {
//         isLoading.value = false;
//       } else if (status.isPermanentlyDenied) {
//         errorMessage.value = "Location permission is permanently denied. Please enable it in settings.";
//         isLoading.value = false;
//         await openAppSettings();
//       } else {
//         errorMessage.value = "Location permission denied.";
//         isLoading.value = false;
//       }
//     } catch (e) {
//       log(e.toString());
//       errorMessage.value = "Error initializing Qibla: ${e.toString()}"; // Use .value and toString() for safety
//       isLoading.value = false;
//     }
//   }
// }