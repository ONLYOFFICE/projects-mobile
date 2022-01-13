package com.onlyoffice.projects

import android.animation.Animator
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    override fun provideSplashScreen(): SplashScreen {
        return MainSplashScreen(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "accountProvider").setMethodCallHandler { call, result ->
            when (call.method) {
                "getAccounts" -> getAccounts(result)
                "addAccount" -> addAccount(call, result)
                "deleteAccount" -> deleteAccount(call, result)

                else -> result.notImplemented()
            }
        }
    }

    private fun getAccounts(result: Result) {
        val accounts = this.applicationContext.accountUtils!!.getAccounts()
        val list = mutableListOf<HashMap<String, String>>()
        for (account in accounts) {
            list.add(
                hashMapOf(
                    "account" to account,
                )
            )
        }
        result.success(list)

    }

    private fun addAccount(call: MethodCall, result: Result) {
        val accountId = call.argument<String>("accountId")
        val accountData = call.argument<String>("accountData")

        val account = this.applicationContext.accountUtils!!.addAccount(accountId, accountData)

        val wasAdded = account != null
        result.success(wasAdded)
    }

    private fun deleteAccount(call: MethodCall, result: Result) {
        val accountId = call.argument<String>("accountId")
        val accountData = call.argument<String>("accountData")


        this.applicationContext.accountUtils!!.deleteAccount(accountId, accountData)

        result.success(true)
    }

    private fun updateAccount(call: MethodCall, result: Result) {
        val accountId = call.argument<String>("accountId")
        val accountData = call.argument<String>("accountData")

        this.applicationContext.accountUtils!!.updateAccount(accountId, accountData)

        result.success(true)
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