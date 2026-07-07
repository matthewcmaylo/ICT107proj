import 'package:flutter/material.dart';

import '../../data/models/meeting_schedule.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/storage_service.dart';

/// Manages the list of meeting schedules.
///
/// Any change (add, update, delete, toggle) is immediately persisted to
/// local storage and notification scheduling is updated accordingly.
class ScheduleProvider extends ChangeNotifier {
  final StorageService _storage;
  final NotificationService _notifications;

  late List<MeetingSchedule> _schedules;

  ScheduleProvider(this._storage, this._notifications) {
    _schedules = _storage.loadSchedules();
  }

  List<MeetingSchedule> get schedules => List.unmodifiable(_schedules);

  List<MeetingSchedule> get enabledSchedules =>
      _schedules.where((s) => s.isEnabled).toList();

  // ── CRUD ──────────────────────────────────────────────────────────────────

  /// Returns true when another schedule already has the same title,
  /// times, and repeat days. Used to block duplicates (TC-14 fix).
  bool isDuplicate(MeetingSchedule schedule) {
    return _schedules.any((s) =>
        s.id != schedule.id &&
        s.title == schedule.title &&
        s.startHour == schedule.startHour &&
        s.startMinute == schedule.startMinute &&
        s.endHour == schedule.endHour &&
        s.endMinute == schedule.endMinute &&
        s.repeatDays.join(',') == schedule.repeatDays.join(','));
  }

  Future<void> addSchedule(MeetingSchedule schedule) async {
    // TC-14 fix: identical schedules each fired their own notification.
    // Silently ignore an exact duplicate instead of adding it.
    if (isDuplicate(schedule)) return;
    _schedules.add(schedule);
    await _persist();
    await _notifications.scheduleAlertNotification(schedule);
    notifyListeners();
  }

  Future<void> updateSchedule(MeetingSchedule updated) async {
    final index = _schedules.indexWhere((s) => s.id == updated.id);
    if (index == -1) return;
    _schedules[index] = updated;
    await _persist();
    await _notifications.scheduleAlertNotification(updated);
    notifyListeners();
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((s) => s.id == id);
    await _persist();
    await _notifications.cancelScheduleNotifications(id);
    notifyListeners();
  }

  Future<void> toggleSchedule(String id) async {
    final index = _schedules.indexWhere((s) => s.id == id);
    if (index == -1) return;
    _schedules[index] =
        _schedules[index].copyWith(isEnabled: !_schedules[index].isEnabled);
    await _persist();
    await _notifications.scheduleAlertNotification(_schedules[index]);
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Checks whether the device is currently inside any enabled schedule.
  bool get isCurrentlyInMeeting {
    // Delegates to MeetingSchedule.isActiveAt, which handles
    // midnight-spanning windows correctly (TC-22 fix)
    final now = DateTime.now();
    return enabledSchedules.any((s) => s.isActiveAt(now));
  }

  Future<void> _persist() => _storage.saveSchedules(_schedules);
}
