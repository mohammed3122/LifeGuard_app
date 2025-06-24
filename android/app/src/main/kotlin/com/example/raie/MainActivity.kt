package com.example.raie


import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.whatsapp/launch"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openWhatsApp") {
                val phone = call.argument<String>("phone")
                openWhatsApp(phone, result)
            }
        }
    }

    private fun openWhatsApp(phone: String?, result: MethodChannel.Result) {
        try {
            val url = "https://wa.me/$phone"
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse(url)
            intent.setPackage("com.whatsapp")
            if (intent.resolveActivity(packageManager) != null) {
                startActivity(intent)
                result.success(true)
            } else {
                // fallback to WhatsApp Business if normal not found
                intent.setPackage("com.whatsapp.w4b")
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    result.success(true)
                } else {
                    result.error("UNAVAILABLE", "WhatsApp not installed", null)
                }
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to launch WhatsApp: ${e.message}", null)
        }
    }
}
