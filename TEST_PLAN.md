
Project: ICT107 Mobile App and Web Development

App: Meeting Silencer (Flutter)

Test Device (Android): Motorola Razr 40, Android 15 - tested by Patricia
Test Device (iOS): iPhone with Xcode simulator or physical device - tested by Josh / Matt
Test Platform (Web): Chrome browser via `flutter run -d chrome` - tested by Karina, Subarna, Chander

## How to Use This Document

Each tester fills in the Result and Notes columns for their own platform only. Use: PASS, FAIL, SKIP, PENDING, or N/A (feature not supported on that platform).

To avoid merge conflicts, post in the group chat before pushing changes to this file, and pull the latest version before editing.

## Section 1 - Schedule Management

Tests that meeting schedules can be created, edited, deleted, and persisted. Run on all platforms.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-01 | Add a new meeting | Open app, tap Schedules tab, tap Add, enter title "test meeting", start time 9:00 AM, end time 10:00 AM, select repeat days (Mon, Tue, Wed, Thu, Fri), save. | New schedule appears in the list with correct title "test meeting", time 9:00 AM–10:00 AM, and repeat days Mon–Fri. | PASS | | PASS | Tested on physical iPhone by Josh Arbias and Jan Matthew Cmaylo. | PASS | Created "test meeting" (9:00 AM–10:00 AM), repeat days Mon–Fri. Schedule displayed correctly in Chrome. |
| TC-02 | Edit an existing meeting | Long-press or tap edit on a schedule, change the title and end time, save. | Schedule list shows updated values. | PASS | Fixed: added pencil edit button to each schedule card. Retested by Patricia on Razr 40. | PASS | Fixed: edit button now present. Retested by Patricia on physical iPhone. | PASS | Fixed: edit button works in Chrome. Retested by Patricia. |
| TC-03 | Delete a meeting | Swipe or tap delete on a schedule, confirm deletion. | Schedule is removed from the list and no longer silences the phone. | PASS | | PASS | Tested on physical iPhone by Josh Arbias and Jan Matthew Cmaylo. | PASS | Meeting deleted successfully in Chrome; item removed from the schedule list. |
| TC-04 | Enable / disable a schedule | Toggle the enable switch on a schedule off, then back on. | Disabled schedule does not trigger silencing. Re-enabling restores it. | PASS | | PASS | Enable and disable toggle working correctly on simulator. Tested by Jan Matthew Cmaylo. | PASS | Enable and disable toggle worked correctly in Chrome |
| TC-05 | Schedules persist after restart | Add a schedule, close the app fully, reopen. | Schedule is still present with all fields intact (SharedPreferences check). | PASS | | PASS | Schedules persist after restarting the app on simulator. Tested by Jan Matthew Cmaylo. | PASS | Schedule persisted after closing and reopening the app in Chrome. Default mode and alert time preferences also stored correctly |

## Section 2 - Auto-Silencing (Android only)

Tests that the core silencing feature works on the physical Android device. Requires the device connected via USB with flutter run active. Not applicable to iOS or web.

| ID | Test Name | Steps | Expected Result | Result | Notes |
| --- | --- | --- | --- | --- | --- |
| TC-06 | Phone silences at meeting start | Create a schedule starting 1-2 min from now, wait for the minute to tick over. | Ringer mode switches to silent. Verify by calling the phone. | PASS | Requires DND access permission granted manually. First attempt failed with SecurityException until permission enabled |
| TC-07 | Phone restores after meeting ends | Enable the restore normal mode toggle, let the meeting end. | Ringer mode returns to normal after the meeting window closes. | PASS | |
| TC-08 | Restore toggle off - stays silent | Disable restore toggle, let a meeting end. | Phone stays silent. User must manually restore ringer. | PASS | Fixed: timer now tracks active schedule and only restores when restoreAfter is on. Retested by Patricia on Razr 40. |
| TC-09 | Vibrate mode schedule | Create a schedule set to vibrate mode, wait for start time. | Phone switches to vibrate, not full silent. | PASS | |
| TC-10 | Do Not Disturb permission handling | Revoke DND permission in Android settings, open app, trigger a meeting. | App requests DND permission or shows a message. Does not crash. | PASS | Fixed: app checks DND access on startup and opens system settings if missing. No crash on trigger. Retested by Patricia on Razr 40. |

## Section 3 - Auto-Silencing (iOS only)

Tests for iOS volume control via volume_controller. Requires Xcode and an iOS simulator or physical iPhone. Not applicable to Android or web.

