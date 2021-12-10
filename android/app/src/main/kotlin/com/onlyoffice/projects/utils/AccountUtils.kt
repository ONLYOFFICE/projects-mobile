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

    fun getAccounts(): Array<String> {
        val cursor = context.contentResolver.query(Uri.parse("content://$AUTHORITY/$ACCOUNTS"), null, null, null, null)
        val accounts: Array<String> = parseAccounts(cursor)
        cursor?.close()
        return accounts
    }

    fun addAccount(id: String): String {
        val cursor =
            context.contentResolver.query(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), null, null, null, null)
        val accounts: Array<String> = parseAccounts(cursor)
        cursor?.close()
        return accounts[0]
    }

    fun updateAccount(id: String, contentValues: ContentValues? = null, bundle: Bundle? = null) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            context.contentResolver.update(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues, bundle)
        } else {
            context.contentResolver.update(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), contentValues, null, null)
        }
    }

    fun deleteAccount(id: String) {
        context.contentResolver.delete(Uri.parse("content://$AUTHORITY/$ACCOUNTS/$id"), null, null)
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

}