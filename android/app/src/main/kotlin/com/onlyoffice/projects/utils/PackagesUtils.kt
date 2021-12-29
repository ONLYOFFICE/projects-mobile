package com.onlyoffice.projects.utils

import android.app.Application

object PackagesUtils {

    fun isPackageExist(context: Application, packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (error: Throwable) {
            false
        }
    }

}