// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hijri/hijri_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:tasbeeh_app/Components/animated_loader.dart';
// import 'package:tasbeeh_app/Components/animation.dart';
// import 'package:tasbeeh_app/Components/custom_toggle_btn.dart';
// import 'package:tasbeeh_app/Controller/counter_controller.dart';
// import 'package:tasbeeh_app/Controller/prayer_controller.dart';
// import 'package:tasbeeh_app/View/Home%20Items/About%20us/about_page.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Asma%20ul%20Husna/Allah_names.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Ibadat/ibadat.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Kalama/kalma.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Masnoon%20Dua/category_wise_dua.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Quran/quran_view.dart';
// import 'package:tasbeeh_app/View/Home%20Items/Tasbeeh/tasbeeh_screen.dart';

// class PrayerScreen extends StatelessWidget {
//   PrayerScreen({super.key});
//   final ScrollController scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     // Initialize controller
//     final PrayerController controller = Get.find<PrayerController>();
//     return Scaffold(
//       // appBar: AppBar(
//       //   scrolledUnderElevation: 0,
//       //   title: Text(
//       //     'Prayer Times',
//       //     style: GoogleFonts.poppins(
//       //       fontWeight: FontWeight.bold,
//       //       color: Colors.black,
//       //     ),
//       //   ),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.white,
//       // ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Obx(
//                 () {
//                   final bool isMorning = controller.isMorning();
//                   final currentPrayerTime = controller.getCurrentPrayerTime();
//                   // ignore: unnecessary_null_comparison
//                   if (currentPrayerTime == null || currentPrayerTime.isEmpty) {
//                     return const Center(
//                         child: AnimatedLoader(
//                             color: Colors.white)); // Prevents crash
//                   }

//                   final String startTime = currentPrayerTime["start"] ?? "N/A";
//                   final String endTime = currentPrayerTime["end"] ?? "N/A";

//                   return Container(
//                     height: 320,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                           isMorning
//                               ? 'assets/images/morning.png'
//                               : 'assets/images/evening.png',
//                         ),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     child: Stack(
//                       children: [
//                         // Overlay Color
//                         Container(
//                           color: Colors.black.withOpacity(0.2),
//                         ),

//                         // Prayer Time Text
//                         Positioned(
//                           bottom: 10,
//                           right: 10,
//                           child: controller.isLoading.value
//                               ? const AnimatedLoader(color: Colors.white)
//                               : Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: controller.currentPrayer.value !=
//                                                 null
//                                             ? 'Prayer Time \n'
//                                             : 'Upcoming Prayer \n',
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: controller.currentPrayer.value !=
//                                                 null
//                                             ? '${controller.currentPrayer.value.toString().replaceAll("Prayer.", "").capitalize}\n'
//                                             : '${controller.getUpcomingPrayer().toString().replaceAll("Prayer.", "").capitalize}\n',
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 22, // Bigger size
//                                           fontWeight:
//                                               FontWeight.w900, // Extra Bold
//                                         ),
//                                       ),

//                                       // "Start:" (Less Bold)
//                                       TextSpan(
//                                         text: 'Start:\n',
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 16, // Smaller size
//                                           fontWeight:
//                                               FontWeight.w500, // Medium Bold
//                                         ),
//                                       ),

//                                       // Start Time (More Bold)
//                                       TextSpan(
//                                         text: '$startTime\n',
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 20, // Bigger size
//                                           fontWeight: FontWeight.w800, // Bold
//                                         ),
//                                       ),

//                                       // "End:" (Less Bold)
//                                       TextSpan(
//                                         text: 'End:\n',
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 16, // Smaller size
//                                           fontWeight:
//                                               FontWeight.w500, // Medium Bold
//                                         ),
//                                       ),

//                                       // End Time (More Bold)
//                                       TextSpan(
//                                         text: endTime,
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 20, // Bigger size
//                                           fontWeight: FontWeight.w800, // Bold
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   textAlign: TextAlign.left,
//                                 ),
//                         ),

