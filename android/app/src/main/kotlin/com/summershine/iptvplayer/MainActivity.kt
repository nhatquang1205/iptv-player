package com.summershine.iptvplayer

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register the Native Ad Factory correctly
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, 
            "listTile", 
            ListTileNativeAdFactory(this)
        )
    }

    override fun onDestroy() {
        super.onDestroy()
        
        // Unregister the Native Ad Factory using flutterEngine
        flutterEngine?.let {
            GoogleMobileAdsPlugin.unregisterNativeAdFactory(it, "listTile")
        }
    }
}
