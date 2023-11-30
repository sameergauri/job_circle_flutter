/* package com.job_circle_flutter


import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams 
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    window.addFlags(LayoutParams.FLAG_SECURE)
    super.configureFlutterEngine(flutterEngine)
  }
}
 */
package com.job_circle_flutter

import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity1 : FlutterActivity() {

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    window.addFlags(LayoutParams.FLAG_SECURE)
    super.configureFlutterEngine(flutterEngine)
  }
}

