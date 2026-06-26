// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Silencieux de Réunion';

  @override
  String get navSchedules => 'Horaires';

  @override
  String get navWorldClock => 'Horloge Mondiale';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get addSchedule => 'Ajouter un horaire';

  @override
  String get noSchedules => 'Aucun horaire';

  @override
  String get noSchedulesHint =>
      'Appuyez sur + pour ajouter votre premier horaire';

  @override
  String get modeSilent => 'Silencieux';

  @override
  String get modeVibrate => 'Vibreur';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsDefaultMode => 'Mode par défaut';

  @override
  String get settingsAlertBefore => 'Alerte avant la réunion';

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
    return 'Réunion à venir : $title';
  }
}
