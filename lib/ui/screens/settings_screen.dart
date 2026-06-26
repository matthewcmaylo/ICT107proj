import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _languages = [
    {'code': 'en', 'label': 'English',  'native': 'English',    'flag': '🇬🇧'},
    {'code': 'fr', 'label': 'French',   'native': 'Français',   'flag': '🇫🇷'},
    {'code': 'ne', 'label': 'Nepali',   'native': 'नेपाली',      'flag': '🇳🇵'},
    {'code': 'hi', 'label': 'Hindi',    'native': 'हिन्दी',       'flag': '🇮🇳'},
    {'code': 'tl', 'label': 'Filipino', 'native': 'Tagalog',    'flag': '🇵🇭'},
    {'code': 'zh', 'label': 'Chinese',  'native': '中文',         'flag': '🇨🇳'},
    {'code': 'ar', 'label': 'Arabic',   'native': 'العربية',     'flag': '🇸🇦'},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Language'),
          Card(
            child: Column(
              children: _languages.asMap().entries.map((entry) {
                final i = entry.key;
                final lang = entry.value;
                final isLast = i == _languages.length - 1;
                return Column(children: [
                  _LanguageTile(
                    label: lang['native']!, subtitle: lang['label']!,
                    flag: lang['flag']!,
                    selected: settings.languageCode == lang['code'],
                    onTap: () => settings.setLanguage(lang['code']!),
                  ),
                  if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
                ]);
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          _SectionHeader(title: 'Default mode for new schedules'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'silent', label: Text('Silent'), icon: Icon(Icons.volume_off)),
                  ButtonSegment(value: 'vibrate', label: Text('Vibrate'), icon: Icon(Icons.vibration)),
                ],
                selected: {settings.defaultMode},
                onSelectionChanged: (val) => settings.setDefaultMode(val.first),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _SectionHeader(title: 'Default alert before meeting'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                children: [5, 10, 15, 30].map((mins) => ChoiceChip(
                  label: Text('$mins min'),
                  selected: settings.defaultAlertMinutes == mins,
                  onSelected: (_) => settings.setDefaultAlertMinutes(mins),
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _SectionHeader(title: 'Privacy'),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, size: 20, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All data is stored locally on your device. '
                      'No personal information is collected or transmitted.',
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          Center(child: Text('Meeting Silencer v1.0.0',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))),
          const SizedBox(height: 4),
          Center(child: Text('ICT107 Mobile App and Web Development',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
          letterSpacing: 0.8, color: Theme.of(context).colorScheme.primary)),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label, subtitle, flag;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageTile({required this.label, required this.subtitle,
    required this.flag, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: selected
          ? Icon(Icons.check_circle, color: scheme.primary)
          : Icon(Icons.circle_outlined, color: scheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
