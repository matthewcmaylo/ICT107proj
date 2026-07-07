import 'dart:async';
import 'data/models/meeting_schedule.dart';
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
  // TC-10 fix: ringer control needs Do Not Disturb access on Android.
  // On first launch without it, open the system settings screen so the
  // user can grant it instead of crashing later when silencing triggers.
  if (!await ringerService.hasDndAccess()) {
    await ringerService.openDndSettings();
  }

  final scheduleProvider = ScheduleProvider(storageService, notificationService);
  final settingsProvider = SettingsProvider(storageService);

  // Check every minute whether we are inside a meeting window.
  // Tracks the schedule active on the previous tick so restore only
  // happens once, at the moment a meeting ends, and only when that
  // meeting's restoreAfter toggle is on (TC-08 fix). Previously
  // restoreNormal ran every minute regardless of the toggle.
  MeetingSchedule? lastActive;
  Timer.periodic(const Duration(minutes: 1), (_) async {
    if (scheduleProvider.isCurrentlyInMeeting) {
      // Same midnight-aware check as the provider (TC-22 fix)
      final activeSchedule = scheduleProvider.enabledSchedules.firstWhere(
        (s) => s.isActiveAt(DateTime.now()),
      );
      await ringerService.setMode(activeSchedule.mode);
      lastActive = activeSchedule;
    } else {
      // Meeting just ended this tick: restore only if the toggle was on
      if (lastActive != null) {
        if (lastActive!.restoreAfter) {
          await ringerService.restoreNormal();
        }
        lastActive = null;
      }
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
