import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import 'app.dart';
import 'data/services/notification_service.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(storageService)),
        ChangeNotifierProvider(create: (_) => ScheduleProvider(storageService, notificationService)),
        ChangeNotifierProvider(create: (_) => TimezoneProvider()),
      ],
      child: const MeetingSilencerApp(),
    ),
  );
}
