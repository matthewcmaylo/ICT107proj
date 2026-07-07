package com.example.meeting_silencer
import android.app.NotificationManager
import android.content.Intent
import android.media.AudioManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.example.meeting_silencer/ringer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setRingerMode" -> {
                        val mode = call.argument<String>("mode")
                        val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
                        val notificationManager =
                            getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                        // Changing ringer mode requires Do Not Disturb access.
                        // Without this check the assignment below throws a
                        // SecurityException on fresh installs (TC-10 crash).
                        if (!notificationManager.isNotificationPolicyAccessGranted) {
                            result.error(
                                "DND_PERMISSION_DENIED",
                                "Do Not Disturb access not granted",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        try {
                            when (mode) {
                                "silent"  -> audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                                "vibrate" -> audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
                                "normal"  -> audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                                else -> {
                                    result.error("INVALID_MODE", "Unknown mode: $mode", null)
                                    return@setMethodCallHandler
                                }
                            }
                            result.success(null)
                        } catch (e: SecurityException) {
                            // Safety net in case the permission is revoked mid-call
                            result.error("DND_PERMISSION_DENIED", e.message, null)
                        }
                    }
                    // Lets Flutter ask whether DND access is granted
                    "hasDndAccess" -> {
                        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                        result.success(nm.isNotificationPolicyAccessGranted)
                    }
                    // Opens the system screen where the user can grant DND access
                    "openDndSettings" -> {
                        startActivity(Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
