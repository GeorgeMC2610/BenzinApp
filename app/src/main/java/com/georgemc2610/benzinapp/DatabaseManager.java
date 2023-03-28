package com.georgemc2610.benzinapp;

import android.database.sqlite.SQLiteDatabase;

import androidx.annotation.Nullable;

public class DatabaseManager
{
    private static DatabaseManager instance;
    private SQLiteDatabase DB;

    private DatabaseManager(SQLiteDatabase DB)
    {
        this.DB = DB;
    }

    public static DatabaseManager getInstance(@Nullable SQLiteDatabase DB)
    {
        if (DB == null && instance == null)
            return null;

        if (instance == null)
            instance = new DatabaseManager(DB);

        return instance;
    }

    public String sayHello()
    {
        return DB.toString();
    }
}
