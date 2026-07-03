import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/meeting_schedule.dart';
import '../../l10n/app_localizations.dart'; // Provides translated strings for this screen
import '../../logic/providers/schedule_provider.dart';
import 'add_schedule_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve translated strings for the current locale
    final l10n = AppLocalizations.of(context);
    final schedules = context.watch<ScheduleProvider>().schedules;
    return Scaffold(
      // Translated app bar title
      appBar: AppBar(title: Text(l10n.navSchedules)),
      body: schedules.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  // Translated empty-state heading
                  Text(l10n.noSchedules, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  // Translated empty-state hint
                  Text(l10n.noSchedulesHint, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _ScheduleCard(schedule: schedules[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddScheduleScreen())),
        // Translated FAB tooltip
        tooltip: l10n.addSchedule,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final MeetingSchedule schedule;
  const _ScheduleCard({required this.schedule});

  static const _days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

  String _fmt(int hour, int minute) {
    final tod = TimeOfDay(hour: hour, minute: minute);
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = tod.minute.toString().padLeft(2, '0');
    final p = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  String get _dayString => schedule.repeatDays.map((d) => _days[d - 1]).join(', ');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final provider = context.read<ScheduleProvider>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: schedule.isEnabled ? scheme.primaryContainer : scheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                schedule.mode == 'silent' ? Icons.volume_off : Icons.vibration,
                color: schedule.isEnabled ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('${_fmt(schedule.startHour, schedule.startMinute)} – ${_fmt(schedule.endHour, schedule.endMinute)}',
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                  Text(_dayString, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                  if (schedule.restoreAfter)
                    Row(
                      children: [
                        Icon(Icons.volume_up, size: 12, color: scheme.primary),
                        const SizedBox(width: 4),
                        Text('Restores after meeting',
                            style: TextStyle(fontSize: 11, color: scheme.primary)),
                      ],
                    ),
                ],
              ),
            ),
            Switch(value: schedule.isEnabled, onChanged: (_) => provider.toggleSchedule(schedule.id)),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: scheme.error,
              onPressed: () => _confirmDelete(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, ScheduleProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete schedule?'),
        content: Text('Remove "${schedule.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) provider.deleteSchedule(schedule.id);
  }
}
