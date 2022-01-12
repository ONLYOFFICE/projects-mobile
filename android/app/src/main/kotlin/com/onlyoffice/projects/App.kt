package com.onlyoffice.projects

import android.content.Context
import androidx.room.Room
import com.onlyoffice.projects.db.AccountsDao
import com.onlyoffice.projects.db.AccountsDataBase
import com.onlyoffice.projects.utils.AccountUtils
import com.onlyoffice.projects.utils.PackagesUtils
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {

    var accountUtils: AccountUtils? = null
    var accountsDb: AccountsDataBase? = null

    override fun onCreate() {
        super.onCreate()
        accountUtils = AccountUtils(this)
        accountsDb = Room.databaseBuilder(this, AccountsDataBase::class.java, AccountsDataBase::class.java.simpleName).build()
    }
}

@Suppress("RecursivePropertyAccessor")
val Context.accountUtils: AccountUtils?
    get() = when (this) {
        is App -> this.accountUtils
        else -> accountUtils
    }

@Suppress("RecursivePropertyAccessor")
val Context.accountsDao: AccountsDao?
    get() = when (this) {
        is App -> this.accountsDb?.accountsDao
        else -> accountsDao
    }

@Suppress("RecursivePropertyAccessor")
val Context.isDocumentInstalled: Boolean
    get() = when (this) {
        is App -> PackagesUtils.isPackageExist(this, "com.onlyoffice.documents")
        else -> isDocumentInstalled
    }