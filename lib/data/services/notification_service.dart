import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/meeting_schedule.dart';
import '../../core/constants/app_constants.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );
    await _plugin.initialize(const InitializationSettings(
      android: androidSettings, iOS: iosSettings,
    ));
  }

  Future<void> scheduleAlertNotification(MeetingSchedule schedule) async {
    await cancelScheduleNotifications(schedule.id);
    if (!schedule.isEnabled || schedule.repeatDays.isEmpty) return;

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < schedule.repeatDays.length; i++) {
      final weekday = schedule.repeatDays[i];

      // Pre-meeting alert.
      // TC-13 fix: if the alert time (start minus alertMinutesBefore) has
      // already passed but the meeting start is still ahead, the old logic
      // pushed the alert a full week out and nothing fired today. In that
      // case schedule the alert for one minute from now instead.
      var alertTime = _nextWeekdayInstance(
        weekday: weekday,
        hour: schedule.startHour, minute: schedule.startMinute,
        subtractMinutes: schedule.alertMinutesBefore, from: now,
      );
      final startToday = tz.TZDateTime(
        tz.local, now.year, now.month, now.day,
        schedule.startHour, schedule.startMinute,
      );
      if (startToday.weekday == weekday &&
          startToday.isAfter(now) &&
          alertTime.difference(now).inDays >= 1) {
        // Alert window already passed today but the meeting has not started.
        // Schedule 5 seconds from now so iOS shows it as a banner rather
        // than suppressing it as a foreground notification (TC-13 iOS fix).
        alertTime = tz.TZDateTime.from(
          DateTime.now().add(const Duration(seconds: 5)), tz.local,
        );
      }
      await _plugin.zonedSchedule(
        _notificationId(schedule.id, i, 0),
        'Upcoming meeting: ${schedule.title}',
        'Starts in ${schedule.alertMinutesBefore} min — switching to ${schedule.mode} mode.',
        alertTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.channelIdAlerts, AppConstants.channelNameAlerts,
            channelDescription: 'Alerts before meetings.',
            importance: Importance.high, priority: Priority.high, playSound: false,
          ),
          iOS: const DarwinNotificationDetails(presentSound: false),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

      // Post-meeting restore notification (if enabled)
      if (schedule.restoreAfter) {
        final endTime = _nextWeekdayInstance(
          weekday: weekday,
          hour: schedule.endHour, minute: schedule.endMinute,
          subtractMinutes: 0, from: now,
        );
        await _plugin.zonedSchedule(
          _notificationId(schedule.id, i, 1),
          'Meeting ended: ${schedule.title}',
          'Your meeting has ended. You can restore your normal sound mode.',
          endTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              AppConstants.channelIdRestore, AppConstants.channelNameRestore,
              channelDescription: 'Reminder to restore sound after meetings.',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority, playSound: false,
            ),
            iOS: const DarwinNotificationDetails(presentSound: false),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  Future<void> cancelScheduleNotifications(String scheduleId) async {
    for (int i = 0; i < 7; i++) {
      await _plugin.cancel(_notificationId(scheduleId, i, 0));
      await _plugin.cancel(_notificationId(scheduleId, i, 1));
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  int _notificationId(String scheduleId, int dayIndex, int type) {
    // type 0 = pre-meeting alert, type 1 = post-meeting restore
    return (scheduleId.hashCode.abs() % 100000) * 14 + dayIndex * 2 + type;
  }

  tz.TZDateTime _nextWeekdayInstance({
    required int weekday, required int hour, required int minute,
    required int subtractMinutes, required tz.TZDateTime from,
  }) {
    tz.TZDateTime candidate = tz.TZDateTime(
      tz.local, from.year, from.month, from.day, hour, minute,
    ).subtract(Duration(minutes: subtractMinutes));
    while (candidate.weekday != weekday || candidate.isBefore(from)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }
}
