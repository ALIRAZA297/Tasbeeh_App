import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../Utils/prayer_tracker_status.dart';

class PrayerTrackerController extends GetxController {
  final GetStorage _storage = GetStorage();

  // Observable variables
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> selectedMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  final RxMap<String, PrayerStatus?> prayerStatuses =
      <String, PrayerStatus?>{}.obs;

  // Static data
  final List<String> prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  final Map<String, String> prayerLabels = {
    'Fajr': 'Dawn Prayer',
    'Dhuhr': 'Midday Prayer',
    'Asr': 'Afternoon Prayer',
    'Maghrib': 'Sunset Prayer',
    'Isha': 'Night Prayer',
  };

  @override
  void onInit() {
    super.onInit();
    loadStatusesForDate(DateTime.now());
  }

  // void loadStatusesForDate(DateTime date) {
  //   selectedDate.value = date;
  //   selectedMonth.value = DateTime(date.year, date.month, 1);
  //   prayerStatuses.clear();

  //   for (var prayer in prayers) {
  //     String key = '${DateFormat('yyyy-MM-dd').format(date)}_$prayer';
  //     String? status = _storage.read(key);
  //     prayerStatuses[prayer] = status != null
  //         ? PrayerStatus.values.firstWhere(
  //             (e) => e.toString() == status,
  //             orElse: () => PrayerStatus.notPrayed,
  //           )
  //         : null;
  //   }
  // }
  void loadStatusesForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    selectedDate.value = normalized;
    selectedMonth.value = DateTime(normalized.year, normalized.month, 1);
    prayerStatuses.clear();

    for (var prayer in prayers) {
      String key = '${DateFormat('yyyy-MM-dd').format(normalized)}_$prayer';
      String? status = _storage.read(key);
      prayerStatuses[prayer] = status != null
          ? PrayerStatus.values.firstWhere(
              (e) => e.toString() == status,
              orElse: () => PrayerStatus.notPrayed,
            )
          : null;
    }
  }

  void updatePrayerStatus(String prayer, PrayerStatus? status) {
    String key =
        '${DateFormat('yyyy-MM-dd').format(selectedDate.value)}_$prayer';
    if (status == null) {
      _storage.remove(key);
    } else {
      _storage.write(key, status.toString());
    }
    prayerStatuses[prayer] = status;
  }

  // void changeMonth(int increment) {
  //   selectedMonth.value = DateTime(
  //       selectedMonth.value.year, selectedMonth.value.month + increment, 1);
  //   selectedDate.value = DateTime(
  //       selectedMonth.value.year,
  //       selectedMonth.value.month,
  //       selectedDate.value.day > 28 ? 1 : selectedDate.value.day);
  //   loadStatusesForDate(selectedDate.value);
  // }

  void changeMonth(int increment) {
    selectedMonth.value = DateTime(
        selectedMonth.value.year, selectedMonth.value.month + increment, 1);

    // Reset selectedDate to the 1st of the new month (instead of keeping old day number)
    selectedDate.value = selectedMonth.value;

    loadStatusesForDate(selectedDate.value);
  }

  Map<String, int> getMonthlyReport(DateTime month) {
    final report = {
      'Not Selected': 0,
      'Not Prayed': 0,
      'Late': 0,
      'On Time': 0,
      'In Jamaah': 0,
    };
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    for (var day = firstDay;
        day.isBefore(lastDay.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      for (var prayer in prayers) {
        String key = '${DateFormat('yyyy-MM-dd').format(day)}_$prayer';
        String? status = _storage.read(key);
        if (status != null) {
          final prayerStatus = PrayerStatus.values.firstWhere(
            (e) => e.toString() == status,
            orElse: () => PrayerStatus.notPrayed,
          );
          report[prayerStatus.displayName] =
              (report[prayerStatus.displayName] ?? 0) + 1;
        } else {
          report['Not Selected'] = (report['Not Selected'] ?? 0) + 1;
        }
      }
    }
    return report;
  }

  Map<String, dynamic> getMonthlySummary(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final totalDays = lastDay.day;
    final totalExpectedPrayers = totalDays * prayers.length;
    final report = getMonthlyReport(month);
    final loggedPrayers = totalExpectedPrayers - (report['Not Selected'] ?? 0);
    final loggedPercentage = totalExpectedPrayers > 0
        ? (loggedPrayers / totalExpectedPrayers * 100).round()
        : 0;
    final consistencyScore = totalExpectedPrayers > 0
        ? (((report['On Time'] ?? 0) + (report['In Jamaah'] ?? 0)) /
                totalExpectedPrayers *
                100)
            .round()
        : 0;

    return {
      'totalExpectedPrayers': totalExpectedPrayers,
      'loggedPrayers': loggedPrayers,
      'loggedPercentage': loggedPercentage,
      'onTime': report['On Time'] ?? 0,
      'onTimePercentage': totalExpectedPrayers > 0
          ? ((report['On Time'] ?? 0) / totalExpectedPrayers * 100).round()
          : 0,
      'late': report['Late'] ?? 0,
      'latePercentage': totalExpectedPrayers > 0
          ? ((report['Late'] ?? 0) / totalExpectedPrayers * 100).round()
          : 0,
      'notPrayed': report['Not Prayed'] ?? 0,
      'notPrayedPercentage': totalExpectedPrayers > 0
          ? ((report['Not Prayed'] ?? 0) / totalExpectedPrayers * 100).round()
          : 0,
      'inJamaah': report['In Jamaah'] ?? 0,
      'inJamaahPercentage': totalExpectedPrayers > 0
          ? ((report['In Jamaah'] ?? 0) / totalExpectedPrayers * 100).round()
          : 0,
      'consistencyScore': consistencyScore,
    };
  }

  Map<DateTime, double> getHeatmapData(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final heatmap = <DateTime, double>{};

    for (var day = firstDay;
        day.isBefore(lastDay.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      int positiveCount = 0;
      for (var prayer in prayers) {
        String key = '${DateFormat('yyyy-MM-dd').format(day)}_$prayer';
        String? status = _storage.read(key);
        if (status != null) {
          final prayerStatus = PrayerStatus.values.firstWhere(
            (e) => e.toString() == status,
            orElse: () => PrayerStatus.notPrayed,
          );
          if (prayerStatus == PrayerStatus.onTime) {
            positiveCount++;
          }
        }
      }
      heatmap[day] =
          positiveCount / prayers.length; // 0.0 to 1.0 based on On Time prayers
    }
    return heatmap;
  }

  Map<String, Map<String, int>> getPrayerSpecificData(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final prayerData = <String, Map<String, int>>{
      for (var prayer in prayers)
        prayer: {'On Time': 0, 'Late': 0, 'Not Prayed': 0, 'Not Selected': 0},
    };

    for (var day = firstDay;
        day.isBefore(lastDay.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      for (var prayer in prayers) {
        String key = '${DateFormat('yyyy-MM-dd').format(day)}_$prayer';
        String? status = _storage.read(key);
        if (status != null) {
          final prayerStatus = PrayerStatus.values.firstWhere(
            (e) => e.toString() == status,
            orElse: () => PrayerStatus.notPrayed,
          );
          prayerData[prayer]![prayerStatus.displayName] =
              (prayerData[prayer]![prayerStatus.displayName] ?? 0) + 1;
        } else {
          prayerData[prayer]!['Not Selected'] =
              (prayerData[prayer]!['Not Selected'] ?? 0) + 1;
        }
      }
    }
    return prayerData;
  }
}
