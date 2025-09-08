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

import '../../Components/clock.dart';
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
                    Obx(
                      () => Icon(FlutterIslamicIcons.solidMosque,
                          color: primary700, size: 24),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        "Pull to refresh",
                        style: GoogleFonts.poppins(
                          color: primary700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              } else if (mode == RefreshStatus.refreshing) {
                body = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => AnimatedLoader(color: primary700)),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        "Fetching Prayer Times...",
                        style: GoogleFonts.poppins(
                          color: primary700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
                    Obx(
                      () => Text(
                        "Prayer times updated!",
                        style: GoogleFonts.poppins(
                          color: primary700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
                // NEW MODERN UPPER SECTION DESIGN
                Obx(() {
                  final bool isMorning = controller.isMorning();
                  final currentPrayerTime = controller.getCurrentPrayerTime();
                  if (currentPrayerTime.isEmpty) {
                    return SizedBox(
                      height: screenHeight * 0.3,
                      child: const Center(
                          child: AnimatedLoader(color: AppColors.white)),
                    );
                  }
                  final String startTime = currentPrayerTime["start"] ?? "N/A";
                  final String endTime = currentPrayerTime["end"] ?? "N/A";

                  return GestureDetector(
                    onTap: () => Get.to(() => AllPrayersScreen()),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Main Prayer Card with Modern Design
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  primary700,
                                  primary900,
                                  AppColors.black87,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primary700.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Background pattern
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          isMorning
                                              ? 'assets/images/morning.png'
                                              : 'assets/images/evening.png',
                                        ),
                                        fit: BoxFit.cover,
                                        opacity: 0.15,
                                      ),
                                    ),
                                  ),
                                ),

                                // Islamic pattern overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          AppColors.transparent,
                                          primary700.withOpacity(0.1),
                                          primary900.withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Top decorative element
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.white.withOpacity(0.1),
                                          AppColors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Content
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Prayer status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.white.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: AppColors.white
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              FlutterIslamicIcons.solidMosque,
                                              color: AppColors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              controller.currentPrayer.value !=
                                                      null
                                                  ? 'Current Prayer'
                                                  : 'Upcoming Prayer',
                                              style: GoogleFonts.poppins(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Spacer(),

                                      // Prayer name with modern styling
                                      Text(
                                        (controller.currentPrayer.value ??
                                                controller.getUpcomingPrayer())
                                            .toString()
                                            .replaceAll("Prayer.", "")
                                            .capitalizeFirst!,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                          shadows: [
                                            Shadow(
                                              offset: const Offset(0, 2),
                                              blurRadius: 8,
                                              color: AppColors.black
                                                  .withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      // Time display with modern boxes
                                      Row(
                                        children: [
                                          _buildModernTimeCard(
                                            label: 'Start',
                                            time: startTime,
                                            icon: Icons.schedule,
                                          ),
                                          const SizedBox(width: 12),
                                          _buildModernTimeCard(
                                            label: 'End',
                                            time: endTime,
                                            icon: Icons.schedule_send,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Floating Islamic icon
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      FlutterIslamicIcons.solidCrescentMoon,
                                      color: AppColors.white.withOpacity(0.8),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const DigitalClock(),

                          // Date Cards Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateCard(
                                  title: 'Hijri Date',
                                  date:
                                      '${HijriCalendar.now().toFormat("dd MMMM yyyy")} AH',
                                  icon: FlutterIslamicIcons.solidCrescentMoon,
                                  isHijri: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDateCard(
                                  title: 'Gregorian',
                                  date: DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()),
                                  icon: CupertinoIcons.calendar,
                                  isHijri: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                // Menu Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Explore',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color:
                          Get.isDarkMode ? AppColors.white : AppColors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Menu Items (UNCHANGED)
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

  Widget _buildModernTimeCard({
    required String label,
    required String time,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard({
    required String title,
    required String date,
    required IconData icon,
    required bool isHijri,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.grey800 : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primary700.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: primary700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Get.isDarkMode ? AppColors.white : AppColors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: GoogleFonts.poppins(
              color: Get.isDarkMode ? AppColors.white70 : AppColors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
    return Obx(
      () => AppButtonAnimation(
        child: Card(
          elevation: 3,
          shadowColor: Get.isDarkMode
              ? AppColors.white.withOpacity(0.5)
              : AppColors.grey800.withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [primary100, AppColors.white],
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
                      color: AppColors.black87,
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
                      color: AppColors.black54,
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
      ),
    );
  }
}
