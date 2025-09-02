import 'package:flutter/material.dart';

import 'app_colors.dart';

enum PrayerStatus {
  notPrayed,
  late,
  onTime,
  // inJamaah,
}

extension PrayerStatusExtension on PrayerStatus? {
  String get displayName {
    switch (this) {
      case PrayerStatus.notPrayed:
        return 'Not Prayed';
      case PrayerStatus.late:
        return 'Late';
      case PrayerStatus.onTime:
        return 'On Time';
      // case PrayerStatus.inJamaah:
      //   return 'In Jamaah';
      case null:
        return 'Not Selected';
    }
  }

  Color get color {
    switch (this) {
      case PrayerStatus.notPrayed:
        return AppColors.red;
      case PrayerStatus.late:
        return AppColors.orange;
      case PrayerStatus.onTime:
        return primary;
      // case PrayerStatus.inJamaah:
      //   return Colors.blue;
      case null:
        return AppColors.grey;
    }
  }
}
