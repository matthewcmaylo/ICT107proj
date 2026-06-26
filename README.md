# Meeting Silencer

Automatically switches your device to silent or vibration mode during scheduled meeting hours.

Built with Flutter — targets Android, iOS, Web, Windows, macOS, and Linux.

---

## Setup

**1. Create the Flutter project (if not done yet)**
```bash
flutter create meeting_silencer
cd meeting_silencer
```
Then replace the generated `lib/` with the files in this project.

**2. Get dependencies**
```bash
flutter pub get
```

**3. Generate localization files**
```bash
flutter gen-l10n
```
This reads `lib/l10n/app_en.arb` and `app_fr.arb` and produces
`app_localizations.dart`. After this, uncomment the `AppLocalizations`
lines in `lib/app.dart`.

**4. Run the app**
```bash
flutter run
```

---

## Platform Permissions

### Android
Add inside `<manifest>` in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>
```

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>processing</string>
    <string>remote-notification</string>
</array>
```
Note: iOS does not allow apps to programmatically change the ringer mode.
On iOS, the notification alerts the user to switch manually.

---

## Architecture

| Layer | Location | Responsibility |
|---|---|---|
| Presentation | `lib/ui/` | Flutter widgets and screens |
| Business Logic | `lib/logic/` | Providers: state, scheduling, time zones |
| Data | `lib/data/` | Models and services (storage, notifications) |
| Core | `lib/core/` | Constants, theme |

---

## Privacy and Security

- All data stored locally using `shared_preferences` (sandboxed to app)
- No network requests, no third-party analytics
- No personal identifiers stored — only schedule titles and time preferences
- Do Not Disturb permission requested only when needed (Android)
