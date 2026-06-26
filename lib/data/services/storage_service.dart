import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/meeting_schedule.dart';
import '../../core/constants/app_constants.dart';

/// Handles all local JSON storage.
///
/// Security: SharedPreferences is sandboxed to this app only.
/// No data leaves the device — no network calls are made here.
class StorageService {
  late SharedPreferences _prefs;

  /// Must be called once before any read/write operations.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── App Settings ──────────────────────────────────────────────────────────

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(
      AppConstants.storageKeySettings,
      jsonEncode(settings.toJson()),
    );
  }

  AppSettings loadSettings() {
    final raw = _prefs.getString(AppConstants.storageKeySettings);
    if (raw == null) return const AppSettings();
    return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  // ── Meeting Schedules ─────────────────────────────────────────────────────

  Future<void> saveSchedules(List<MeetingSchedule> schedules) async {
    final encoded = jsonEncode(schedules.map((s) => s.toJson()).toList());
    await _prefs.setString(AppConstants.storageKeySchedules, encoded);
  }

  List<MeetingSchedule> loadSchedules() {
    final raw = _prefs.getString(AppConstants.storageKeySchedules);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => MeetingSchedule.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
