import 'dart:io';
import 'package:flutter/services.dart';
import 'package:volume_controller/volume_controller.dart';

class RingerService {
  static const _channel = MethodChannel('com.example.meeting_silencer/ringer');

  Future<void> setMode(String mode) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('setRingerMode', {'mode': mode});
    } else if (Platform.isIOS) {
      VolumeController.instance.showSystemUI = false;
      await VolumeController.instance.setVolume(0.0);
    }
  }

  Future<void> restoreNormal() async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('setRingerMode', {'mode': 'normal'});
    } else if (Platform.isIOS) {
      VolumeController.instance.showSystemUI = false;
      await VolumeController.instance.setVolume(1.0);
    }
  }
}
