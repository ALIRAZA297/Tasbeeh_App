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
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';
import 'package:tasbeeh_app/View/Home%20Items/Iman%20Bases/iman_bases.dart';
import 'package:tasbeeh_app/View/Home%20Items/Nurani%20Qaida/nurani_qaida.dart';
import 'package:tasbeeh_app/View/Home%20Items/Quiz/quiz.dart';
import 'package:tasbeeh_app/View/Home%20Items/hadith/hadith_book_screen.dart';
import 'package:tasbeeh_app/View/Home/all_prayers.dart';

import '../Home Items/Asma ul Husna/Allah_names.dart';
import '../Home Items/Ibadat/ibadat.dart';
import '../Home Items/Kalama/kalma.dart';
import '../Home Items/Masnoon Dua/category_wise_dua.dart';
import '../Home Items/Quran/all_surah.dart';
import '../Home Items/Wadu/wadu_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final HomeController controller = Get.find<HomeController>();

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
                        color: primary700, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "Pull to refresh",
                      style: GoogleFonts.poppins(
                        color: primary700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              } else if (mode == RefreshStatus.refreshing) {
                body = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedLoader(color: primary700),
                    const SizedBox(height: 8),
                    Text(
                      "Fetching Prayer Times...",
                      style: GoogleFonts.poppins(
                        color: primary700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              } else if (mode == RefreshStatus.completed) {
                body = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: primary700, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "Prayer times updated!",
                      style: GoogleFonts.poppins(
                        color: primary700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              } else {
                body = Text(
                  "Release to refresh",
                  style: GoogleFonts.poppins(
                    color: primary700,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
              return Container(
                height: 85,
                padding: const EdgeInsets.symmetric(vertical: 12),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    final bool isMorning = controller.isMorning();
                    final currentPrayerTime = controller.getCurrentPrayerTime();
                    if (currentPrayerTime.isEmpty) {
                      return SizedBox(
                        height: screenHeight * 0.3,
                        child:
                            const Center(child: AnimatedLoader(color: white)),
                      );
                    }
                    final String startTime =
                        currentPrayerTime["start"] ?? "N/A";
                    final String endTime = currentPrayerTime["end"] ?? "N/A";

                    return GestureDetector(
                      onTap: () => Get.to(() => AllPrayersScreen()),
                      child: Container(
                        height: screenHeight * 0.4,
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(
                              isMorning
                                  ? 'assets/images/morning.png'
                                  : 'assets/images/evening.png',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Prayer Info (Left Side)
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: _buildPrayerInfo(
                                  controller, startTime, endTime),
                            ),
                            // Date Info (Left Side)
                            Positioned(
                              top: 12,
                              left: 12,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: _buildDateColumn(),
                            ),
                            // Theme Toggle
                            // const Positioned(
                            //   right: 12,
                            //   top: 12, // Adjusted to avoid overlap with clock
                            //   child: ThemeToggleSwitch(),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Menu Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Explore',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Get.isDarkMode ? white : black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Menu Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2,
                    children: [
                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidAllah,
                        title: 'Asma ul Husna',
                        subtitle: 'اسماء الحسنہ',
                        onTap: () => Get.to(() => const AsmaulHusnaScreen()),
                      ),
                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidQuran2,
                        title: 'Quran',
                        subtitle: 'قرآن',
                        onTap: () => Get.to(() => const SurahScreen()),
                      ),
                      // _buildGridTile(
                      //   icon: FlutterIslamicIcons.solidTasbih,
                      //   title: 'Tasbeeh',
                      //   subtitle: 'تسبیح',
                      //   onTap: () => Get.to(() => const TasbeehScreen()),
                      // ),
                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidMohammad,
                        title: 'Hadith Books',
                        subtitle: 'حدیث کی کتابیں',
                        onTap: () => Get.to(() => const HadithBooksScreen()),
                      ),

                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidLantern,
                        title: 'Masnoon Duas',
                        subtitle: 'مسنون دعائیں',
                        onTap: () => Get.to(() => const DuaCategoryScreen()),
                      ),
                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidWudhu,
                        title: 'Steps of Wudu',
                        subtitle: 'وضو کے مراحل',
                        onTap: () => Get.to(() => const WuduScreen()),
                      ),
                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidSajadah,
                        title: 'Ibadat',
                        subtitle: 'عبادت',
                        onTap: () => Get.to(() => IbadatScreen()),
                      ),
                      _buildGridTile(
                        icon: FlutterIslamicIcons.islam,
                        title: 'Six Kalimas',
                        subtitle: 'چھ کلمے',
                        onTap: () => Get.to(() => KalimaScreen()),
                      ),
                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidQuran,
                        title: 'Noorani Qaida',
                        subtitle: 'نورانی قائدہ',
                        onTap: () => Get.to(() => const NooraniQaida()),
                      ),
                      _buildGridTile(
                        icon: Icons.quiz,
                        title: 'Islamic Quiz',
                        subtitle: 'اسلامی کوئز',
                        onTap: () => Get.to(() => const QuizScreen()),
                      ),

                      _buildGridTile(
                        icon: FlutterIslamicIcons.solidMinaret,
                        title: 'Iman Bases',
                        subtitle: 'ایمان کی بنیادیں',
                        onTap: () => Get.to(() => const CombinedImanScreen()),
                      ),

                      // _buildGridTile(
                      //   icon: FlutterIslamicIcons.solidKaaba,
                      //   title: 'Qibla Direction',
                      //   subtitle: 'قبلہ سمت',
                      //   onTap: () => Get.to(() => const QiblaScreen()),
                      // ),
                      // _buildGridTile(
                      //   icon: CupertinoIcons.info_circle_fill,
                      //   title: 'About us',
                      //   subtitle: 'ہمارے بارے میں',
                      //   onTap: () => Get.to(() => const AboutPage()),
                      // ),
                      // _buildGridTile(
                      //   icon: CupertinoIcons.star_fill,
                      //   title: 'Rate us',
                      //   subtitle: 'ریٹ اس',
                      //   onTap: () =>
                      //       Get.find<CounterController>().launchReviewPage(),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerInfo(
      HomeController controller, String startTime, String endTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primary700.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            controller.currentPrayer.value != null
                ? 'Current Prayer'
                : 'Upcoming Prayer',
            style: GoogleFonts.poppins(
              color: white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          (controller.currentPrayer.value ?? controller.getUpcomingPrayer())
              .toString()
              .replaceAll("Prayer.", "")
              .capitalizeFirst!,
          style: GoogleFonts.poppins(
            color: white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTimeBox(label: 'Start', time: startTime),
            const SizedBox(width: 16),
            _buildTimeBox(label: 'End', time: endTime),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeBox({required String label, required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FlutterIslamicIcons.solidCrescentMoon,
                  color: white70, size: 22),
              const SizedBox(width: 8),
              Text(
                'Hijri',
                style: GoogleFonts.poppins(
                  color: white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '${HijriCalendar.now().toFormat("dd MMMM yyyy")} AH',
            style: GoogleFonts.poppins(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                CupertinoIcons.calendar,
                color: white70,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Gregorian',
                style: GoogleFonts.poppins(
                  color: white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            DateFormat('dd MMMM yyyy').format(DateTime.now()),
            style: GoogleFonts.poppins(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppButtonAnimation(
      child: Card(
        elevation: 3,
        shadowColor:
            Get.isDarkMode ? white.withOpacity(0.5) : grey800.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [secondary, white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primary700, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.notoNastaliqUrdu(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
