package com.georgemc2610.benzinapp;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import java.time.LocalDate;

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

    public void DisplayCards(LinearLayout layout, LayoutInflater inflater)
    {
        String query = "SELECT * FROM BENZINAPP";
        Cursor cursor = DB.rawQuery(query, null);

        while (cursor.moveToNext())
        {
            View v = inflater.inflate(R.layout.cardview_fill, null);

            TextView petrolType = v.findViewById(R.id.card_filled_petrol);
            petrolType.setText(cursor.getString(4) + " per 100km");

            TextView cost = v.findViewById(R.id.card_cost);
            cost.setText(cursor.getString(2));

            TextView date = v.findViewById(R.id.card_date);
            date.setText(cursor.getString(7));

            layout.addView(v);
        }

        cursor.close();


    }
}
