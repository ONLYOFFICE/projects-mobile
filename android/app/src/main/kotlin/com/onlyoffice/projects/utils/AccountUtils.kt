package com.onlyoffice.projects.utils

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Bundle
import org.json.JSONObject

class AccountUtils(private val context: Context) {

    companion object {
        const val AUTHORITY = "com.onlyoffice.accounts"
        const val ACCOUNTS = "accounts"
        const val TIME = "time"
    }

    fun getTimestamp(): Long {
        val cursor = context.contentResolver.query(Uri.parse("content://$AUTHORITY/$TIME"), null, null, null, null)
        val time = cursor?.extras?.let { bundle ->
            return@let bundle.getLong(TIME)
        } ?: run {
            return@run 0L
        }
        cursor?.close()
        return time
    }

    fun getAccounts(login: String? = null): Array<String> {
        val cursor = context.contentResolver.query(Uri.parse("content://$AUTHORITY/$ACCOUNTS"), null, null, arrayOf(login), null)
        val accounts: Array<String> = parseAccounts(cursor)
        cursor?.close()
        return accounts
    }

    fun addAccount(id: String, data: String): String {
        val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val bundle: Bundle = getBundle(data)
            context.contentResolver.insert(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), null, bundle)
        } else {
            val contentValues: ContentValues = getContentValues(data)
            context.contentResolver.insert(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues)
        }

        return uri?.toString() ?: ""
    }

    fun updateAccount(id: String, contentValues: ContentValues? = null, bundle: Bundle? = null) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            context.contentResolver.update(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues, bundle)
        } else {
            context.contentResolver.update(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues, null, null)
        }
    }

    fun deleteAccount(id: String? = null, data: String? = null) {
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

    private fun parseAccounts(cursor: Cursor?): Array<String> {
        cursor?.let {
            val arrayList: Array<String> = Array(size = cursor.count) { return@Array "" }
            while (cursor.moveToNext()) {
                val jsonObject = JSONObject()
                val names = cursor.columnNames
                repeat(cursor.columnCount) { index ->
                    if (cursor.getColumnName(index) == "token" || cursor.getColumnName(index) == "password") {
                        jsonObject.put(
                            names[index], CryptUtils.decryptAES128(
                                cursor.getString(index), cursor.getString(
                                    cursor.getColumnIndex(
                                        names[0]
                                    )
                                )
                            )
                        )
                    } else {
                        jsonObject.put(names[index], cursor.getString(index))

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
                    if (name == "token" || name == "password") {
                        bundle.putString(name, CryptUtils.encryptAES128(value, json.getString("id")))
                    } else {
                        bundle.putString(name, value)
                    }
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
                    if (name == "token" || name == "password") {
                        contentValues.put(name, CryptUtils.encryptAES128(value, json.getString("id")))
                    } else {
                        contentValues.put(name, value)
                    }
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

}