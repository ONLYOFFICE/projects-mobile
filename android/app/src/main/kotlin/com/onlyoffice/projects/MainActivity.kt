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
import com.onlyoffice.projects.utils.AccountUtils
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    override fun provideSplashScreen(): SplashScreen {
        return MainSplashScreen(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "accountProvider").setMethodCallHandler {
        call, result ->
            when (call.method) {
                "getAccounts" -> getAccounts(result)
                "addAccount" -> addAccount(call, result)

                else -> result.notImplemented()
            }
        }
    }

    private fun getAccounts(result: Result) {
         val accounts = AccountUtils(this.applicationContext).getAccounts()
         val list = mutableListOf<HashMap<String, String>>()
         for (account in accounts) {
             list.add(hashMapOf(
                     "account" to account,
             ))
         }
         result.success(list)
        
    }

    private fun addAccount(call: MethodCall, result: Result) {
         var accountId = call.argument<String>("accountId")!!
         var accountData = call.argument<String>("accountData")!!

        //  val account = AccountUtils(this.applicationContext).addAccount(accountId, accountData)

         val account = AccountUtils(this.applicationContext).addAccount("7cc0a8f5-8aca-4f62-9a57-64fb94d2bfda", "{\"id\":\"7cc0a8f5-8aca-4f62-9a57-64fb94d2bfda\",\"login\":\"Blocked.Blocked@onlyoffice.io\",\"portal\":\"alexanderyuzhin.teamlab.info/\",\"serverVersion\":\"\",\"scheme\":\"\",\"name\":\"Blocked Blocked\",\"provider\":\"\",\"avatarUrl\":\"https://dylnrgbh910l3.cloudfront.net/studio/tag/i11.6.0.559/skins/default/images/default_user_photo_size_82-82.png?_=1240520617\",\"isSslCiphers\":\"\",\"isSslState\":\"\",\"isOnline\":\"\",\"isWebDav\":\"\",\"isOneDrive\":\"\",\"isDropbox\":\"\",\"isAdmin\":\"\",\"isVisitor\":\"\",\"token\":\"iqVKPV5WHDCriPTdIIp8oWyAzvl+KVfx3sGmldq8ISHk8dKaGVxDPoYLHPCT/W5+TFEi/ZbHtsiR4muX9DJ5VVDICwpVdj0eSR3QPXHhtPicSqjt1eAr0rOGZ7HulqNnJ22rHw0CsjgXvEMQUzuBuuVIa72pHYgLnYeFXI1cWmo=\",\"password\":\"\",\"expires\":\"2021-12-27T18:43:41.3673166Z\"}")

         val wasAdded = !account.isNullOrEmpty()
         result.success(wasAdded)
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