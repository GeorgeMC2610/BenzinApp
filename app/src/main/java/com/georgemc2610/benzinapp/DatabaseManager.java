package com.georgemc2610.benzinapp;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.w3c.dom.Text;

import java.time.LocalDate;
import java.util.zip.Inflater;

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

    /**
     * Displays all records with all the details in the cardview_fill.xml file. Gives life to the buttons and cards
     * can be clicked to see more information. Orders by the timestamp propery.
     * @param layout The linear layout (from a scroll view) to display the records.
     * @param inflater The inflater to make the cards.
     */
    public void DisplayCards(LinearLayout layout, LayoutInflater inflater, TextView hint)
    {
        // first, remove all views.
        layout.removeAllViews();

        hint.setText(layout.getContext().getResources().getString(R.string.text_view_click_cards_message_empty));

        // initialize db query.
        String query = "SELECT * FROM BENZINAPP ORDER BY timestamp DESC;";
        Cursor cursor = DB.rawQuery(query, null);

        // go through all queries
        while (cursor.moveToNext())
        {
            // inflate the card
            View v = inflater.inflate(R.layout.cardview_fill, null);

            // initialize all text views
            TextView petrolType = v.findViewById(R.id.card_filled_petrol);
            petrolType.setText(cursor.getString(8));

            TextView idHidden = v.findViewById(R.id.card_hidden_id);
            idHidden.setText(cursor.getString(0));

            // TODO: Replace hardcoded strings.
            TextView lt_per_100 = v.findViewById(R.id.card_lt_per_100);
            lt_per_100.setText(cursor.getString(4) + " lt/100km");

            TextView cost = v.findViewById(R.id.card_cost);
            cost.setText("€" + cursor.getString(2));

            TextView date = v.findViewById(R.id.card_date);
            date.setText(cursor.getString(7));

            // give life to the buttons
            FloatingActionButton deleteButton = v.findViewById(R.id.card_buttonDelete);
            deleteButton.setOnClickListener(new DeleteButtonListener(layout.getContext(), cursor.getInt(0), inflater, layout, hint));

            // set clickable view
            v.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    Intent intent = new Intent(layout.getContext(), ActivityDisplayData.class);
                    layout.getContext().startActivity(intent);
                }
            });

            hint.setText(layout.getContext().getResources().getString(R.string.text_view_click_cards_message));

            // and add the layout
            layout.addView(v);
        }

        cursor.close();
    }

    public void GetRecord(int id)
    {
        String query = "SELECT * FROM BENZINAPP WHERE id = '" + id + "';";
        Cursor cursor = DB.rawQuery(query, null);

        if (cursor.moveToNext())
        {

        }
    }

    /**
     * Deletes a record from the database, based on the primary key.
     * @param id The primary key (ID).
     */
    public void DeleteRecord(int id)
    {
        String query = "DELETE FROM BENZINAPP WHERE id = ?";
        Object[] bindArgs = new Object[] { id };

        DB.execSQL(query, bindArgs);
    }
}

/**
 * Internal class to handle most of the click listeners
 */
class DeleteButtonListener implements View.OnClickListener
{
    private Context context;
    private int id;
    private LinearLayout layout;
    private LayoutInflater inflater;
    private TextView hint;

    public DeleteButtonListener(Context context, int id, LayoutInflater inflater, LinearLayout layout, TextView hint)
    {
        this.context = context;
        this.id = id;
        this.inflater = inflater;
        this.layout = layout;
        this.hint = hint;
    }

    @Override
    public void onClick(View v)
    {
        AlertDialog.Builder dialog = new AlertDialog.Builder(this.context);

        dialog.setTitle(layout.getContext().getResources().getString(R.string.dialog_delete_title));
        dialog.setMessage(layout.getContext().getResources().getString(R.string.dialog_delete_confirmation));

        dialog.setPositiveButton(layout.getContext().getResources().getString(R.string.dialog_yes), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                DatabaseManager.getInstance(null).DeleteRecord(id);
                DatabaseManager.getInstance(null).DisplayCards(layout, inflater, hint);
                Toast.makeText(layout.getContext(), layout.getContext().getResources().getString(R.string.toast_record_deleted), Toast.LENGTH_LONG).show();
            }
        });

        dialog.setNegativeButton(layout.getContext().getResources().getString(R.string.dialog_no), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // foo
            }
        });

        dialog.setCancelable(true);

        dialog.create().show();
    }
}
