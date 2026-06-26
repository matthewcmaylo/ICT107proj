// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get appTitle => 'Meeting Silencer';

  @override
  String get navSchedules => 'Iskedyul';

  @override
  String get navWorldClock => 'World Clock';

  @override
  String get navSettings => 'Mga Setting';

  @override
  String get addSchedule => 'Magdagdag ng iskedyul';

  @override
  String get noSchedules => 'Walang iskedyul';

  @override
  String get noSchedulesHint => 'Pindutin ang + para magdagdag';

  @override
  String get modeSilent => 'Tahimik';

  @override
  String get modeVibrate => 'Vibrate';

  @override
  String get settingsLanguage => 'Wika';

  @override
  String get settingsDefaultMode => 'Default na mode';

  @override
  String get settingsAlertBefore => 'Alerto bago ang pulong';

  @override
  String minutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString minuto';
  }

  @override
  String notificationTitle(String title) {
    return 'Paparating na pulong: $title';
  }
}
