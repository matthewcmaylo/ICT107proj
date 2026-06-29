# Meeting Silencer

A cross-platform mobile app that **automatically switches your device to silent or vibrate mode** during scheduled meeting times — so you never forget to silence your phone before a class or meeting.

Built with Flutter as a group project for **ICT107 Mobile App and Web Development**.

---

## What It Does

- Add meeting time blocks with a title, start time, and end time
- The app checks every minute and silences your device when a meeting starts
- Optionally restores your normal ringer mode when the meeting ends
- Sends a local notification reminder before meetings
- Displays a world clock so you can track time zones globally
- Fully multilingual: switch the UI between 7 languages in Settings

---

## Features

| Feature | Details |
|---------|---------|
| Meeting scheduler | Add, edit, and delete time blocks with local JSON storage |
| Auto-silencing | Checks every 60 seconds; triggers on meeting start |
| Restore after meeting | Optional toggle to return to normal mode automatically |
| World clock | Global time display with time zone support |
| Notifications | Local alerts via `flutter_local_notifications` |
| Multilingual UI | English, French, Nepali, Hindi, Filipino (Tagalog), Chinese, Arabic |
| State management | Provider pattern |

---

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | Supported | Uses `AudioManager` via MethodChannel to set ringer mode |
| iOS | Supported | Sets ringer volume to 0 via `volume_controller` (see note below) |
| Web | Supported | |
| Windows | Supported | |
| macOS | Supported | |
| Linux | Supported | |

> **iOS note:** Apple does not allow third-party apps to toggle the hardware silent switch. Instead, the app sets ringer volume to 0 during meetings using `volume_controller ^3.6.0`, which achieves the same practical effect.

---

## Tech Stack

- **Framework:** Flutter / Dart
- **State Management:** Provider
- **Local Storage:** SharedPreferences (JSON)
- **Notifications:** flutter_local_notifications
- **Android Ringer Control:** Kotlin `AudioManager` via Flutter MethodChannel
- **iOS Volume Control:** volume_controller ^3.6.0
- **Time Zones:** flutter_timezone, timezone

---

## Project Structure

```
lib/
├── main.dart                         # App entry point; Timer.periodic checks meeting state every minute
├── presentation/                     # UI layer
│   ├── screens/
│   │   ├── schedule_screen.dart      # Meeting schedule list and management
│   │   ├── world_clock_screen.dart   # Global time zone display
│   │   └── settings_screen.dart      # Language toggle and preferences
│   └── widgets/
├── business_logic/
│   └── providers/
│       ├── meeting_provider.dart     # Schedule state management
│       └── schedule_provider.dart   # isCurrentlyInMeeting logic
└── data/
    ├── models/
    │   └── meeting.dart
    └── services/
        ├── storage_service.dart      # SharedPreferences read/write
        ├── notification_service.dart
        └── ringer_service.dart       # Calls AudioManager (Android) or VolumeController (iOS)

android/
└── app/src/main/kotlin/com/example/meeting_silencer/
    └── MainActivity.kt              # MethodChannel handler for AudioManager ringer mode

ios/
└── Runner/
    └── Info.plist                   # UIBackgroundModes: audio
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio or Xcode depending on your target platform
- A connected device or emulator

### Run the App

```bash
# Clone the repo
git clone https://github.com/matthewcmaylo/ICT107proj.git
cd ICT107proj

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run on a connected device
flutter run
```

### Build an APK (Android)

```bash
flutter build apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Android Permissions

Add the following inside `<manifest>` in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

---

## Team

| Name | Contribution |
|------|-------------|
| Matthew Maylo | [role] |
| Patricia Ballonado | [role] |
| Karina Pathak | [role] |
| Chander Prabha | [role] |
| Subarna Ghamal| [role] |
| Josh| [role] |

---

## About

ICT107 group project. All data is stored locally on-device. No network requests, no analytics, no personal data collected.
