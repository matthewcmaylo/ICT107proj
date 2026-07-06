
Project: ICT107 Mobile App and Web Development

App: Meeting Silencer (Flutter)

Test Device (Android): Motorola Razr 40, Android 15 - tested by Patricia
Test Device (iOS): iPhone with Xcode simulator or physical device - tested by Josh / Matt
Test Platform (Web): Chrome browser via `flutter run -d chrome` - tested by Karina

## How to Use This Document

Each tester fills in the Result and Notes columns for their own platform only. Use: PASS, FAIL, SKIP, PENDING, or N/A (feature not supported on that platform).

To avoid merge conflicts, post in the group chat before pushing changes to this file, and pull the latest version before editing.

## Section 1 - Schedule Management

Tests that meeting schedules can be created, edited, deleted, and persisted. Run on all platforms.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-01 | Add a new meeting | Open app, tap Schedules tab, tap Add, enter title "test meeting", start time 9:00 AM, end time 10:00 AM, select repeat days (Mon, Tue, Wed, Thu, Fri), save. | New schedule appears in the list with correct title "test meeting", time 9:00 AM–10:00 AM, and repeat days Mon–Fri. | PASS | | PENDING | | PASS | Created "test meeting" (9:00 AM–10:00 AM), repeat days Mon–Fri. Schedule displayed correctly in Chrome. |
| TC-02 | Edit an existing meeting | Long-press or tap edit on a schedule, change the title and end time, save. | Schedule list shows updated values. | FAIL | Long-press edit not working, no edit path available | PENDING | | FAIL | No edit option or edit path available in Chrome. |
| TC-03 | Delete a meeting | Swipe or tap delete on a schedule, confirm deletion. | Schedule is removed from the list and no longer silences the phone. | PASS | | PENDING | | PASS | Meeting deleted successfully in Chrome; item removed from the schedule list. |
| TC-04 | Enable / disable a schedule | Toggle the enable switch on a schedule off, then back on. | Disabled schedule does not trigger silencing. Re-enabling restores it. | PASS | | PENDING | | PASS | Enable and disable toggle worked correctly in Chrome |
| TC-05 | Schedules persist after restart | Add a schedule, close the app fully, reopen. | Schedule is still present with all fields intact (SharedPreferences check). | PASS | | PENDING | | PASS | Schedule persisted after closing and reopening the app in Chrome. Default mode and alert time preferences also stored correctly |

## Section 2 - Auto-Silencing (Android only)

Tests that the core silencing feature works on the physical Android device. Requires the device connected via USB with flutter run active. Not applicable to iOS or web.

| ID | Test Name | Steps | Expected Result | Result | Notes |
| --- | --- | --- | --- | --- | --- |
| TC-06 | Phone silences at meeting start | Create a schedule starting 1-2 min from now, wait for the minute to tick over. | Ringer mode switches to silent. Verify by calling the phone. | PASS | Requires DND access permission granted manually. First attempt failed with SecurityException until permission enabled |
| TC-07 | Phone restores after meeting ends | Enable the restore normal mode toggle, let the meeting end. | Ringer mode returns to normal after the meeting window closes. | PASS | |
| TC-08 | Restore toggle off - stays silent | Disable restore toggle, let a meeting end. | Phone stays silent. User must manually restore ringer. | FAIL | Restore toggle off was ignored, phone returned to normal ringer after meeting end instead of staying silent |
| TC-09 | Vibrate mode schedule | Create a schedule set to vibrate mode, wait for start time. | Phone switches to vibrate, not full silent. | PASS | |
| TC-10 | Do Not Disturb permission handling | Revoke DND permission in Android settings, open app, trigger a meeting. | App requests DND permission or shows a message. Does not crash. | FAIL | Unhandled PlatformException when DND permission missing, no prompt shown to user |

## Section 3 - Auto-Silencing (iOS only)

Tests for iOS volume control via volume_controller. Requires Xcode and an iOS simulator or physical iPhone. Not applicable to Android or web.

| ID | Test Name | Steps | Expected Result | Result | Notes |
| --- | --- | --- | --- | --- | --- |
| TC-11 | Volume set to 0 at meeting start | Create a schedule starting 1-2 min from now, wait for the minute to tick over. | Ringer volume drops to 0. Verify in Control Centre. | PENDING | |
| TC-12 | Volume restored after meeting ends | Enable the restore toggle, let meeting end. | Volume returns to the previous level. | PENDING | |

## Section 4 - Notifications

