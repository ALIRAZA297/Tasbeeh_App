import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // Cancel all scheduled notifications
  static Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAll();
    log("All notifications cancelled");
  }

  static Future<void> scheduleZikrReminder(DateTime dateTime) async {
    try {
      final now = DateTime.now();
      if (dateTime.isBefore(now)) {
        dateTime = dateTime.add(const Duration(days: 1));
        log("Adjusted to next day: $dateTime");
      }

      log("Scheduling Zikr reminder for: $dateTime");

      final channels =
          await AwesomeNotifications().listScheduledNotifications();
      final exists =
          channels.any((c) => c.content?.channelKey == 'zikr_channel');
      log("Channel exists: $exists");

      // Check permission
      final hasPermission =
          await AwesomeNotifications().isNotificationAllowed();
      log("Notification permission status: $hasPermission");
      if (!hasPermission) {
        log("Requesting permission...");
        await AwesomeNotifications().requestPermissionToSendNotifications();
        final permissionAfterRequest =
            await AwesomeNotifications().isNotificationAllowed();
        log("Permission after request: $permissionAfterRequest");
        if (!permissionAfterRequest) {
          log("Scheduling aborted: No notification permission granted");
          return;
        }
      }

      final result = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch % 10000,
          channelKey: 'zikr_channel',
          title: 'Zikr Reminder',
          body: 'Time for your daily Zikr 🕋',
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar.fromDate(
          date: dateTime,
          repeats: true,
          // preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );

      log(result
          ? "Notification scheduled successfully"
          : "Failed to schedule Zikr - likely a platform-specific issue");
    } catch (e, stackTrace) {
      log("Error scheduling notification: $e\nStackTrace: $stackTrace");
    }
  }

  // Schedule a prayer notification
  static Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required DateTime dateTime,
  }) async {
    try {
      if (dateTime.isBefore(DateTime.now())) {
        dateTime = dateTime.add(const Duration(days: 1));
        log("Adjusted $title prayer to next day: $dateTime");
      }

      final result = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'prayer_channel',
          title: 'Prayer Time',
          body: "It's time for $title prayer",
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: dateTime,
          repeats: false,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
      log(result
          ? "Scheduled $title prayer notification successfully"
          : "Failed to schedule $title prayer notification");
    } catch (e) {
      log("Error scheduling $title prayer notification: $e");
    }
  }
}
