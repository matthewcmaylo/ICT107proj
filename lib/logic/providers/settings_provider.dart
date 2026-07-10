import 'package:flutter/material.dart';

import '../../data/models/app_settings.dart';
import '../../data/services/storage_service.dart';

/// Manages user preferences and exposes them to the widget tree.
class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;
  late AppSettings _settings;

  SettingsProvider(this._storage) {
    _settings = _storage.loadSettings();
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  AppSettings get settings => _settings;

  /// Locale used by MaterialApp to switch the UI language.
  Locale get locale => Locale(_settings.languageCode);

  String get languageCode => _settings.languageCode;
  String get defaultMode => _settings.defaultMode;
  int get defaultAlertMinutes => _settings.defaultAlertMinutes;
  String get themeMode => _settings.themeMode;

  /// Returns the Flutter ThemeMode based on the stored preference.
  ThemeMode get flutterThemeMode {
    switch (_settings.themeMode) {
      case 'light': return ThemeMode.light;
      case 'system': return ThemeMode.system;
      default: return ThemeMode.dark;
    }
  }

  // ── Setters ───────────────────────────────────────────────────────────────

  Future<void> setLanguage(String code) async {
    _settings = _settings.copyWith(languageCode: code);
    await _save();
    notifyListeners();
  }

  Future<void> setDefaultMode(String mode) async {
    _settings = _settings.copyWith(defaultMode: mode);
    await _save();
    notifyListeners();
  }

  Future<void> setDefaultAlertMinutes(int minutes) async {
    _settings = _settings.copyWith(defaultAlertMinutes: minutes);
    await _save();
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _save();
    notifyListeners();
  }

  Future<void> _save() => _storage.saveSettings(_settings);
}
