package com.onlyoffice.projects.db

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.onlyoffice.projects.utils.CryptUtils
import kotlinx.serialization.Serializable
import org.json.JSONObject

@Entity
@Serializable
data class CloudAccount(
    @PrimaryKey
    val id: String,
    val login: String? = null,
    val portal: String? = null,
    val serverVersion: String = "",
    val scheme: String? = null,
    val name: String? = null,
    val provider: String? = null,
    val avatarUrl: String? = null,
    val isSslCiphers: Boolean = false,
    val isSslState: Boolean = true,
    val isOnline: Boolean = false,
    val isWebDav: Boolean = false,
    val isOneDrive: Boolean = false,
    val isDropbox: Boolean = false,
    val webDavProvider: String? = null,
    val webDavPath: String? = null,
    val isAdmin: Boolean = false,
    val isVisitor: Boolean = false
) {

    var token: String = ""

    var password: String = ""

    var expires: String = ""

    fun getAccountName() = "$login@$portal"

    fun getDecryptToken() = CryptUtils.decryptAES128(token, id)

    fun getDecryptPassword() = CryptUtils.decryptAES128(password, id)

    companion object {

        fun toString(account: CloudAccount): String {
            val json = JSONObject()
            json.put(CloudAccount::id.name, account.id)
            json.put(CloudAccount::login.name, account.login)
            json.put(CloudAccount::portal.name, account.portal)
            json.put(CloudAccount::serverVersion.name, account.serverVersion)
            json.put(CloudAccount::scheme.name, account.scheme)
            json.put(CloudAccount::name.name, account.name)
            json.put(CloudAccount::avatarUrl.name, account.avatarUrl)
            json.put(CloudAccount::isSslCiphers.name, account.isSslCiphers)
            json.put(CloudAccount::isSslState.name, account.isSslState)
            json.put(CloudAccount::isOnline.name, account.isOnline)
            json.put(CloudAccount::isWebDav.name, account.isWebDav)
            json.put(CloudAccount::isOneDrive.name, account.isOneDrive)
            json.put(CloudAccount::isDropbox.name, account.isDropbox)
            json.put(CloudAccount::isAdmin.name, account.isAdmin)
            json.put(CloudAccount::isVisitor.name, account.isVisitor)
            json.put(CloudAccount::password.name, account.password)
            json.put(CloudAccount::token.name, account.token)
            json.put(CloudAccount::expires.name, account.expires)
            return json.toString()
        }

        fun toObject(string: String): CloudAccount {
            val json = JSONObject(string)
            return CloudAccount(
                id = json.getString(CloudAccount::id.name),
                login = json.getString(CloudAccount::login.name),
                portal = json.getString(CloudAccount::portal.name),
                serverVersion = json.getString(CloudAccount::serverVersion.name),
                scheme = json.getString(CloudAccount::scheme.name),
                name = json.getString(CloudAccount::name.name),
                avatarUrl = json.getString(CloudAccount::avatarUrl.name),
                isSslCiphers = json.getString(CloudAccount::isSslCiphers.name) == "1",
                isSslState = json.getString(CloudAccount::isSslState.name) == "1",
                isOnline = json.getString(CloudAccount::isOnline.name) == "1",
                isWebDav = json.getString(CloudAccount::isWebDav.name) == "1",
                isOneDrive = json.getString(CloudAccount::isOneDrive.name) == "1",
                isDropbox = json.getString(CloudAccount::isDropbox.name) == "1",
                isAdmin = json.getString(CloudAccount::isAdmin.name) == "1",
                isVisitor = json.getString(CloudAccount::isVisitor.name) == "1",
            ).apply {
                token = json.getString(CloudAccount::token.name)
                password = json.getString(CloudAccount::password.name)
                expires = json.getString(CloudAccount::expires.name)
            }
        }
    }

}