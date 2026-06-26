// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كاتم صوت الاجتماعات';

  @override
  String get navSchedules => 'الجداول';

  @override
  String get navWorldClock => 'الساعة العالمية';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get addSchedule => 'إضافة جدول';

  @override
  String get noSchedules => 'لا توجد جداول';

  @override
  String get noSchedulesHint => 'اضغط + لإضافة أول جدول';

  @override
  String get modeSilent => 'صامت';

  @override
  String get modeVibrate => 'اهتزاز';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsDefaultMode => 'الوضع الافتراضي';

  @override
  String get settingsAlertBefore => 'تنبيه قبل الاجتماع';

  @override
  String minutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString دقيقة';
  }

  @override
  String notificationTitle(String title) {
    return 'اجتماع قادم: $title';
  }
}
