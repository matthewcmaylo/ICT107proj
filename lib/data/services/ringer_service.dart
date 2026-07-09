import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:volume_controller/volume_controller.dart';

class RingerService {
  static const _channel = MethodChannel('com.example.meeting_silencer/ringer');

  /// Sets the ringer to silent/vibrate on Android, or drops volume to 0 on iOS.
  /// Returns true on success, false if DND permission is missing (TC-10 fix:
  /// previously an unhandled PlatformException crashed the app here).
  Future<bool> setMode(String mode) async {
    // Web has no ringer control; skip silently
    if (kIsWeb) return true;
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setRingerMode', {'mode': mode});
        return true;
      } on PlatformException catch (e) {
        if (e.code == 'DND_PERMISSION_DENIED') {
          // Caller can prompt the user and open settings via openDndSettings()
          return false;
        }
        rethrow;
      }
    } else if (Platform.isIOS) {
      VolumeController.instance.showSystemUI = false;
      await VolumeController.instance.setVolume(0.0);
      return true;
    }
    return true;
  }

  /// Restores the normal ringer mode after a meeting ends.
  Future<bool> restoreNormal() async {
    if (kIsWeb) return true;
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setRingerMode', {'mode': 'normal'});
        return true;
      } on PlatformException catch (e) {
        if (e.code == 'DND_PERMISSION_DENIED') return false;
        rethrow;
      }
    } else if (Platform.isIOS) {
      VolumeController.instance.showSystemUI = false;
      await VolumeController.instance.setVolume(1.0);
      return true;
    }
    return true;
  }

  /// True when Do Not Disturb access has been granted (Android only).
  Future<bool> hasDndAccess() async {
    // Platform.isAndroid is not available on web (TC-10 web crash fix)
    if (kIsWeb || !Platform.isAndroid) return true;
    return await _channel.invokeMethod('hasDndAccess') as bool;
  }

  /// Opens the Android system screen where the user grants DND access.
  Future<void> openDndSettings() async {
    if (kIsWeb) return;
    if (Platform.isAndroid) {
      await _channel.invokeMethod('openDndSettings');
    }
  }
}
