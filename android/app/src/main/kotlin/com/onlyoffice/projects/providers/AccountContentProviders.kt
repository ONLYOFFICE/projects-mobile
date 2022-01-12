package com.onlyoffice.projects.providers

import android.content.ContentProvider
import android.content.ContentValues
import android.content.UriMatcher
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import com.onlyoffice.projects.accountsDao
import com.onlyoffice.projects.db.AccountsDao
import com.onlyoffice.projects.db.CloudAccount
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json

class AccountContentProviders : ContentProvider() {

    companion object {

        const val AUTHORITY = "com.onlyoffice.projects.accounts"
        const val PATH = "accounts"
        const val ID = "id"
        const val TIME = "time"

        const val ALL_ID = 0
        const val ACCOUNT_ID = 1
        const val TIME_ID = 2

        const val CLOUD_ACCOUNT_KEY = "account"
        const val TIME_KEY = "time"
    }

    private val uriMatcher: UriMatcher = UriMatcher(UriMatcher.NO_MATCH).apply {
        addURI(AUTHORITY, PATH, ALL_ID)
        addURI(AUTHORITY, "$PATH/*", ACCOUNT_ID)
        addURI(AUTHORITY, TIME, TIME_ID)
    }

    private val dao: AccountsDao?
        get() = context?.accountsDao

    override fun onCreate(): Boolean {
        return true
    }

    override fun query(
        uri: Uri,
        projection: Array<out String?>?,
        selection: String?,
        selectionArgs: Array<out String?>?,
        sortOrder: String?
    ): Cursor? {
        when (uriMatcher.match(uri)) {
            ALL_ID -> {
                return selectionArgs?.get(0)?.let { arg ->
                    dao?.getCursorAccountsByLogin(arg)
                } ?: run {
                    dao?.getCursorAccounts()
                }
            }
            ACCOUNT_ID -> {
                return dao?.getCursorAccount(uri.lastPathSegment ?: "")
            }

        }
        return null
    }

    override fun getType(uri: Uri): String {
        return CLOUD_ACCOUNT_KEY
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        val account: CloudAccount = if (values?.containsKey(CLOUD_ACCOUNT_KEY) == true) {
            Json.decodeFromString(values.getAsString("account") ?: "")
        } else {
            getAccount(values)
        }
        runBlocking {
            return@runBlocking dao?.addAccount(account)
        }
        return Uri.parse("content://$AUTHORITY/$PATH/${account.id}")
    }

    override fun insert(uri: Uri, values: ContentValues?, extras: Bundle?): Uri? {
        var id = ""
        extras?.let {
            if (extras.containsKey(CLOUD_ACCOUNT_KEY)) {
                val account: CloudAccount = Json.decodeFromString(extras.getString("account") ?: "")
                id = account.id
                runBlocking {
                    dao?.addAccount(account = account)
                }
            } else {
                val account: CloudAccount = getAccount(it)
                id = account.id
                runBlocking {
                    dao?.addAccount(account = account)
                }
            }
        }
        return Uri.parse("content://$AUTHORITY/$PATH/$id")
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int {
        when (uriMatcher.match(uri)) {
            ACCOUNT_ID -> {
                runBlocking {
                    dao?.getAccount(uri.lastPathSegment ?: "")?.let { account ->
                        return@let dao?.deleteCursorAccount(account)
                    }

                }
            }
        }
        return -1
    }

    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<out String>?): Int {
        return runBlocking {
            return@runBlocking dao?.updateCursorAccount(getAccount(values)) ?: -1
        }
    }

    private fun getAccount(values: ContentValues?): CloudAccount {
        return CloudAccount(
            id = values?.getAsString("id") ?: "",
            login = values?.getAsString("login"),
            portal = values?.getAsString("portal"),
            serverVersion = values?.getAsString("serverVersion") ?: "",
            scheme = values?.getAsString("scheme"),
            name = values?.getAsString("name"),
            provider = values?.getAsString("provider"),
            avatarUrl = values?.getAsString("avatarUrl"),
            isSslCiphers = values?.getAsBoolean("isSslCiphers") ?: false,
            isSslState = values?.getAsBoolean("isSslState") ?: true,
            isOnline = false,
            isWebDav = false,
            isOneDrive = false,
            isDropbox = false,
            isAdmin = values?.getAsBoolean("isAdmin") ?: false,
            isVisitor = values?.getAsBoolean("isVisitor") ?: false
        ).apply {
            token = values?.getAsString("token") ?: ""
            password = values?.getAsString("password") ?: ""
            expires = values?.getAsString("expires") ?: ""
        }
    }

    private fun getAccount(extras: Bundle): CloudAccount {
        return CloudAccount(
            id = extras.getString("id") ?: "",
            login = extras.getString("login"),
            portal = extras.getString("portal"),
            serverVersion = extras.getString("serverVersion") ?: "",
            scheme = extras.getString("scheme"),
            name = extras.getString("name"),
            provider = extras.getString("provider"),
            avatarUrl = extras.getString("avatarUrl"),
            isSslCiphers = extras.getBoolean("isSslCiphers", false),
            isSslState = extras.getBoolean("isSslState", true),
            isOnline = false,
            isWebDav = false,
            isOneDrive = false,
            isDropbox = false,
            isAdmin = extras.getBoolean("isAdmin", false),
            isVisitor = extras.getBoolean("isVisitor", false)
        ).apply {
            token = extras.getString("token") ?: ""
            password = extras.getString("password") ?: ""
            expires = extras.getString("expires") ?: ""
        }
    }

}