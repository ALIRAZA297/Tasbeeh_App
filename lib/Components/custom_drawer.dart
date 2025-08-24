// import 'package:flutter/material.dart';
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:get/get.dart';
// import 'package:tasbeeh_app/Utils/app_colors.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Asma%20ul%20Husna/Allah_names.dart';
// import 'package:tasbeeh_app/View/Home%20Items/About%20us/about_page.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: white,
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //         borderRadius: BorderRadius.circular(15),
//           //         color: Colors.green.shade100),
//           //     child: ListTile(
//           //       leading: const Icon(Icons.home, color: Colors.green),
//           //       title: const Text("Home"),
//           //       onTap: () => Get.off(() => const CounterHomePage()),
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15), color: primary100),
//               child: ListTile(
//                 leading:
//                     const Icon(FlutterIslamicIcons.solidQuran, color: primary),
//                 title: const Text("Read Quran"),
//                 onTap: () => Get.to(() => const QuranView()),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //         borderRadius: BorderRadius.circular(15),
//           //         color: Colors.green.shade100),
//           //     child: ListTile(
//           //         leading:
//           //             const Icon(Icons.menu_book_rounded, color: Colors.green),
//           //         title: const Text("Hadiths"),
//           //         onTap: () {
//           //           Get.back();
//           //           Get.to(() => const HadithBooksView());
//           //         }),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15), color: primary100),
//               child: ListTile(
//                   leading: const Icon(
//                     FlutterIslamicIcons.allah99,
//                     color: primary,
//                   ),
//                   title: const Text("Asmaul Husna "),
//                   onTap: () {
//                     Get.back();
//                     Get.to(() => const AsmaulHusnaScreen());
//                   }),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15), color: primary100),
//               child: ListTile(
//                   leading: const Icon(Icons.info, color: primary),
//                   title: const Text("About"),
//                   onTap: () {
//                     Get.back();
//                     Get.to(() => const AboutPage());
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
