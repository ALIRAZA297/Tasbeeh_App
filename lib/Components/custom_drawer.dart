import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Drawer%20Items/Allah_names.dart';
import 'package:tasbeeh_app/Drawer%20Items/about_page.dart';
import 'package:tasbeeh_app/Drawer%20Items/quran_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Colors.green.shade100),
          //     child: ListTile(
          //       leading: const Icon(Icons.home, color: Colors.green),
          //       title: const Text("Home"),
          //       onTap: () => Get.off(() => const CounterHomePage()),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.shade100),
              child: ListTile(
                leading: const Icon(FlutterIslamicIcons.solidQuran,
                    color: Colors.green),
                title: const Text("Read Quran"),
                onTap: () => Get.to(() => const QuranView()),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Colors.green.shade100),
          //     child: ListTile(
          //         leading:
          //             const Icon(Icons.menu_book_rounded, color: Colors.green),
          //         title: const Text("Hadiths"),
          //         onTap: () {
          //           Get.back();
          //           Get.to(() => const HadithBooksView());
          //         }),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.shade100),
              child: ListTile(
                  leading: const Icon(
                    FlutterIslamicIcons.allah99,
                    color: Colors.green,
                  ),
                  title: const Text("Asmaul Husna "),
                  onTap: () {
                    Get.back();
                    Get.to(() => const AsmaulHusnaScreen());
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.shade100),
              child: ListTile(
                  leading: const Icon(Icons.info, color: Colors.green),
                  title: const Text("About"),
                  onTap: () {
                    Get.back();
                    Get.to(() => const AboutPage());
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
