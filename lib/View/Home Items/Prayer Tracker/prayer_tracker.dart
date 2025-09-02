import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Controller/prayer_tracker_controller.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/prayer_tracker_status.dart';
import 'monthly_prayer_tracker.dart';

class PrayerTrackerScreen extends StatelessWidget {
  const PrayerTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final PrayerTrackerController controller =
        Get.put(PrayerTrackerController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Prayer Tracker',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.bar_chart,
              color: isDarkMode ? AppColors.white : AppColors.grey800,
            ),
            onPressed: () {
              Get.to(
                () => MonthlyPrayerReportScreen(
                  initialMonth: controller.selectedMonth.value,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendarView(controller, isDarkMode),
              const SizedBox(height: 4),
              Text(
                'Prayers',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? AppColors.white : AppColors.grey800,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(left: 8),
              const SizedBox(height: 8),
              _buildPrayerList(controller, isDarkMode),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView(
      PrayerTrackerController controller, bool isDarkMode) {
    return Obx(() {
      final now = DateTime.now();
      final isCurrentOrFutureMonth =
          controller.selectedMonth.value.year > now.year ||
              (controller.selectedMonth.value.year == now.year &&
                  controller.selectedMonth.value.month >= now.month);
      final startOfWeek = controller.selectedDate.value
          .subtract(Duration(days: controller.selectedDate.value.weekday - 1));
      final days = List.generate(14, (i) => startOfWeek.add(Duration(days: i)));
      final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy')
                      .format(controller.selectedMonth.value),
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? AppColors.white : AppColors.grey800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  splashColor: AppColors.transparent,
                  onTap: () => controller.changeMonth(-1),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_left,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  splashColor: AppColors.transparent,
                  onTap: isCurrentOrFutureMonth
                      ? null
                      : () => controller.changeMonth(1),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                          isCurrentOrFutureMonth ? AppColors.grey300 : primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_right,
                      color: isCurrentOrFutureMonth
                          ? AppColors.grey700
                          : AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekdayNames.map((name) {
                return SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDarkMode ? AppColors.white60 : AppColors.grey700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days
                  .sublist(0, 7)
                  .map((date) => _buildDateTile(controller, date, isDarkMode))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days
                  .sublist(7, 14)
                  .map((date) => _buildDateTile(controller, date, isDarkMode))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDateTile(
      PrayerTrackerController controller, DateTime date, bool isDarkMode) {
    return Obx(() {
      final now = DateTime.now();
      final currentDay = DateTime(now.year, now.month, now.day);

      // Normalize everything (drop hours/minutes/seconds)
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final normalizedSelected = DateTime(
          controller.selectedDate.value.year,
          controller.selectedDate.value.month,
          controller.selectedDate.value.day);

      final isFutureDate = normalizedDate.isAfter(currentDay);
      final isSelected = normalizedDate == normalizedSelected;
      final isToday = normalizedDate == currentDay;
      final isInSelectedMonth =
          normalizedDate.month == controller.selectedMonth.value.month;

      return GestureDetector(
        onTap: isFutureDate ? null : () => controller.loadStatusesForDate(date),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDarkMode ? AppColors.white : secondary)
                : AppColors.transparent,
            border: isToday ? Border.all(color: primary, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              DateFormat('d').format(date),
              style: TextStyle(
                color: isFutureDate
                    ? (isDarkMode ? AppColors.white60 : AppColors.grey500)
                    : isSelected
                        ? (isDarkMode ? AppColors.black : AppColors.grey800)
                        : isInSelectedMonth
                            ? (isDarkMode ? AppColors.white : AppColors.grey800)
                            : (isDarkMode
                                ? AppColors.white60
                                : AppColors.grey700),
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPrayerList(PrayerTrackerController controller, bool isDarkMode) {
    return Obx(() {
      final now = DateTime.now();
      final isFutureDate = controller.selectedDate.value
          .isAfter(DateTime(now.year, now.month, now.day));

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.prayers.length,
        itemBuilder: (context, index) {
          final prayer = controller.prayers[index];
          return Obx(() {
            final status = controller.prayerStatuses[prayer];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? secondary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode ? AppColors.white38 : AppColors.grey300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? AppColors.black.withOpacity(0.1)
                        : AppColors.grey500.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prayer,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.grey800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (status != null) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.displayName,
                            style: TextStyle(
                              color: status.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: PrayerStatus.values.map((prayerStatus) {
                      return InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: isFutureDate
                            ? null
                            : () {
                                controller.updatePrayerStatus(
                                    prayer,
                                    prayerStatus == status
                                        ? null
                                        : prayerStatus);
                              },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: status == prayerStatus
                                ? prayerStatus.color
                                : (isDarkMode
                                    ? AppColors.white.withOpacity(0.1)
                                    : AppColors.grey300),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: status == prayerStatus
                                  ? prayerStatus.color
                                  : AppColors.grey300,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            prayerStatus.displayName,
                            style: TextStyle(
                              color: status == prayerStatus
                                  ? AppColors.white
                                  : (isDarkMode
                                      ? AppColors.grey500
                                      : AppColors.grey800),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          });
        },
      );
    });
  }
}
