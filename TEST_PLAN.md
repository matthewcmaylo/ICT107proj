# Meeting Silencer — Test Plan

**Project:** ICT107 Mobile App and Web Development
**App:** Meeting Silencer (Flutter)
**Test Device (Android):** Google Pixel 9 Pro (Android 16)
**Test Device (iOS):** iPhone with Xcode simulator or physical device
**Prepared by:** ICT107 Group

---

## How to Use This Document

| Result | Meaning |
|--------|---------|
| PASS | Tested and works as expected |
| FAIL | Tested — something went wrong (add notes) |
| SKIP | Cannot test right now (e.g. iOS tests while Xcode is not set up) |
| PENDING | Not yet tested |

---

## Section 1 — Schedule Management

Tests that meeting schedules can be created, edited, deleted, and persisted. These run on any platform (Android, iOS, or web).

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-01 | Add a new meeting | Open app → tap Schedules tab → tap Add → enter title, start time, end time, select repeat days → save. | New schedule appears in the list with correct title and times. | PENDING | |
| TC-02 | Edit an existing meeting | Long-press or tap edit on a schedule → change the title and end time → save. | Schedule list shows updated values. | PENDING | |
| TC-03 | Delete a meeting | Swipe or tap delete on a schedule → confirm deletion. | Schedule is removed from the list and no longer silences the phone. | PENDING | |
| TC-04 | Enable / disable a schedule | Toggle the enable switch on a schedule off, then back on. | Disabled schedule does not trigger silencing. Re-enabling restores it. | PENDING | |
| TC-05 | Schedules persist after app restart | Add a schedule → close the app fully → reopen. | Schedule is still present with all fields intact (SharedPreferences check). | PENDING | |

---

## Section 2 — Auto-Silencing (Android)

Tests that the core silencing feature works on the physical Android device. These require the Pixel 9 Pro connected via USB with `flutter run` active.

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-06 | Phone silences at meeting start | Create a schedule starting 1–2 min from now → wait for the minute to tick over. | Ringer mode switches to silent automatically. Verify by calling the phone. | PENDING | |
| TC-07 | Phone restores after meeting ends | Enable the "restore normal mode" toggle → let the meeting end (or set end time 1 min away). | Ringer mode returns to normal after the meeting window closes. | PENDING | |
| TC-08 | Restore toggle off — stays silent | Disable "restore normal mode" toggle → let a meeting end. | Phone stays silent. User must manually restore ringer. | PENDING | |
| TC-09 | Vibrate mode schedule | Create a schedule set to vibrate mode → wait for start time. | Phone switches to vibrate, not full silent. | PENDING | |
| TC-10 | Do Not Disturb permission handling | Revoke DND permission in Android settings → open app → trigger a meeting. | App requests DND permission or shows an appropriate message. Does not crash. | PENDING | |

---

## Section 3 — Auto-Silencing (iOS)

Tests for iOS volume control via `volume_controller`. Requires Xcode and an iOS simulator or physical iPhone.

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-11 | Volume set to 0 at meeting start | Create a schedule starting 1–2 min from now → wait for the minute to tick over. | Ringer volume drops to 0. Verify in Control Centre. | PENDING | |
| TC-12 | Volume restored after meeting ends | Enable the restore toggle → let meeting end. | Volume returns to the previous level. | PENDING | |

---

## Section 4 — Notifications

Tests that local notifications fire correctly before or at meeting start.

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-13 | Notification fires before meeting | Create a schedule starting in a few minutes → wait. | A local notification appears on the lock screen or notification bar. | PENDING | |
| TC-14 | No duplicate notifications | Add the same schedule twice → wait for meeting time. | Only one notification fires per meeting. | PENDING | |
| TC-15 | Notification permission denied | Deny notification permission in device settings → trigger a meeting. | App does not crash. Silencing still works even without notification permission. | PENDING | |

---

## Section 5 — World Clock

Tests for the world clock screen.

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-16 | Time zones display correctly | Open World Clock tab → check displayed times for listed cities. | Times match the real-world current time for each city. | PENDING | |
| TC-17 | Time updates in real time | Leave the World Clock tab open for 1–2 minutes. | Displayed times increment correctly and do not stay frozen. | PENDING | |

---

## Section 6 — Settings and Language

Tests for the multilingual UI and settings persistence.

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-18 | Language switches to French | Settings → Language → select French. | All UI labels change to French immediately. | PENDING | |
| TC-19 | Language switches to Arabic | Settings → Language → select Arabic. | UI shows Arabic text. Layout adjusts for RTL if implemented. | PENDING | |
| TC-20 | Language preference persists | Switch to Nepali → close and reopen the app. | App reopens in Nepali. | PENDING | |

---

## Section 7 — Edge Cases

Tests for unusual or boundary conditions.

| ID | Test Name | Steps | Expected Result | Result | Notes |
|----|-----------|-------|----------------|--------|-------|
| TC-21 | Overlapping schedules | Create two schedules with overlapping time windows → wait for start. | App silences correctly. Does not crash or behave unexpectedly. | PENDING | |
| TC-22 | Schedule spanning midnight | Create a schedule from 11:45 PM to 12:15 AM. | Silencing triggers at 11:45 PM and restores at 12:15 AM correctly. | PENDING | |
| TC-23 | No schedules added | Delete all schedules → use the app normally. | App shows empty state. Does not crash. Phone ringer is unaffected. | PENDING | |

---

## Summary

| Section | Total | Pass | Fail | Skip | Pending |
|---------|-------|------|------|------|---------|
| Schedule Management | 5 | | | | 5 |
| Auto-Silencing (Android) | 5 | | | | 5 |
| Auto-Silencing (iOS) | 2 | | | | 2 |
| Notifications | 3 | | | | 3 |
| World Clock | 2 | | | | 2 |
| Settings and Language | 3 | | | | 3 |
| Edge Cases | 3 | | | | 3 |
| **Total** | **23** | | | | **23** |

---

*Fill in the Result and Notes columns as testing progresses. Update the Summary table when done.*
