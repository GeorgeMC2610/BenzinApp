package com.georgemc2610.benzinapp;

import android.database.sqlite.SQLiteDatabase;
import androidx.annotation.Nullable;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class DatabaseManager
{
    private static DatabaseManager instance;
    private SQLiteDatabase DB;

    private DatabaseManager(SQLiteDatabase DB)
    {
        this.DB = DB;
        //DB.execSQL("DROP TABLE IF EXISTS BENZINAPP;");
        DB.execSQL("CREATE TABLE IF NOT EXISTS BENZINAPP (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "liters REAL NOT NULL," +
                "cost REAL NOT NULL," +
                "kilometers REAL NOT NULL," +
                "lt_per_hundred REAL NOT NULL," +
                "km_per_lt REAL NOT NULL," +
                "eur_per_km REAL NOT NULL," +
                "timestamp DATE NOT NULL, " +
                "fueltype TEXT);");
    }

    public static DatabaseManager getInstance(@Nullable SQLiteDatabase DB)
    {
        if (DB == null && instance == null)
            return null;

        if (instance == null)
            instance = new DatabaseManager(DB);

        return instance;
    }

    /**
     * Adds records to the database based on the data the user provided. <b>Automatically calculates
     * liters per hundred kilometers, kilometers per liter and cost per kilometer.</b>
     * @param liters Total liters filled in.
     * @param cost Cost in EUR.
     * @param kilometers Total kilometers travelled in one fill.
     */
    public void AddRecord(float liters, float cost, float kilometers, LocalDate date, String fueltype)
    {
        float lt_per_hundred = 100 * liters / kilometers;
        float km_per_lt = kilometers/liters;
        float eur_per_km = cost/kilometers;

        String query = "INSERT INTO BENZINAPP (liters, cost, kilometers, lt_per_hundred, km_per_lt, eur_per_km, timestamp, fueltype) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] bindArgs = new Object[] { liters, cost, kilometers, lt_per_hundred, km_per_lt, eur_per_km, date, fueltype };

        DB.execSQL(query, bindArgs);
    }
}
