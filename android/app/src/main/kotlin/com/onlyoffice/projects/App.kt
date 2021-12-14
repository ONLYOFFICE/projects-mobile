package com.onlyoffice.projects

import android.content.Context
import com.onlyoffice.projects.utils.AccountUtils
import com.onlyoffice.projects.utils.PackagesUtils
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {

    var accountUtils: AccountUtils? = null

    override fun onCreate() {
        super.onCreate()
        accountUtils = AccountUtils(this)
        if (PackagesUtils.isPackageExist(this, "com.onlyoffice.documents")) {
            // Check
        }
    }
}

val Context.accountUtils: AccountUtils?
    get() = when (this) {
        is App -> this.accountUtils
        else -> applicationContext.accountUtils
    }