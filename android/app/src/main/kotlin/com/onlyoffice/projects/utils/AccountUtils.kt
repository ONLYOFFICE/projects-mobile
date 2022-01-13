package com.onlyoffice.projects.utils

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Bundle
import com.onlyoffice.projects.accountsDao
import com.onlyoffice.projects.db.CloudAccount
import com.onlyoffice.projects.isDocumentInstalled
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.json.JSONObject
import java.lang.RuntimeException

class AccountUtils(private val context: Context) {

    companion object {
        const val AUTHORITY = "com.onlyoffice.accounts"
        const val ACCOUNTS = "accounts"
        const val TIME = "time"
    }

    fun getTimestamp(): Long {
        if (context.isDocumentInstalled) {
            val cursor = context.contentResolver.query(Uri.parse("content://$AUTHORITY/$TIME"), null, null, null, null)
            val time = cursor?.extras?.let { bundle ->
                return@let bundle.getLong(TIME)
            } ?: run {
                return@run 0L
            }
            cursor?.close()
            return time
        } else {
            return System.currentTimeMillis()
        }
    }

    fun getAccounts(login: String? = null): Array<String> {
        if (context.isDocumentInstalled) {
            val cursor = context.contentResolver.query(Uri.parse("content://$AUTHORITY/$ACCOUNTS"), null, null, arrayOf(login), null)
            val accounts: Array<String> = parseAccounts(cursor)
            cursor?.close()
            if (accounts.isNotEmpty()) {
                addAccountsToDb(accounts)
            }
            return accounts
        } else {
            return runBlocking {
                return@runBlocking context.accountsDao?.getAccounts()?.map { Json.encodeToString(it) }?.toTypedArray() ?: emptyArray()
            }
        }
    }

    fun addAccount(id: String?, data: String?): Long? {
        if (context.isDocumentInstalled) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val bundle: Bundle = getBundle(checkNotNull(data) { "Account data null" })
                context.contentResolver.insert(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), ContentValues(), bundle)
            } else {
                val contentValues: ContentValues = getContentValues(checkNotNull(data) { "Account data null" })
                context.contentResolver.insert(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues)
            }
        }
        return runBlocking {
            return@runBlocking context.accountsDao?.addAccount(Json.decodeFromString(checkNotNull(data) { "Account data null" }))
        }
    }

    fun updateAccount(id: String?, data: String?) {
        if (context.isDocumentInstalled) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val bundle: Bundle = getBundle(checkNotNull(data) { "Data null" })
                context.contentResolver.update(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), ContentValues(), bundle)
            } else {
                val contentValues: ContentValues = getContentValues(checkNotNull(data) { "Account data null" })
                context.contentResolver.update(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues, null, null)
            }
        }
        runBlocking {
            context.accountsDao?.updateAccount(Json.decodeFromString(checkNotNull(data) { "Account data null" }))
        }
    }


    fun deleteAccount(id: String? = null, data: String? = null) {
        if (context.isDocumentInstalled) {
            if (id != null) {
                context.contentResolver.delete(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), null, null)
            } else if (data != null) {
                val json = JSONObject(data)
                context.contentResolver.delete(
                    Uri.parse("content://$AUTHORITY/$ACCOUNTS/${json.getString("id")}"),
                    null,
                    null
                )
            }
        }
        runBlocking {
            when {
                id != null -> {
                    context.accountsDao?.getAccount(id)?.let { account ->
                        context.accountsDao?.deleteAccount(account)
                    }
                }
                data != null -> {
                    context.accountsDao?.deleteAccount(Json.decodeFromString(data))
                }
                else -> {
                    throw RuntimeException("id or data must not be null")
                }
            }
        }
    }

    private fun parseAccounts(cursor: Cursor?): Array<String> {
        cursor?.let {
            val arrayList: Array<String> = Array(size = cursor.count) { return@Array "" }
            while (cursor.moveToNext()) {
                val jsonObject = JSONObject()
                val names = cursor.columnNames
                repeat(cursor.columnCount) { index ->
                    when (cursor.getColumnName(index)) {
                        "token", "password" -> {
                            jsonObject.put(
                                names[index], CryptUtils.decryptAES128(
                                    cursor.getString(index), cursor.getString(
                                        cursor.getColumnIndex(
                                            names[0]
                                        )
                                    )
                                )
                            )
                        }
                        "isSslCiphers", "isSslState", "isOnline", "isWebDav", "isOneDrive", "isDropbox", "isAdmin", "isVisitor" -> {
                            jsonObject.put(names[index], cursor.getString(index) == "1")
                        }
                        else -> {
                            jsonObject.put(names[index], cursor.getString(index))
                        }
                    }
                }
                arrayList[cursor.position] = jsonObject.toString()
            }
            return arrayList
        } ?: run {
            return emptyArray()
        }
    }

    private fun getBundle(data: String): Bundle {
        val json = JSONObject(data)
        val bundle = Bundle(json.length())
        json.keys().forEach { name ->
            when (val value = json.get(name)) {
                is String -> {
                    bundle.putString(name, value)
                }
                is Boolean -> {
                    bundle.putBoolean(name, value)
                }
                is Int -> {
                    bundle.putInt(name, value)
                }
                is Long -> {
                    bundle.putLong(name, value)
                }
            }
        }
        return bundle
    }

    private fun getContentValues(data: String): ContentValues {
        val json = JSONObject(data)
        val contentValues = ContentValues(json.length())
        json.keys().forEach { name ->
            when (val value = json.get(name)) {
                is String -> {
                    contentValues.put(name, value)
                }
                is Boolean -> {
                    contentValues.put(name, value)
                }
                is Int -> {
                    contentValues.put(name, value)
                }
                is Long -> {
                    contentValues.put(name, value)
                }
            }
        }
        return contentValues
    }

    private fun addAccountsToDb(accounts: Array<String>) {
        runBlocking {
            context.accountsDao?.addAccounts(accounts.map { CloudAccount.toObject(it) })
        }
    }

}