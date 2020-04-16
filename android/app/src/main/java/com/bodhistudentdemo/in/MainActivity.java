package com.bodhistudentdemo.in;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.view.WindowManager;


public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
     getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE,
                           WindowManager.LayoutParams.FLAG_SECURE);
    //GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
