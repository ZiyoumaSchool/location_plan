package com.example.localise

import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun provideSplashScreen(): SplashScreen? = SplashView()
}
