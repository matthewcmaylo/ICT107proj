// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '会议静音器';

  @override
  String get navSchedules => '日程';

  @override
  String get navWorldClock => '世界时钟';

  @override
  String get navSettings => '设置';

  @override
  String get addSchedule => '添加日程';

  @override
  String get noSchedules => '暂无日程';

  @override
  String get noSchedulesHint => '点击 + 添加第一个会议日程';

  @override
  String get modeSilent => '静音';

  @override
  String get modeVibrate => '振动';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsDefaultMode => '默认模式';

  @override
  String get settingsAlertBefore => '会议前提醒';

  @override
  String minutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString 分钟';
  }

  @override
  String notificationTitle(String title) {
    return '即将开始的会议：$title';
  }
}
