import 'package:adhan/adhan.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/prayer_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class AllPrayersScreen extends StatelessWidget {
  AllPrayersScreen({super.key});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final PrayerController controller = Get.find<PrayerController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Prayer Times',
          style: GoogleFonts.poppins(
            color: Get.isDarkMode ? white : black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomRefreshIndicator(
          offsetToArmed: 100.0,
          onRefresh: () async {
            await controller.fetchPrayerTimes();
            return Future.delayed(const Duration(milliseconds: 500));
          },
          builder: (
            BuildContext context,
            Widget child,
            IndicatorController indicatorController,
          ) {
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: indicatorController,
                  builder: (context, _) {
                    final value = indicatorController.value.clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(0, value * 100),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          height: 100,
                          color: primary700.withOpacity(0.2),
                          child: Center(
                            child: indicatorController.isLoading
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitFadingCircle(
                                        color: primary700,
                                        size: 50.0,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Fetching Prayer Times...",
                                        style: GoogleFonts.poppins(
                                          color: primary700,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FlutterIslamicIcons.solidMosque,
                                        color: primary700,
                                        size: 40 * value,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        indicatorController.isDragging
                                            ? "Pull to refresh"
                                            : "Release to refresh",
                                        style: GoogleFonts.poppins(
                                          color: primary700,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Transform.translate(
                  offset: Offset(0, indicatorController.value * 100),
                  child: child,
                ),
              ],
            );
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: SpinKitFadingCircle(
                          color: primary700,
                          size: 50.0,
                        ),
                      )
                    : Column(
                        children: [
                          _buildPrayerCard(
                            context,
                            icon: FlutterIslamicIcons.solidMosque,
                            prayerName: 'Fajr',
                            startTime: controller.formatTime(
                                controller.getPrayerStartTime(Prayer.fajr)),
                            endTime: controller.formatTime(
                                controller.getPrayerEndTime(Prayer.fajr)),
                            isCurrent:
                                controller.currentPrayer.value == Prayer.fajr,
                          ),
                          const SizedBox(height: 12),
                          _buildPrayerCard(
                            context,
                            icon: FlutterIslamicIcons.solidMosque,
                            prayerName: 'Dhuhr',
                            startTime: controller.formatTime(
                                controller.getPrayerStartTime(Prayer.dhuhr)),
                            endTime: controller.formatTime(
                                controller.getPrayerEndTime(Prayer.dhuhr)),
                            isCurrent:
                                controller.currentPrayer.value == Prayer.dhuhr,
                          ),
                          const SizedBox(height: 12),
                          _buildPrayerCard(
                            context,
                            icon: FlutterIslamicIcons.solidMosque,
                            prayerName: 'Asr',
                            startTime: controller.formatTime(
                                controller.getPrayerStartTime(Prayer.asr)),
                            endTime: controller.formatTime(
                                controller.getPrayerEndTime(Prayer.asr)),
                            isCurrent:
                                controller.currentPrayer.value == Prayer.asr,
                          ),
                          const SizedBox(height: 12),
                          _buildPrayerCard(
                            context,
                            icon: FlutterIslamicIcons.solidMosque,
                            prayerName: 'Maghrib',
                            startTime: controller.formatTime(
                                controller.getPrayerStartTime(Prayer.maghrib)),
                            endTime: controller.formatTime(
                                controller.getPrayerEndTime(Prayer.maghrib)),
                            isCurrent: controller.currentPrayer.value ==
                                Prayer.maghrib,
                          ),
                          const SizedBox(height: 12),
                          _buildPrayerCard(
                            context,
                            icon: FlutterIslamicIcons.solidMosque,
                            prayerName: 'Isha',
                            startTime: controller.formatTime(
                                controller.getPrayerStartTime(Prayer.isha)),
                            endTime: controller.formatTime(
                                controller.getPrayerEndTime(Prayer.isha)),
                            isCurrent:
                                controller.currentPrayer.value == Prayer.isha,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerCard(
    BuildContext context, {
    required IconData icon,
    required String prayerName,
    required String startTime,
    required String endTime,
    required bool isCurrent,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrent ? primary700 : grey300,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: white,
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/bg image.jpg",
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Get.isDarkMode ? white : primary100,
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(
            icon,
            color: primary700,
            size: 30,
          ),
          title: Text(
            prayerName,
            style: GoogleFonts.poppins(
              color: black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Start: $startTime\nEnd: $endTime',
            style: GoogleFonts.poppins(
              color: black54,
              fontSize: 14,
            ),
          ),
          trailing: isCurrent
              ? Icon(
                  Icons.check_circle,
                  color: primary700,
                  size: 24,
                )
              : null,
        ),
      ),
    );
  }
}
