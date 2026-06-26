/// A city displayed on the world clock screen.
class WorldCity {
  final String name;
  final String timeZone; // IANA timezone identifier
  final String countryCode;

  const WorldCity({
    required this.name,
    required this.timeZone,
    required this.countryCode,
  });
}

class TimeZoneConstants {
  TimeZoneConstants._();

  static const List<WorldCity> majorCities = [
    WorldCity(name: 'Los Angeles', timeZone: 'America/Los_Angeles', countryCode: 'US'),
    WorldCity(name: 'New York',    timeZone: 'America/New_York',    countryCode: 'US'),
    WorldCity(name: 'São Paulo',   timeZone: 'America/Sao_Paulo',   countryCode: 'BR'),
    WorldCity(name: 'London',      timeZone: 'Europe/London',       countryCode: 'GB'),
    WorldCity(name: 'Paris',       timeZone: 'Europe/Paris',        countryCode: 'FR'),
    WorldCity(name: 'Dubai',       timeZone: 'Asia/Dubai',          countryCode: 'AE'),
    WorldCity(name: 'Mumbai',      timeZone: 'Asia/Kolkata',        countryCode: 'IN'),
    WorldCity(name: 'Singapore',   timeZone: 'Asia/Singapore',      countryCode: 'SG'),
    WorldCity(name: 'Tokyo',       timeZone: 'Asia/Tokyo',          countryCode: 'JP'),
    WorldCity(name: 'Sydney',      timeZone: 'Australia/Sydney',    countryCode: 'AU'),
  ];
}
