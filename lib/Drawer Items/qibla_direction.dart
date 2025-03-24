// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:tasbeeh_app/Components/animated_loader.dart';

// class QiblaScreen extends StatefulWidget {
//   const QiblaScreen({super.key});

//   @override
//   State<QiblaScreen> createState() => _QiblaScreenState();
// }

// class _QiblaScreenState extends State<QiblaScreen> {
//   final _locationStream = FlutterQiblah.qiblahStream;

//   @override
//   void initState() {
//     super.initState();
//     checkLocationPermission();
//   }

//   /// Check & Request Location Permission
//   Future<void> checkLocationPermission() async {
//     var status = await Permission.location.status;
//     if (!status.isGranted) {
//       await Permission.location.request();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Qibla Direction"),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: StreamBuilder<QiblahDirection>(
//         stream: _locationStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: AnimatedLoader(
//               color: Colors.green,
//             ));
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text("Error fetching Qibla direction"));
//           }

//           final qiblaDirection = snapshot.data!;
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Rotate your device to align with the Qibla",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 Transform.rotate(
//                   angle: qiblaDirection.direction *
//                       (3.1415926535 / 180), // Convert degrees to radians
//                   child: const Icon(
//                     Icons.navigation,
//                     size: 150,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   "Qibla Direction: ${qiblaDirection.offset.toStringAsFixed(2)}°",
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
