// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'बैठक साइलेन्सर';

  @override
  String get navSchedules => 'तालिका';

  @override
  String get navWorldClock => 'विश्व घडी';

  @override
  String get navSettings => 'सेटिङ';

  @override
  String get addSchedule => 'तालिका थप्नुहोस्';

  @override
  String get noSchedules => 'कुनै तालिका छैन';

  @override
  String get noSchedulesHint => '+ थिचेर पहिलो तालिका थप्नुहोस्';

  @override
  String get modeSilent => 'मौन';

  @override
  String get modeVibrate => 'कम्पन';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsDefaultMode => 'पूर्वनिर्धारित मोड';

  @override
  String get settingsAlertBefore => 'बैठक अघि सूचना';

  @override
  String minutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString मिनेट';
  }

  @override
  String notificationTitle(String title) {
    return 'आगामी बैठक: $title';
  }
}
