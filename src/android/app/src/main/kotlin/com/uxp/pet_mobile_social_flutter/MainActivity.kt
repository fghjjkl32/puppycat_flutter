package com.uxp.pet_mobile_social_flutter

import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.Intent.URI_INTENT_SCHEME
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import java.net.URISyntaxException
import android.view.WindowManager.LayoutParams

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "puppycat-ch"
    var methodChannelResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", "transparent")
        super.onCreate(savedInstanceState)
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result;
            if (call.method == "getAppUrl") {
                try {
                    val url: String? = call.argument("url")
                    if (url != null) {
                        Log.i("url", url)
                    }
                    val intent: Intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
                    result.success(intent.getDataString())
                } catch (e: URISyntaxException) {
                    result.notImplemented()
                } catch (e: ActivityNotFoundException) {
                    result.notImplemented()
                }
            } else if(call.method == "getMarketUrl") {
                try {
                    val url: String? = call.argument("url")
                    Log.i("url", url!!)
                    val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
                    val scheme = intent.scheme
                    val packageName = intent.getPackage()
                    if (packageName != null) {
                        result.success("market://details?id=$packageName")
                    } else {
                        result.notImplemented()
                    }
                } catch (e: URISyntaxException) {
                    result.notImplemented()
                } catch (e: ActivityNotFoundException) {
                    result.notImplemented()
                }
            }
        }
    }
}