//                         // Date Display in Bottom Right Corner
//                         Positioned(
//                           left: 10,
//                           top: 10,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Hijri Date
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: 'Hijri Date:\n',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text:
//                                               '${HijriCalendar.now().toFormat("dd").padLeft(2, '0')} ', // Day on a separate line
//                                           style: GoogleFonts.poppins(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight
//                                                   .w900), // Bigger font for day
//                                         ),
//                                         TextSpan(
//                                           text:
//                                               '${HijriCalendar.now().toFormat("MMMM yyyy")} AH', // Month & Year on next line
//                                           style: GoogleFonts.poppins(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight
//                                                   .w900), // Bigger font for day
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   const SizedBox(
//                                       height: 8), // Spacing between dates

//                                   // Gregorian Date
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: 'Gregorian Date:\n',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text:
//                                               '${DateFormat('dd').format(DateTime.now())} ', // Day on a separate line
//                                           style: GoogleFonts.poppins(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight
//                                                   .w900), // Bigger font for day
//                                         ),
//                                         TextSpan(
//                                           text: DateFormat('EEEE, MMMM yyyy')
//                                               .format(
//                                             DateTime.now(),
//                                           ), // Day Name, Month, Year
//                                           style: GoogleFonts.poppins(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.w900),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         const Positioned(
//                           left: 10,
//                           bottom: 10,
//                           child: ThemeToggleSwitch(),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               ListView(
//                 controller: scrollController,
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   _buildListTile(
//                     icon: FlutterIslamicIcons.solidAllah,
//                     title: 'Asma ul Husna',
//                     subtitle: 'اسماء الحسنہ',
//                     onTap: () {
//                       Get.to(() => const AsmaulHusnaScreen());
//                     },
//                   ),
//                   _buildListTile(
//                     icon: FlutterIslamicIcons.solidQuran2,
//                     title: 'Quran',
//                     subtitle: 'قرآن',
//                     onTap: () {
//                       Get.to(() => const QuranView());
//                     },
//                   ),
//                   _buildListTile(
//                     icon: FlutterIslamicIcons.solidTasbih,
//                     title: 'Tasbeeh',
//                     subtitle: 'تسبیح',
//                     onTap: () {
//                       Get.to(() => const TasbeehScreen());
//                     },
//                   ),
//                   _buildListTile(
//                     icon: FlutterIslamicIcons.solidLantern,
//                     title: 'Masnoon Duas',
//                     subtitle: 'مسنون دعائیں',
//                     onTap: () {
//                       // Get.find<DuaController>().clearStorageOnce();
//                       Get.to(() => const DuaCategoryScreen());
//                     },
//                   ),
//                   // _buildListTile(
//                   //   icon: FlutterIslamicIcons.solidKaaba,
//                   //   title: 'Qibla Direction',
//                   //   subtitle: 'قبلہ رخ',
//                   //   onTap: () {
//                   //     // Get.to(()=> const QiblaScreen());
//                   //   },
//                   // ),

//                   _buildListTile(
//                     icon: FlutterIslamicIcons.solidSajadah,
//                     title: 'Ibadat',
//                     subtitle: 'عبادت',
//                     onTap: () {
//                       Get.to(() => IbadatScreen());
//                     },
//                   ),
//                   _buildListTile(
//                     icon: FlutterIslamicIcons.islam,
//                     title: 'Six Kalimas',
//                     subtitle: 'چھ کلمے',
//                     onTap: () {
//                       Get.to(() => KalimaScreen());
//                     },
//                   ),
//                   _buildListTile(
//                     icon: CupertinoIcons.info_circle_fill,
//                     title: 'About us',
//                     subtitle: 'ہمارے بارے میں',
//                     onTap: () {
//                       Get.to(() => const AboutPage());
//                     },
//                   ),
//                   _buildListTile(
//                     icon: CupertinoIcons.star_fill,
//                     title: 'Rate us',
//                     subtitle: 'ریٹ اس',
//                     onTap: () {
//                       Get.find<CounterController>().launchReviewPage();
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildListTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return AppButtonAnimation(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.green.shade50,
//         ),
//         margin: const EdgeInsets.symmetric(
//           horizontal: 8,
//           vertical: 4,
//         ),
//         child: ListTile(
//           splashColor: Colors.transparent,
//           shape: BeveledRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           leading: Icon(
//             icon,
//             color: Colors.green.shade700,
//             size: 30,
//           ),
//           title: Text(
//             title,
//             style: GoogleFonts.poppins(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(
//               subtitle,
//               style: GoogleFonts.notoNastaliqUrdu(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 16,
//                   color: Colors.black45),
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: Colors.green.shade700,
//             size: 20,
//           ),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tasbeeh_app/Components/animated_loader.dart';
import 'package:tasbeeh_app/Components/animation.dart';
import 'package:tasbeeh_app/Components/custom_toggle_btn.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/View/Home%20Items/About%20us/about_page.dart';
import 'package:tasbeeh_app/View/Home%20Items/Asma%20ul%20Husna/Allah_names.dart';
import 'package:tasbeeh_app/View/Home%20Items/Ibadat/ibadat.dart';
import 'package:tasbeeh_app/View/Home%20Items/Masnoon%20Dua/category_wise_dua.dart';
import 'package:tasbeeh_app/View/Home%20Items/Quran/quran_view.dart';
import 'package:tasbeeh_app/View/Home%20Items/Tasbeeh/tasbeeh_screen.dart';
import 'package:tasbeeh_app/View/Home/all_prayers.dart';

import '../Home Items/Kalama/kalma.dart';

class PrayerScreen extends StatelessWidget {
  PrayerScreen({super.key});

  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final PrayerController controller = Get.find<PrayerController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          header: CustomHeader(
            builder: (context, mode) {
              Widget body;
              if (mode == RefreshStatus.idle) {
                body = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FlutterIslamicIcons.solidMosque,
                        color: Colors.green.shade700, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      "Pull to refresh prayer times",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              } else if (mode == RefreshStatus.refreshing) {
                body = Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedLoader(color: Colors.green.shade700),
                    const SizedBox(height: 10.0),
                    Text(
                      "Fetching Prayer Times...",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              } else if (mode == RefreshStatus.completed) {
                body = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green.shade700, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      "Prayer times updated!",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              } else {
                body = Text(
                  "Release to refresh",
                  style: GoogleFonts.poppins(
                    color: Colors.green.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              return Container(
                height: 110,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: body),
              );
            },
          ),
          onRefresh: () async {
            await controller.fetchPrayerTimes();
            refreshController.refreshCompleted();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Obx(
                  () {
                    final bool isMorning = controller.isMorning();
                    final currentPrayerTime = controller.getCurrentPrayerTime();

                    if (currentPrayerTime.isEmpty) {
                      return const Center(
                          child: AnimatedLoader(color: Colors.white));
                    }

                    final String startTime =
                        currentPrayerTime["start"] ?? "N/A";
                    final String endTime = currentPrayerTime["end"] ?? "N/A";

                    return InkWell(
                      onTap: () {
                        Get.to(() => AllPrayersScreen());
                      },
                      child: SizedBox(
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Background image
                            Positioned.fill(
                              child: Image.asset(
                                isMorning
                                    ? 'assets/images/morning.png'
                                    : 'assets/images/evening.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Overlay
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            // Date on Top Left
                            Positioned(
                              left: 10,
                              top: 8,
                              right: MediaQuery.of(context).size.width * 0.45,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: _buildDateColumn(),
                              ),
                            ),
                            // Prayer Info on Bottom Right
                            Positioned(
                              bottom: 8,
                              right: 10,
                              left: MediaQuery.of(context).size.width * 0.55,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                child: _buildPrayerInfo(
                                    controller, startTime, endTime),
                              ),
                            ),
                            const Positioned(
                              left: 10,
                              bottom: 10,
                              child: ThemeToggleSwitch(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 5),
                    _buildListTile(
                      icon: FlutterIslamicIcons.solidAllah,
                      title: 'Asma ul Husna',
                      subtitle: 'اسماء الحسنہ',
                      onTap: () => Get.to(() => const AsmaulHusnaScreen()),
                    ),
                    _buildListTile(
                      icon: FlutterIslamicIcons.solidQuran2,
                      title: 'Quran',
                      subtitle: 'قرآن',
                      onTap: () => Get.to(() => const QuranView()),
                    ),
                    _buildListTile(
                      icon: FlutterIslamicIcons.solidTasbih,
                      title: 'Tasbeeh',
                      subtitle: 'تسبیح',
                      onTap: () => Get.to(() => const TasbeehScreen()),
                    ),
                    _buildListTile(
                      icon: FlutterIslamicIcons.solidLantern,
                      title: 'Masnoon Duas',
                      subtitle: 'مسنون دعائیں',
                      onTap: () => Get.to(() => const DuaCategoryScreen()),
                    ),
                    _buildListTile(
                      icon: FlutterIslamicIcons.solidSajadah,
                      title: 'Ibadat',
                      subtitle: 'عبادت',
                      onTap: () => Get.to(() => IbadatScreen()),
                    ),
                    _buildListTile(
                      icon: FlutterIslamicIcons.islam,
                      title: 'Six Kalimas',
                      subtitle: 'چھ کلمے',
                      onTap: () => Get.to(() => KalimaScreen()),
                    ),
                    _buildListTile(
                      icon: CupertinoIcons.info_circle_fill,
                      title: 'About us',
                      subtitle: 'ہمارے بارے میں',
                      onTap: () => Get.to(() => const AboutPage()),
                    ),
                    _buildListTile(
                      icon: CupertinoIcons.star_fill,
                      title: 'Rate us',
                      subtitle: 'ریٹ اس',
                      onTap: () =>
                          Get.find<CounterController>().launchReviewPage(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerInfo(
    PrayerController controller,
    String startTime,
    String endTime,
  ) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: controller.currentPrayer.value != null
                  ? 'Current Prayer\n'
                  : 'Upcoming Prayer\n',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: (controller.currentPrayer.value ??
                      controller.getUpcomingPrayer())
                  .toString()
                  .replaceAll("Prayer.", "")
                  .capitalizeFirst!,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: '\nStart:\n',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            TextSpan(
              text: '$startTime\n',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'End:\n',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            TextSpan(
              text: endTime,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildDateColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hijri Date:\n',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                TextSpan(
                  text: '${HijriCalendar.now().toFormat("dd")} ',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextSpan(
                  text: '${HijriCalendar.now().toFormat("MMMM yyyy")} AH',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Gregorian Date:\n',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              TextSpan(
                text: '${DateFormat('dd').format(DateTime.now())} ',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextSpan(
                text: DateFormat('EEEE, MMMM yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          splashColor: Colors.transparent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(icon, color: Colors.green.shade700, size: 30),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
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
                color: Colors.black45,
              ),
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios,
              color: Colors.green.shade700, size: 20),
          onTap: onTap,
        ),
      ),
    );
  }
}
