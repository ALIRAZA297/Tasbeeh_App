import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Controller/prayer_tracker_controller.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/prayer_tracker_status.dart';

class MonthlyPrayerReportScreen extends StatelessWidget {
  final DateTime initialMonth;

  const MonthlyPrayerReportScreen({super.key, required this.initialMonth});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final PrayerTrackerController controller =
        Get.put(PrayerTrackerController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedMonth.value = initialMonth;
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Monthly Prayer Report',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            final summary =
                controller.getMonthlySummary(controller.selectedMonth.value);
            final heatmap =
                controller.getHeatmapData(controller.selectedMonth.value);
            final prayerData = controller
                .getPrayerSpecificData(controller.selectedMonth.value);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller, isDarkMode),
                const SizedBox(height: 16),
                _buildMonthlySummary(summary, context, isDarkMode),
                const SizedBox(height: 16),
                _buildHeatmap(controller, heatmap, isDarkMode),
                const SizedBox(height: 16),
                _buildPrayerSpecificPerformance(
                    controller, prayerData, context, isDarkMode),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(PrayerTrackerController controller, bool isDarkMode) {
    return Obx(() {
      final now = DateTime.now();
      final isCurrentOrFutureMonth =
          controller.selectedMonth.value.year > now.year ||
              (controller.selectedMonth.value.year == now.year &&
                  controller.selectedMonth.value.month >= now.month);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              splashColor: AppColors.transparent,
              onTap: () => controller.changeMonth(-1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: primary700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_left,
                    color: AppColors.white, size: 24),
              ),
            ),
            Text(
              DateFormat('MMMM yyyy').format(controller.selectedMonth.value),
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? AppColors.white : AppColors.grey800,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              splashColor: AppColors.transparent,
              onTap: isCurrentOrFutureMonth
                  ? null
                  : () => controller.changeMonth(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color:
                      isCurrentOrFutureMonth ? AppColors.grey300 : primary700,
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
      );
    });
  }

  Widget _buildMonthlySummary(
      Map<String, dynamic> summary, BuildContext context, bool isDarkMode) {
    final double score =
        double.tryParse(summary['consistencyScore'].toString()) ?? 0;
    final double remaining = 100 - score;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? secondary : AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Summary',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.grey800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          tooltipHorizontalAlignment:
                              FLHorizontalAlignment.center,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final value = rod.toY;
                            final label = group.x == 0
                                ? 'Consistency Score'
                                : 'Unlogged/Missed';
                            return BarTooltipItem(
                              '$label: ${value.toStringAsFixed(0)}%',
                              TextStyle(
                                color: AppColors.grey100,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              const titles = ['Score', 'Unlogged'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  titles[value.toInt()],
                                  style: TextStyle(
                                    color: AppColors.grey700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  color: AppColors.grey700,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: isDarkMode
                                ? AppColors.grey.withOpacity(0.3)
                                : AppColors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.white38
                              : AppColors.grey100,
                          width: 2,
                        ),
                      ),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: score > 0 ? score : 0.01,
                              gradient: LinearGradient(
                                colors: [primary200, primary700],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: MediaQuery.of(context).size.width * 0.35,
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.white38
                                    : AppColors.grey300,
                                width: 1,
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: remaining > 0 ? remaining : 0.01,
                              gradient: LinearGradient(
                                colors: [AppColors.lightred, AppColors.redDark],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: MediaQuery.of(context).size.width * 0.35,
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.white38
                                    : AppColors.grey300,
                                width: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Consistency Score',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey700,
                      ),
                    ),
                    Text(
                      'Unlogged/Missed',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${summary['totalExpectedPrayers'] ?? 0}',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.grey800,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Total Expected',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.grey800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${summary['loggedPrayers'] ?? 0} (${summary['loggedPercentage'] ?? 0}%)',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.grey800,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Prayers Logged',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.grey800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _listTilePrayer(
            PrayerStatus.onTime.color,
            'On Time',
            '${summary['onTime'] ?? 0}',
            '${summary['onTimePercentage'] ?? 0}%',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _listTilePrayer(
            PrayerStatus.late.color,
            'Late',
            '${summary['late'] ?? 0}',
            '${summary['latePercentage'] ?? 0}%',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _listTilePrayer(
            PrayerStatus.notPrayed.color,
            'Not Prayed',
            '${summary['notPrayed'] ?? 0}',
            '${summary['notPrayedPercentage'] ?? 0}%',
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _listTilePrayer(
    Color prayerColor,
    String prayerName,
    String ontime,
    String percentage,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.grey800 : AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: ListTile(
        leading: CircleAvatar(
          radius: 6,
          backgroundColor: prayerColor,
        ),
        title: Text(
          prayerName,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? AppColors.white70 : AppColors.grey700,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ontime,
              style: TextStyle(
                color: isDarkMode ? AppColors.white : AppColors.grey800,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              percentage,
              style: TextStyle(
                color: isDarkMode ? AppColors.white : AppColors.grey800,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap(PrayerTrackerController controller,
      Map<DateTime, double> heatmap, bool isDarkMode) {
    return Obx(() {
      final firstDay = DateTime(controller.selectedMonth.value.year,
          controller.selectedMonth.value.month, 1);
      final lastDay = DateTime(controller.selectedMonth.value.year,
          controller.selectedMonth.value.month + 1, 0);
      final firstWeekDay = firstDay.weekday;
      final totalDays = lastDay.day;
      final weeks = (totalDays + firstWeekDay - 1) ~/ 7 +
          ((totalDays + firstWeekDay - 1) % 7 > 0 ? 1 : 0);
      final days =
          List.generate(totalDays, (i) => firstDay.add(Duration(days: i)));

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? secondary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Overview',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: weeks * 7,
              itemBuilder: (context, index) {
                final dayIndex = index - (firstWeekDay - 1);
                if (dayIndex < 0 || dayIndex >= totalDays) {
                  return Container();
                }
                final date = days[dayIndex];
                final score = heatmap[date] ?? 0.0;
                return Container(
                  decoration: BoxDecoration(
                    color: score > 0.7
                        ? PrayerStatus.onTime.color
                        : score > 0.3
                            ? PrayerStatus.late.color
                            : PrayerStatus.notPrayed.color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color:
                            isDarkMode ? AppColors.white38 : AppColors.grey300),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 12,
                        color: score > 0.5
                            ? (isDarkMode ? AppColors.white : AppColors.grey800)
                            : (isDarkMode
                                ? AppColors.white70
                                : AppColors.grey700),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPrayerSpecificPerformance(
      PrayerTrackerController controller,
      Map<String, Map<String, int>> prayerData,
      BuildContext context,
      bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? secondary : AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prayer Performance',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.grey800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...prayerData.entries.map((entry) => _buildPrayerCard(
              controller, entry.key, entry.value, context, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(PrayerTrackerController controller, String prayer,
      Map<String, int> data, BuildContext context, bool isDarkMode) {
    final int onTime = data['On Time'] ?? 0;
    final int late = data['Late'] ?? 0;
    final int missed = data['Not Prayed'] ?? 0;
    final int total = onTime + late + missed;

    int percent(double value) =>
        total == 0 ? 0 : (value / total * 100).round().clamp(0, 100).toInt();

    final String label = controller.prayerLabels[prayer] ?? prayer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.grey800 : AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  prayer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? AppColors.white : AppColors.grey800,
                  ),
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? AppColors.white70 : AppColors.grey700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                  onTime, "On Time", PrayerStatus.onTime.color, isDarkMode),
              _buildStatItem(late, "Late", PrayerStatus.late.color, isDarkMode),
              _buildStatItem(
                  missed, "Missed", PrayerStatus.notPrayed.color, isDarkMode),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: percent(onTime.toDouble()),
                  child: Container(height: 8, color: PrayerStatus.onTime.color),
                ),
                Expanded(
                  flex: percent(late.toDouble()),
                  child: Container(height: 8, color: PrayerStatus.late.color),
                ),
                Expanded(
                  flex: percent(missed.toDouble()),
                  child:
                      Container(height: 8, color: PrayerStatus.notPrayed.color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(int count, String label, Color color, bool isDarkMode) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? AppColors.white70 : AppColors.grey700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
