/// User preferences stored locally.
///
/// Privacy: only non-sensitive preference data is stored here.
/// No personal identifiers, no location data, no analytics.
class AppSettings {
  final String languageCode;    // 'en' or 'fr'
  final String defaultMode;     // 'silent' or 'vibrate'
  final int defaultAlertMinutes;
  final String themeMode; // 'dark', 'light', or 'system'

  const AppSettings({
    this.languageCode = 'en',
    this.defaultMode = 'silent',
    this.defaultAlertMinutes = 5,
    this.themeMode = 'dark',
  });

  AppSettings copyWith({
    String? languageCode,
    String? defaultMode,
    int? defaultAlertMinutes,
    String? themeMode,
  }) =>
      AppSettings(
        languageCode: languageCode ?? this.languageCode,
        defaultMode: defaultMode ?? this.defaultMode,
        defaultAlertMinutes: defaultAlertMinutes ?? this.defaultAlertMinutes,
        themeMode: themeMode ?? this.themeMode,
      );

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'defaultMode': defaultMode,
        'defaultAlertMinutes': defaultAlertMinutes,
        'themeMode': themeMode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        languageCode: json['languageCode'] as String? ?? 'en',
        defaultMode: json['defaultMode'] as String? ?? 'silent',
        defaultAlertMinutes: json['defaultAlertMinutes'] as int? ?? 5,
        themeMode: json['themeMode'] as String? ?? 'dark',
      );
}
