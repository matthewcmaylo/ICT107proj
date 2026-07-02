package com.example.meeting_silencer

import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.example.meeting_silencer/ringer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                if (call.method == "setRingerMode") {
                    val mode = call.argument<String>("mode")
                    val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
                    when (mode) {
                        "silent"  -> audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                        "vibrate" -> audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
                        "normal"  -> audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                        else -> result.error("INVALID_MODE", "Unknown mode: $mode", null)
                    }
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
