package com.onlyoffice.projects

import android.animation.Animator
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        println("other message")
        super.onCreate(savedInstanceState)

    }

    override fun provideSplashScreen(): SplashScreen {
        println("other message")
        return MainSplashScreen(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        Log.d("t" ,"other message")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}


internal class MainSplashScreen(private val context: Activity) : SplashScreen {

    private var splashView: DrawableSplashScreen.DrawableSplashScreenView? = null

    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View {
        val drawable = ContextCompat.getDrawable(context, R.drawable.launch_background)
        splashView = DrawableSplashScreen.DrawableSplashScreenView(context).apply {
            setSplashDrawable(
                drawable,
                ImageView.ScaleType.FIT_XY
            )
        }
        return splashView as DrawableSplashScreen.DrawableSplashScreenView
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        context.window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)

        splashView
            ?.animate()
            ?.alpha(0.0f)
            ?.setDuration(500)
            ?.setListener(
                object : Animator.AnimatorListener {
                    override fun onAnimationStart(animation: Animator) {}
                    override fun onAnimationEnd(animation: Animator) {
                        onTransitionComplete.run()
                        splashView?.visibility = View.GONE
                    }

                    override fun onAnimationCancel(animation: Animator) {
                        onTransitionComplete.run()
                    }

                    override fun onAnimationRepeat(animation: Animator) {}
                }) ?: run {
            onTransitionComplete.run()
        }
    }

}