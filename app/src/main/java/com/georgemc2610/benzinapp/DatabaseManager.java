package com.georgemc2610.benzinapp;

import android.database.sqlite.SQLiteDatabase;

import androidx.annotation.Nullable;

import java.time.LocalDateTime;

public class DatabaseManager
{
    private static DatabaseManager instance;
    private SQLiteDatabase DB;

    private DatabaseManager(SQLiteDatabase DB)
    {
        this.DB = DB;
        // DB.execSQL("DROP TABLE IF EXISTS BENZINAPP;");
        DB.execSQL("CREATE TABLE IF NOT EXISTS BENZINAPP (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "liters REAL NOT NULL," +
                "cost REAL NOT NULL," +
                "kilometers REAL NOT NULL," +
                "lt_per_hundred REAL NOT NULL," +
                "km_per_lt REAL NOT NULL," +
                "eur_per_km REAL NOT NULL," +
                "timestamp DATETIME NOT NULL);");
    }

    public static DatabaseManager getInstance(@Nullable SQLiteDatabase DB)
    {
        if (DB == null && instance == null)
            return null;

        if (instance == null)
            instance = new DatabaseManager(DB);

        return instance;
    }

    
    public void AddRecord(float liters, float cost, float kilometers)
    {
        float lt_per_hundred = 100 * liters / kilometers;
        float km_per_lt = kilometers/liters;
        float eur_per_km = cost/kilometers;

        String query = "INSERT INTO BENZINAPP (liters, cost, kilometers, lt_per_hundred, km_per_lt, eur_per_km, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Object[] bindArgs = new Object[] { liters, cost, kilometers, lt_per_hundred, km_per_lt, eur_per_km, LocalDateTime.now()};

        DB.execSQL(query, bindArgs);
    }
}
