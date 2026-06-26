import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Meeting Silencer';
  static const String storageKeySettings = 'app_settings';
  static const String storageKeySchedules = 'meeting_schedules';

  static const String channelIdAlerts = 'meeting_alerts';
  static const String channelNameAlerts = 'Meeting Alerts';
  static const String channelIdRestore = 'meeting_restore';
  static const String channelNameRestore = 'Meeting Ended';

  static const int defaultAlertMinutes = 5;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ne'),
    Locale('hi'),
    Locale('tl'),
    Locale('zh'),
    Locale('ar'),
  ];
}
