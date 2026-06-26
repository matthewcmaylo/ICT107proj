import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/constants/time_zones.dart';

/// Supplies current time and UTC offset for each city on the world clock.
class TimezoneProvider extends ChangeNotifier {
  /// Call this to refresh all clock displays (e.g. on a 1-second timer).
  void refresh() => notifyListeners();

  /// Returns the current DateTime in the given city's timezone.
  DateTime getTimeForCity(WorldCity city) {
    final location = tz.getLocation(city.timeZone);
    return tz.TZDateTime.now(location);
  }

  /// Returns a human-readable UTC offset string, e.g. "UTC+10:00".
  String getOffsetString(WorldCity city) {
    final location = tz.getLocation(city.timeZone);
    final offset = tz.TZDateTime.now(location).timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final h = offset.inHours.abs().toString().padLeft(2, '0');
    final m = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return 'UTC$sign$h:$m';
  }
}
