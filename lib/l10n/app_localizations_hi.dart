// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मीटिंग साइलेंसर';

  @override
  String get navSchedules => 'अनुसूची';

  @override
  String get navWorldClock => 'विश्व घड़ी';

  @override
  String get navSettings => 'सेटिंग';

  @override
  String get addSchedule => 'अनुसूची जोड़ें';

  @override
  String get noSchedules => 'कोई अनुसूची नहीं';

  @override
  String get noSchedulesHint => '+ दबाएं और पहली अनुसूची जोड़ें';

  @override
  String get modeSilent => 'मौन';

  @override
  String get modeVibrate => 'कंपन';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsDefaultMode => 'डिफ़ॉल्ट मोड';

  @override
  String get settingsAlertBefore => 'मीटिंग से पहले अलर्ट';

  @override
  String minutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString मिनट';
  }

  @override
  String notificationTitle(String title) {
    return 'आगामी मीटिंग: $title';
  }
}
