// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:tasbeeh_app/Components/animated_loader.dart';
// import 'package:tasbeeh_app/Controller/qibla_direction_controller.dart';

// class QiblaScreen extends StatelessWidget {
//   const QiblaScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final QiblaController controller = Get.put(QiblaController());

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Qibla Direction",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: Obx(
//         () => controller.isLoading.value
//             ? const Center(child: AnimatedLoader(color: Colors.green))
//             : controller.errorMessage.value.isNotEmpty
//                 ? Center(
//                     child: Text(
//                       controller.errorMessage.value,
//                       style: const TextStyle(fontSize: 16, color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                   )
//                 : StreamBuilder<QiblahDirection>(
//                     stream: controller.qiblahStream,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: AnimatedLoader(color: Colors.green));
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             "Error: ${snapshot.error}",
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );
//                       }

//                       final qiblaDirection = snapshot.data!;
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Rotate your device to align with the Qibla",
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 20),
//                             Transform.rotate(
//                               angle: (qiblaDirection.qiblah) * (3.1415926535 / 180),
//                               child: const Icon(
//                                 Icons.navigation,
//                                 size: 150,
//                                 color: Colors.green,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Text(
//                               "Qibla Direction: ${qiblaDirection.offset.toStringAsFixed(2)}°",
//                               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//       ),
//     );
//   }
// }