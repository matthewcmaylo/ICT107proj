import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/meeting_schedule.dart';
import '../../l10n/app_localizations.dart'; // Provides translated strings for this screen
import '../../logic/providers/schedule_provider.dart';
import '../../logic/providers/settings_provider.dart';

class AddScheduleScreen extends StatefulWidget {
  // When editing, the existing schedule is passed in; null means add mode
  final MeetingSchedule? existing;
  const AddScheduleScreen({super.key, this.existing});

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
    // Edit mode: prefill every field from the schedule being edited
    final e = widget.existing;
    if (e != null) {
      _titleController.text = e.title;
      _startTime = TimeOfDay(hour: e.startHour, minute: e.startMinute);
      _endTime = TimeOfDay(hour: e.endHour, minute: e.endMinute);
      _selectedDays..clear()..addAll(e.repeatDays);
      _mode = e.mode;
      _alertMinutes = e.alertMinutesBefore;
      _restoreAfter = e.restoreAfter;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }


  /// Fills the form with a preset template's values.
  void _applyTemplate(String title, int sh, int sm, int eh, int em, Set<int> days, String mode) {
    setState(() {
      _titleController.text = title;
      _startTime = TimeOfDay(hour: sh, minute: sm);
      _endTime = TimeOfDay(hour: eh, minute: em);
      _selectedDays..clear()..addAll(days);
      _mode = mode;
    });
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
      // Reuse the original id when editing so the schedule is updated, not duplicated
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      startHour: _startTime.hour, startMinute: _startTime.minute,
      endHour: _endTime.hour, endMinute: _endTime.minute,
      repeatDays: _selectedDays.toList()..sort(),
      mode: _mode, isEnabled: true,
      alertMinutesBefore: _alertMinutes,
      restoreAfter: _restoreAfter,
    );
    final provider = context.read<ScheduleProvider>();
    // Block exact duplicates so only one notification fires per meeting (TC-14)
    if (widget.existing == null && provider.isDuplicate(schedule)) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This schedule already exists')),
      );
      return;
    }
    // Update the existing schedule in edit mode, otherwise add a new one
    if (widget.existing != null) {
      await provider.updateSchedule(schedule);
    } else {
      await provider.addSchedule(schedule);
    }
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
    // Retrieve translated strings for the current locale
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        // Translated app bar title
        title: Text(l10n.addSchedule),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            // 'Save' has no l10n key — kept in English
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Schedule templates for quick setup
          if (widget.existing == null) ...[
            Text('TEMPLATES', style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600,
              letterSpacing: 0.8, color: scheme.primary)),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _TemplateChip(
                    label: '9-5 Work',
                    onTap: () => _applyTemplate('Work Hours', 9, 0, 17, 0, {1,2,3,4,5}, 'silent'),
                  ),
                  const SizedBox(width: 8),
                  _TemplateChip(
                    label: '1hr Lecture',
                    onTap: () => _applyTemplate('Lecture', 9, 0, 10, 0, {1,2,3,4,5}, 'silent'),
                  ),
                  const SizedBox(width: 8),
                  _TemplateChip(
                    label: '2hr Lecture',
                    onTap: () => _applyTemplate('Lecture', 9, 0, 11, 0, {1,2,3,4,5}, 'silent'),
                  ),
                  const SizedBox(width: 8),
                  _TemplateChip(
                    label: '30min Standup',
                    onTap: () => _applyTemplate('Standup', 9, 0, 9, 30, {1,2,3,4,5}, 'vibrate'),
                  ),
                  const SizedBox(width: 8),
                  _TemplateChip(
                    label: 'Evening Class',
                    onTap: () => _applyTemplate('Evening Class', 18, 0, 21, 0, {1,3}, 'silent'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],


          // Title field — label/hint have no l10n keys, kept in English
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

          // Time section — 'Time', 'Start', 'End' have no l10n keys, kept in English
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

          // Days section — day abbreviations have no l10n keys, kept in English
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

          // Mode section — 'Device mode during meeting' has no l10n key, kept in English
          Text('Device mode during meeting', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              // Translated mode labels
              ButtonSegment(value: 'silent', label: Text(l10n.modeSilent), icon: const Icon(Icons.volume_off)),
              ButtonSegment(value: 'vibrate', label: Text(l10n.modeVibrate), icon: const Icon(Icons.vibration)),
            ],
            selected: {_mode},
            onSelectionChanged: (val) => setState(() => _mode = val.first),
          ),
          const SizedBox(height: 24),

          // Alert timing — translated section header
          Text(l10n.settingsAlertBefore, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [5, 10, 15, 30].map((mins) => ChoiceChip(
              // Translated minute label (handles singular/plural per locale)
              label: Text(l10n.minutes(mins)),
              selected: _alertMinutes == mins,
              onSelected: (_) => setState(() => _alertMinutes = mins),
            )).toList(),
          ),
          const SizedBox(height: 24),

          // Restore section — 'After meeting ends', toggle labels have no l10n keys, kept in English
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

/// Styled chip used in the template picker row on the add schedule screen.
class _TemplateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TemplateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w500, color: scheme.primary)),
      ),
    );
  }
}
