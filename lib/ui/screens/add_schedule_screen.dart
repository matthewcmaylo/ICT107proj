import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/meeting_schedule.dart';
import '../../logic/providers/schedule_provider.dart';
import '../../logic/providers/settings_provider.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _titleController = TextEditingController();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  final Set<int> _selectedDays = {1, 2, 3, 4, 5};
  String _mode = 'silent';
  int _alertMinutes = 5;
  bool _restoreAfter = true;
  bool _saving = false;

  static const List<String> _dayLabels = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _mode = settings.defaultMode;
    _alertMinutes = settings.defaultAlertMinutes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startTime = picked;
        final startMins = picked.hour * 60 + picked.minute;
        final endMins = _endTime.hour * 60 + _endTime.minute;
        if (endMins <= startMins) {
          final newEnd = startMins + 60;
          _endTime = TimeOfDay(hour: (newEnd ~/ 60) % 24, minute: newEnd % 60);
        }
      } else {
        _endTime = picked;
      }
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a meeting title')),
      );
      return;
    }
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }
    setState(() => _saving = true);
    final schedule = MeetingSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      startHour: _startTime.hour, startMinute: _startTime.minute,
      endHour: _endTime.hour, endMinute: _endTime.minute,
      repeatDays: _selectedDays.toList()..sort(),
      mode: _mode, isEnabled: true,
      alertMinutesBefore: _alertMinutes,
      restoreAfter: _restoreAfter,
    );
    await context.read<ScheduleProvider>().addSchedule(schedule);
    if (mounted) Navigator.of(context).pop();
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Title
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Meeting title',
              hintText: 'e.g. Daily Stand-up',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),

          // Time
          Text('Time', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _TimeTile(label: 'Start', time: _formatTime(_startTime), onTap: () => _pickTime(true))),
              const SizedBox(width: 12),
              Expanded(child: _TimeTile(label: 'End', time: _formatTime(_endTime), onTap: () => _pickTime(false))),
            ],
          ),
          const SizedBox(height: 24),

          // Days
          Text('Repeat on', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final day = i + 1;
              final selected = _selectedDays.contains(day);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) { _selectedDays.remove(day); } else { _selectedDays.add(day); }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: selected ? scheme.primary : scheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(_dayLabels[i],
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant)),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Mode
          Text('Device mode during meeting', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'silent', label: Text('Silent'), icon: Icon(Icons.volume_off)),
              ButtonSegment(value: 'vibrate', label: Text('Vibrate'), icon: Icon(Icons.vibration)),
            ],
            selected: {_mode},
            onSelectionChanged: (val) => setState(() => _mode = val.first),
          ),
          const SizedBox(height: 24),

          // Alert timing
          Text('Alert before meeting', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [5, 10, 15, 30].map((mins) => ChoiceChip(
              label: Text('$mins min'),
              selected: _alertMinutes == mins,
              onSelected: (_) => setState(() => _alertMinutes = mins),
            )).toList(),
          ),
          const SizedBox(height: 24),

          // Restore after meeting
          Text('After meeting ends', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              value: _restoreAfter,
              onChanged: (val) => setState(() => _restoreAfter = val),
              title: const Text('Restore normal mode'),
              subtitle: const Text('Send a reminder when the meeting ends so you can turn sound back on'),
              secondary: Icon(
                _restoreAfter ? Icons.volume_up : Icons.volume_off,
                color: _restoreAfter ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;
  const _TimeTile({required this.label, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(color: scheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
