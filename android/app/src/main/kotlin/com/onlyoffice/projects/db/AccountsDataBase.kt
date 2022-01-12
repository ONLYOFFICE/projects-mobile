package com.onlyoffice.projects.db

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(entities = [CloudAccount::class], version = 1)
abstract class AccountsDataBase : RoomDatabase() {

    abstract val accountsDao: AccountsDao

}