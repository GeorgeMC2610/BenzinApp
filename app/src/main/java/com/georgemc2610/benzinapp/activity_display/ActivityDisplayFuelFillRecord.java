package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.activity_edit.ActivityEditRecord;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.NightModeTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.Locale;

public class ActivityDisplayFuelFillRecord extends AppCompatActivity
{
    TextView date, petrolType, cost, liters, kilometers, lt_per_100, km_per_lt, cost_per_km, notes;
    FuelFillRecord record;
    CardView delete, edit;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_fuel_fill_record);

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
        delete = findViewById(R.id.buttonDelete);
        edit = findViewById(R.id.buttonEdit);

        // action bar with back button and correct title name.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_display_data));

        // formats for decimal numbers.
        NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());
        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        // station string is different
        String station;
        if (record.getStation() == null || record.getStation().isEmpty())
        {
            if (record.getFuelType() == null || record.getFuelType().isEmpty())
            {
                station = getString(R.string.unspecified);
                petrolType.setTextColor(NightModeTool.getRedColor(this));
            }
            else
                station = record.getFuelType();
        }
        else
        {
            if (record.getFuelType() == null || record.getFuelType().isEmpty())
                station = record.getStation();

            else
                station = record.getFuelType() + ", " + record.getStation();
        }

        // string values assigned to the text views.
        String cost        = '€' + decimalFormat.format(record.getCost_eur());
        String liters      = numberFormat.format(record.getLiters()) + ' ' + getString(R.string.lt_short);
        String kilometers  = numberFormat.format(record.getKilometers()) + ' ' + getString(R.string.km_short);
        String lt_per_100  = numberFormat.format(record.getLt_per_100km()) + ' ' + getString(R.string.lt_short) + "/100 " + getString(R.string.km_short);
        String km_per_lt   = numberFormat.format(record.getKm_per_lt()) + ' ' + getString(R.string.km_short) + '/' + getString(R.string.lt_short);
        String cost_per_km = '€' + decimalFormat.format(record.getCostEur_per_km()) + '/' + getString(R.string.km_short);
        String date        = record.getDate().format(DateTimeFormatter.ofPattern("eeee, d MMMM yyyy"));

        // set values
        this.date.setText(date);
        petrolType.setText(station);
        this.cost.setText(cost);
        this.liters.setText(liters);
        this.kilometers.setText(kilometers);
        this.lt_per_100.setText(lt_per_100);
        this.km_per_lt.setText(km_per_lt);
        this.cost_per_km.setText(cost_per_km);
        this.notes.setText(record.getNotes());

        // notes might not be present.
        if (record.getNotes().length() == 0)
        {
            // TODO: Replace with String Value.
            this.notes.setText("No notes added.");
            this.notes.setTextColor(getColor(R.color.light_gray));
            this.notes.setTypeface(notes.getTypeface(), Typeface.ITALIC);
        }
        // TODO: Add case for excess notes text.

        // assign listeners to the buttons
        delete.setOnClickListener(this::onButtonDeleteClicked);
        edit.setOnClickListener(this::onButtonEditClicked);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        if (item.getItemId() == android.R.id.home)
        {
            finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void onButtonDeleteClicked(View view)
    {
        // build a confirmation dialog
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);

        dialog.setTitle(getString(R.string.dialog_delete_title));
        dialog.setMessage(getString(R.string.dialog_delete_confirmation));

        // when the button yes is clicked
        dialog.setPositiveButton(getString(R.string.dialog_yes), (dialog1, which) ->
        {
            // delete the record by its id.
            RequestHandler.getInstance().DeleteFuelFillRecord(ActivityDisplayFuelFillRecord.this, record.getId());

            // then close this activity
            finish();
        });

        // when the button no is clicked
        dialog.setNegativeButton(getString(R.string.dialog_no), (dialog12, which) ->
        {
            // do nothing
        });

        dialog.setCancelable(true);
        dialog.create().show();
    }

    public void onButtonEditClicked(View v)
    {
        Intent intent = new Intent(this, ActivityEditRecord.class);
        intent.putExtra("record", record);
        startActivity(intent);
    }
}