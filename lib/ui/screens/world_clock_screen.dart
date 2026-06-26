import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/time_zones.dart';
import '../../logic/providers/timezone_provider.dart';

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({super.key});

  @override
  State<WorldClockScreen> createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      context.read<TimezoneProvider>().refresh();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<TimezoneProvider>();
    final provider = context.read<TimezoneProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('World Clock')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: TimeZoneConstants.majorCities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final city = TimeZoneConstants.majorCities[index];
          final time = provider.getTimeForCity(city);
          final offset = provider.getOffsetString(city);
          return _ClockCard(city: city, time: time, offset: offset);
        },
      ),
    );
  }
}

class _ClockCard extends StatelessWidget {
  final WorldCity city;
  final DateTime time;
  final String offset;

  const _ClockCard({required this.city, required this.time, required this.offset});

  bool get _isNight => time.hour < 6 || time.hour >= 20;
  bool get _isWorkHours => time.hour >= 9 && time.hour < 17;

  String get _timeString {
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$h:$m:$s $period';
  }

  String get _dateString {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${weekdays[time.weekday - 1]}, ${months[time.month - 1]} ${time.day}';
  }

  Color _bgColor(ColorScheme scheme) {
    if (_isNight) return scheme.surfaceVariant.withOpacity(0.5);
    if (_isWorkHours) return scheme.primaryContainer.withOpacity(0.3);
    return scheme.surface;
  }

  IconData get _timeIcon {
    if (_isNight) return Icons.nightlight_round;
    if (_isWorkHours) return Icons.wb_sunny;
    return Icons.wb_twilight;
  }

  Color _iconColor(ColorScheme scheme) {
    if (_isNight) return Colors.indigo.shade300;
    if (_isWorkHours) return Colors.amber.shade600;
    return Colors.orange.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: _bgColor(scheme),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(_timeIcon, color: _iconColor(scheme), size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(city.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('${city.countryCode} · $offset', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                  Text(_dateString, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Text(
              _timeString,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ],
        ),
      ),
    );
  }
}