Tests that local notifications fire correctly before or at meeting start. Not supported on web (flutter_local_notifications has no web support), so web columns are N/A.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-13 | Notification fires before meeting | Create a schedule starting in a few minutes, wait. | A local notification appears on the lock screen or notification bar. | FAIL | No notification at meeting start. End-of-meeting notification received. Start notification may be suppressed by the app silencing itself. | PENDING | | N/A | Not supported on web. |
| TC-14 | No duplicate notifications | Add the same schedule twice, wait for meeting time. | Only one notification should fire per meeting. | PENDING | | PENDING | | N/A | Duplicate schedules were able to be created in Chrome; however, local notifications are not supported on the web, so notification behavior could not be tested. |
| TC-15 | Notification permission denied | Deny notification permission in device settings, trigger a meeting. | App does not crash. Silencing still works without notification permission. | PENDING | | PENDING | | N/A | Not supported on web. |

## Section 5 - World Clock

Tests for the world clock screen. Run on all platforms.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-16 | Time zones display correctly | Open World Clock tab, check displayed times for listed cities. | Times match the real-world current time for each city. | PENDING | | PENDING | | PASS | World Clock displayed correct times for listed cities |
| TC-17 | Time updates in real time | Leave the World Clock tab open for 1-2 minutes. | Displayed times increment correctly and do not stay frozen. | PENDING | | PENDING | | PASS | Times updated in real time, no freezing |

## Section 6 - Settings and Language

Tests for the multilingual UI and settings persistence. Run on all platforms.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-18 | Language switches to French | Settings, Language, select French. | All UI labels change to French immediately. | PENDING | | PENDING | | PASS | UI switched to French correctly |
| TC-19 | Language switches to Arabic | Settings, Language, select Arabic. | UI shows Arabic text. Layout adjusts for RTL if implemented. | PENDING | | PENDING | | PASS | UI switched to Arabic correctly |
| TC-20 | Language preference persists | Switch to Nepali, close and reopen the app. | App reopens in Nepali. | PENDING | | PENDING | | PASS | Language preference persisted after app restart |

## Section 7 - Edge Cases

Tests for unusual or boundary conditions. Run on all platforms. Note: on web, "silences correctly" is not applicable, so TC-21 and TC-22 on web only verify the schedule saves and displays correctly without crashing.

| ID | Test Name | Steps | Expected Result | Android | Android Notes | iOS | iOS Notes | Web | Web Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TC-21 | Overlapping schedules | Create two schedules with overlapping time windows, wait for start. | App silences correctly. Does not crash or behave unexpectedly. | PENDING | | PENDING | | PASS | Verified on Chrome: schedules save and display correctly, No crash. |
| TC-22 | Schedule spanning midnight | Create a schedule from 11:45 PM to 12:15 AM. | Silencing triggers at 11:45 PM and restores at 12:15 AM correctly. | PENDING | | PENDING | | PASS | Verified on Chrome: schedule saves and displays correctly, no crash. |
| TC-23 | No schedules added | Delete all schedules, use the app normally. | App shows empty state. Does not crash. Phone ringer is unaffected. | PENDING | | PENDING | | PASS | Verified on Chrome: empty state displayed without crashing. |

## Summary

Platform-specific sections (2 and 3) count toward their own platform only. N/A cells are excluded from Pass/Fail/Pending counts.

| Platform | Applicable Tests | Pass | Fail | Skip | Pending |
| --- | --- | --- | --- | --- | --- |
| Android | 21 | 7 | 4 | | 10 |
| iOS | 18 | | | | 18 |
| Web | 13 | 12 | 1 | | 0 |

### Android breakdown

| Section | Total | Pass | Fail | Skip | Pending |
| --- | --- | --- | --- | --- | --- |
| Schedule Management | 5 | 4 | 1 | | 0 |
| Auto-Silencing (Android) | 5 | 3 | 2 | | 0 |
| Notifications | 3 | | 1 | | 2 |
| World Clock | 2 | | | | 2 |
| Settings and Language | 3 | | | | 3 |
| Edge Cases | 3 | | | | 3 |
| Total | 21 | 7 | 4 | | 10 |

## Known Defects (from Android testing)

1. TC-02: No way to edit an existing schedule. Long-press does not trigger edit and no edit button exists.
2. TC-08: The restore normal mode toggle is ignored when off. Phone returns to normal ringer after every meeting regardless of the setting.
3. TC-10: App throws an unhandled PlatformException and crashes the flow when DND access permission is not granted, instead of prompting the user. SecurityException at MainActivity.kt line 19.
4. TC-13: No notification fires at meeting start. An end-of-meeting notification is received. The start notification may be suppressed by the app's own silencing.