| ID | Test Name | Steps | Expected Result | Result | Notes |
| --- | --- | --- | --- | --- | --- |
| TC-11 | Volume set to 0 at meeting start | Create a schedule starting 1-2 min from now, wait for the minute to tick over. | Ringer volume drops to 0. Verify in Control Centre. | PASS | Media volume drops to 0 in Control Centre. Retested by Patricia on physical iPhone (iOS 18.6.2). |
| TC-12 | Volume restored after meeting ends | Enable the restore toggle, let meeting end. | Volume returns to the previous level. | PASS | Volume restored after meeting ended. Retested by Patricia on physical iPhone (iOS 18.6.2). |

## Section 4 - Notifications

Tests that local notifications fire correctly before or at meeting start. Not supported on web (flutter_local_notifications has no web support), so web columns are N/A.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-13 | Notification fires before meeting | Create a schedule starting in a few minutes, wait. | A local notification appears on the lock screen or notification bar. | PASS | Fixed: near-term schedules now fire catch-up notification. 5-min-before alert also works. Retested by Patricia on Razr 40. | PASS | Fixed: catch-up notification scheduled 5 seconds out to avoid iOS foreground suppression. Retested by Patricia on physical iPhone. | N/A | Not supported on web. |
| TC-14 | No duplicate notifications | Add the same schedule twice, wait for meeting time. | Only one notification should fire per meeting. | PASS | Fixed: duplicate schedules now blocked with snackbar message. Retested by Patricia on Razr 40. | PASS | Duplicate blocked with snackbar. Retested by Patricia on physical iPhone. | N/A | Duplicate schedules were able to be created in Chrome; however, local notifications are not supported on the web, so notification behavior could not be tested. |
| TC-15 | Notification permission denied | Deny notification permission in device settings, trigger a meeting. | App does not crash. Silencing still works without notification permission. | PASS | No crash, silencing works without notification permission | PASS | App did not crash with notifications denied. Retested by Patricia on physical iPhone. | N/A | Not supported on web. |

## Section 5 - World Clock

Tests for the world clock screen. Run on all platforms.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-16 | Time zones display correctly | Open World Clock tab, check displayed times for listed cities. | Times match the real-world current time for each city. | PASS | City times matched real world times | PASS | Time zones displayed correctly, verified against iOS weather app on separate device. Tested by Jan Matthew Cmaylo. | PASS | World Clock displayed correct times for listed cities |
| TC-17 | Time updates in real time | Leave the World Clock tab open for 1-2 minutes. | Displayed times increment correctly and do not stay frozen. | PASS | Times updated in real time, no freezing | PASS | Times updated in real time on simulator, no freezing. Tested by Jan Matthew Cmaylo. | PASS | Times updated in real time, no freezing |

## Section 6 - Settings and Language

Tests for the multilingual UI and settings persistence. Run on all platforms.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-18 | Language switches to French | Settings, Language, select French. | All UI labels change to French immediately. | PASS | Minor labels e.g. Save remain in English by design | PASS | UI labels switched from English to French immediately. Tested by Jan Matthew Cmaylo. | PASS | UI switched to French correctly |
| TC-19 | Language switches to Arabic | Settings, Language, select Arabic. | UI shows Arabic text. Layout adjusts for RTL if implemented. | PASS | Arabic text displayed correctly | PASS | Arabic text displayed correctly, UI layout switched from left to right to right to left. Tested by Jan Matthew Cmaylo. | PASS | UI switched to Arabic correctly |
| TC-20 | Language preference persists | Switch to Nepali, close and reopen the app. | App reopens in Nepali. | PASS | Language persisted after full app restart | PASS | Language switched to Nepali and persisted after restarting the app on simulator. Tested by Jan Matthew Cmaylo. | PASS | Language preference persisted after app restart |

## Section 7 - Edge Cases

Tests for unusual or boundary conditions. Run on all platforms. Note: on web, "silences correctly" is not applicable, so TC-21 and TC-22 on web only verify the schedule saves and displays correctly without crashing.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-21 | Overlapping schedules | Create two schedules with overlapping time windows, wait for start. | App silences correctly. Does not crash or behave unexpectedly. | PASS | Stayed silent through first meeting end during overlap, restored only after second meeting ended | PASS | Both overlapping schedules set at 1:15, app did not crash. Tested by Jan Matthew Cmaylo. | PASS | Verified on Chrome: schedules save and display correctly, No crash. |
| TC-22 | Schedule spanning midnight | Create a schedule from 11:45 PM to 12:15 AM. | Silencing triggers at 11:45 PM and restores at 12:15 AM correctly. | PASS | Fixed: isActiveAt helper handles midnight-spanning windows. Phone silenced at start and restored at end. Retested by Patricia on Razr 40. | PASS | Midnight spanning schedule displays correctly on simulator, no crash. Tested by Jan Matthew Cmaylo. | PASS | Verified on Chrome: schedule saves and displays correctly, no crash. |
| TC-23 | No schedules added | Delete all schedules, use the app normally. | App shows empty state. Does not crash. Phone ringer is unaffected. | PASS | Empty state displayed correctly, no crash, ringer unaffected | PASS | App shows empty state and does not crash on simulator. Tested by Jan Matthew Cmaylo. | PASS | Verified on Chrome: empty state displayed without crashing. |

