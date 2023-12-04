package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.ui.history.HistoryFragment;

public class ActivityDisplayData extends AppCompatActivity
{
    TextView date, petrolType, cost, liters, kilometers, lt_per_100, km_per_lt, cost_per_km, notes;
    FuelFillRecord record;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_data);

        // for record retrieval
        record = (FuelFillRecord) getIntent().getSerializableExtra("record");

        // initialize views.
        date = findViewById(R.id.textView_Date);
        petrolType = findViewById(R.id.textView_PetrolType);
        cost = findViewById(R.id.textView_Cost);
        liters = findViewById(R.id.textView_Liters);
        kilometers = findViewById(R.id.textView_Kilometers);
        lt_per_100 = findViewById(R.id.textView_LitersPer100Kilometers);
        km_per_lt = findViewById(R.id.textView_KilometersPerLiter);
        cost_per_km = findViewById(R.id.textView_CostPerKilometer);
        notes = findViewById(R.id.textView_Notes);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.title_display_data));
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // set values
        date.setText(record.getDate().toString());
        petrolType.setText(record.getFuelType() + ", " + record.getStation());
        cost.setText("€" + record.getCost_eur());
        liters.setText(record.getLiters() + " lt");
        kilometers.setText(record.getKilometers() + " km");
        lt_per_100.setText(record.getLt_per_100km() + " lt/100 km");
        km_per_lt.setText(record.getKm_per_lt() + " km/lt");
        cost_per_km.setText("€" + record.getCostEur_per_km() + "/km");
        notes.setText(record.getNotes());
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {
            case android.R.id.home:
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void OnButtonDeleteClicked(View view)
    {
        // build a confirmation dialog
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);

        dialog.setTitle(getString(R.string.dialog_delete_title));
        dialog.setMessage(getString(R.string.dialog_delete_confirmation));

        // when the button yes is clicked
        dialog.setPositiveButton(getString(R.string.dialog_yes), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // delete the record by its id.
                RequestHandler.getInstance().DeleteFuelFillRecord(ActivityDisplayData.this, record.getId());

                // then close this activity
                finish();
            }
        });

        // when the button no is clicked
        dialog.setNegativeButton(getString(R.string.dialog_no), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // do nothing
            }
        });

        dialog.setCancelable(true);
        dialog.create().show();
    }
}