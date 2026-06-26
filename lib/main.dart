import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'app.dart';
import 'data/services/notification_service.dart';
import 'data/services/ringer_service.dart';
import 'data/services/storage_service.dart';
import 'logic/providers/schedule_provider.dart';
import 'logic/providers/settings_provider.dart';
import 'logic/providers/timezone_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  final String localTimezone = timezoneInfo.identifier;
  tz.setLocalLocation(tz.getLocation(localTimezone));

  final storageService = StorageService();
  await storageService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final ringerService = RingerService();

  final scheduleProvider = ScheduleProvider(storageService, notificationService);
  final settingsProvider = SettingsProvider(storageService);

  // Check every minute whether we are inside a meeting window.
  Timer.periodic(const Duration(minutes: 1), (_) async {
    if (scheduleProvider.isCurrentlyInMeeting) {
      final activeSchedule = scheduleProvider.enabledSchedules.firstWhere(
        (s) {
          final now = DateTime.now();
          final currentMinutes = now.hour * 60 + now.minute;
          final start = s.startHour * 60 + s.startMinute;
          final end = s.endHour * 60 + s.endMinute;
          return s.repeatDays.contains(now.weekday) &&
              currentMinutes >= start &&
              currentMinutes < end;
        },
      );
      await ringerService.setMode(activeSchedule.mode);
    } else {
      await ringerService.restoreNormal();
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: scheduleProvider),
        ChangeNotifierProvider(create: (_) => TimezoneProvider()),
      ],
      child: const MeetingSilencerApp(),
    ),
  );
}