## Summary

Platform-specific sections (2 and 3) count toward their own platform only. N/A cells are excluded from Pass/Fail/Pending counts.

| Platform | Applicable Tests | Pass | Fail | Skip | Pending |
| --- | --- | --- | --- | --- | --- |
| Android | 21 | 21 | 0 | | 0 |
| iOS | 18 | 18 | 0 | | 0 |
| Web | 13 | 13 | 0 | | 0 |

### Android breakdown

| Section | Total | Pass | Fail | Skip | Pending |
| --- | --- | --- | --- | --- | --- |
| Schedule Management | 5 | 5 | 0 | | 0 |
| Auto-Silencing (Android) | 5 | 5 | 0 | | 0 |
| Notifications | 3 | 3 | 0 | | 0 |
| World Clock | 2 | 2 | 0 | | 0 |
| Settings and Language | 3 | 3 | 0 | | 0 |
| Edge Cases | 3 | 3 | 0 | | 0 |
| Total | 21 | 21 | 0 | | 0 |

### iOS breakdown
| Section | Total | Pass | Fail | Skip | Pending |
| --- | --- | --- | --- | --- | --- |
| Schedule Management | 5 | 5 | 0 | | 0 |
| Auto-Silencing (iOS) | 2 | 2 | 0 | | 0 |
| Notifications | 3 | 3 | 0 | | 0 |
| World Clock | 2 | 2 | 0 | | 0 |
| Settings and Language | 3 | 3 | 0 | | 0 |
| Edge Cases | 3 | 3 | 0 | | 0 |
| Total | 18 | 18 | 0 | | 0 |

## Known Defects (from Android testing) — ALL RESOLVED

1. TC-02: No edit path for schedules. **Resolved:** added pencil edit button to each schedule card, reusing AddScheduleScreen with an optional existing parameter. Files: schedule_screen.dart, add_schedule_screen.dart.
2. TC-08: Restore toggle ignored. **Resolved:** timer now tracks the last active schedule and only calls restoreNormal on the meeting-end transition when restoreAfter is on. File: main.dart.
3. TC-10: Unhandled crash when DND permission missing. **Resolved:** MainActivity.kt checks isNotificationPolicyAccessGranted before changing ringer mode. RingerService catches the PlatformException. App opens DND settings on startup if access is missing. Files: MainActivity.kt, ringer_service.dart, main.dart.
4. TC-13: Start notification never fired for near-term schedules. **Resolved:** catch-up notification scheduled 5 seconds from now when alert window has passed but meeting start is still ahead. File: notification_service.dart.
5. TC-14: Duplicate schedules generated duplicate notifications. **Resolved:** isDuplicate check in ScheduleProvider blocks identical schedules with a snackbar message. Files: schedule_provider.dart, add_schedule_screen.dart.
6. TC-22: Midnight-spanning schedules never activated. **Resolved:** isActiveAt helper on MeetingSchedule handles wrapped time windows and yesterday's weekday for after-midnight checks. Files: meeting_schedule.dart, schedule_provider.dart, main.dart.

## Known Defects (from iOS testing) — ALL RESOLVED
Originally tested by Josh Arbias and Jan Matthew Cmaylo on physical iPhone (iOS 26.5). All defects resolved and retested by Patricia on physical iPhone (iOS 18.6.2).

1. TC-10: App crashed on standalone launch. **Resolved:** original crash was caused by debug build requiring active Mac connection. Release build (flutter run --release) launches and runs independently. DND permission code guarded with Platform.isAndroid so iOS is unaffected.
2. TC-11: Media volume did not drop at meeting start. **Resolved:** volume_controller sets media volume to 0 correctly on physical iPhone. Original failure was on pre-fix code.
3. TC-12: Volume not restored after meeting end. **Resolved:** volume restores correctly after meeting ends with restoreAfter enabled. Original failure was on pre-fix code.
4. TC-02: No edit option. **Resolved:** same fix as Android, pencil edit button added. Files: schedule_screen.dart, add_schedule_screen.dart.
5. TC-13: No start notification. **Resolved:** catch-up notification scheduled 5 seconds out to avoid iOS foreground suppression. File: notification_service.dart.
