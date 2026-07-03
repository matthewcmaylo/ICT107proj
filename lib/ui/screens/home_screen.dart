import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'schedule_screen.dart';
import 'settings_screen.dart';
import 'world_clock_screen.dart';

/// Root screen. Hosts the bottom nav bar and swaps between the three sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ScheduleScreen(),
    WorldClockScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        // Removed const so labels can be resolved from AppLocalizations at runtime
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: const Icon(Icons.schedule),
            // Translated nav label for the schedules tab
            label: AppLocalizations.of(context).navSchedules,
          ),
          NavigationDestination(
            icon: const Icon(Icons.public_outlined),
            selectedIcon: const Icon(Icons.public),
            // Translated nav label for the world clock tab
            label: AppLocalizations.of(context).navWorldClock,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            // Translated nav label for the settings tab
            label: AppLocalizations.of(context).navSettings,
          ),
        ],
      ),
    );
  }
}
