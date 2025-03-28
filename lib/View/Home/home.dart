import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animated_loader.dart';
import 'package:tasbeeh_app/Components/animation.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/View/Home%20Items/Asma%20ul%20Husna/Allah_names.dart';
import 'package:tasbeeh_app/View/Home%20Items/About%20us/about_page.dart';
import 'package:tasbeeh_app/View/Home%20Items/Masnoon%20Dua/category_wise_dua.dart';
import 'package:tasbeeh_app/View/Home%20Items/Quran/quran_view.dart';
import 'package:tasbeeh_app/View/Home%20Items/Tasbeeh/tasbeeh_screen.dart';

class PrayerScreen extends StatelessWidget {
  PrayerScreen({super.key});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final PrayerController controller = Get.find<PrayerController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer Times',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/mosque at night with fireworks_preview.gif',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Obx(
                      () => controller.isLoading.value
                          ? const AnimatedLoader(color: Colors.white)
                          : controller.prayerTimes.value == null
                              ? const Text(
                                  'Unable to fetch prayer times',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Fajr: ${controller.formatTime(controller.prayerTimes.value!.fajr)} - '
                                  '${controller.formatTime(controller.calculateEndTime(controller.prayerTimes.value!.fajr, Prayer.dhuhr))}\n\n'
                                  'Dhuhr: ${controller.formatTime(controller.prayerTimes.value!.dhuhr)} - '
                                  '${controller.formatTime(controller.calculateEndTime(controller.prayerTimes.value!.dhuhr, Prayer.asr))}\n\n'
                                  'Asr: ${controller.formatTime(controller.prayerTimes.value!.asr)} - '
                                  '${controller.formatTime(controller.calculateEndTime(controller.prayerTimes.value!.asr, Prayer.maghrib))}\n\n'
                                  'Maghrib: ${controller.formatTime(controller.prayerTimes.value!.maghrib)} - '
                                  '${controller.formatTime(controller.calculateEndTime(controller.prayerTimes.value!.maghrib, Prayer.isha))}\n\n'
                                  'Isha: ${controller.formatTime(controller.prayerTimes.value!.isha)} - '
                                  '${controller.formatTime(controller.calculateEndTime(controller.prayerTimes.value!.isha, Prayer.fajr))}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                    ),
                  ),
                ),
              ),
              ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  _buildListTile(
                    icon: FlutterIslamicIcons.solidAllah,
                    title: 'Asma ul Husna',
                    subtitle: 'اسماء الحسنہ',
                    onTap: () {
                      Get.to(() => const AsmaulHusnaScreen());
                    },
                  ),
                  _buildListTile(
                    icon: FlutterIslamicIcons.solidQuran2,
                    title: 'Quran',
                    subtitle: 'قرآن',
                    onTap: () {
                      Get.to(() => const QuranView());
                    },
                  ),
                  _buildListTile(
                    icon: FlutterIslamicIcons.solidTasbih,
                    title: 'Tasbeeh',
                    subtitle: 'تسبیح',
                    onTap: () {
                      Get.to(() => const TasbeehScreen());
                    },
                  ),
                  _buildListTile(
                    icon: FlutterIslamicIcons.solidLantern,
                    title: 'Masnoon Duas',
                    subtitle: 'مسنون دعائیں',
                    onTap: () {
                      // Get.find<DuaController>().clearStorageOnce();
                      Get.to(()=> const DuaCategoryScreen());
                    },
                  ),
                  _buildListTile(
                    icon: Icons.mosque,
                    title: 'Ibadat',
                    subtitle: 'عبادت',
                    onTap: () {},
                  ),
                  _buildListTile(
                    icon: FlutterIslamicIcons.solidKaaba,
                    title: 'Qibla Direction',
                    subtitle: 'قبلہ رخ',
                    onTap: () {
                      // Get.to(()=> const QiblaScreen());
                    },
                  ),
                  _buildListTile(
                    icon: CupertinoIcons.info_circle_fill,
                    title: 'About us',
                    subtitle: 'ہمارے بارے میں',
                    onTap: () {
                      Get.to(() => const AboutPage());
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppButtonAnimation(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.green.shade50,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: ListTile(
          splashColor: Colors.transparent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(
            icon,
            color: Colors.green.shade700,
            size: 30,
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              subtitle,
              style: GoogleFonts.notoNastaliqUrdu(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black45),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.green.shade700,
            size: 20,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
