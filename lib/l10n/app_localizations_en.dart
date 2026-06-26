// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Meeting Silencer';

  @override
  String get navSchedules => 'Schedules';

  @override
  String get navWorldClock => 'World Clock';

  @override
  String get navSettings => 'Settings';

  @override
  String get addSchedule => 'Add schedule';

  @override
  String get noSchedules => 'No schedules yet';

  @override
  String get noSchedulesHint => 'Tap + to add your first meeting schedule';

  @override
  String get modeSilent => 'Silent';

  @override
  String get modeVibrate => 'Vibrate';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsDefaultMode => 'Default mode';

  @override
  String get settingsAlertBefore => 'Alert before meeting';

  @override
  String minutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString minutes',
      one: '$countString minute',
    );
    return '$_temp0';
  }

  @override
  String notificationTitle(String title) {
    return 'Upcoming meeting: $title';
  }
}
