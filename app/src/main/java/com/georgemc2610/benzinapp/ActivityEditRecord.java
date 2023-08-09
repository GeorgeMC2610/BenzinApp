package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;

import com.georgemc2610.benzinapp.classes.FuelFillRecord;

public class ActivityEditRecord extends AppCompatActivity
{
    private FuelFillRecord record;
    private EditText editTextLiters, editTextCost, editTextKilometers, editTextDate, editTextPetrolType, editTextStation, editTextNotes;
    private Button buttonApply;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // necessary code for activity creation.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_record);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Edit Record");
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // get the fuel fill record passed to edit.
        record = (FuelFillRecord) getIntent().getSerializableExtra("record");

        // get edit texts.
        editTextLiters     = findViewById(R.id.editTextLitersEdit);
        editTextCost       = findViewById(R.id.editTextCostEdit);
        editTextKilometers = findViewById(R.id.editTextKilometersEdit);
        editTextPetrolType = findViewById(R.id.editTextPetrolTypeEdit);
        editTextDate       = findViewById(R.id.editTextDateEdit);
        editTextStation    = findViewById(R.id.editTextStationEdit);
        editTextNotes      = findViewById(R.id.editTextNotesEdit);

        // apply text to the edit texts.
        editTextLiters    .setText(String.valueOf(record.getLiters()));
        editTextCost      .setText(String.valueOf(record.getCost_eur()));
        editTextKilometers.setText(String.valueOf(record.getKilometers()));
        editTextPetrolType.setText(String.valueOf(record.getFuelType()));
        editTextDate      .setText(String.valueOf(record.getDate()));
        editTextStation   .setText(record.getStation());
        editTextNotes     .setText(record.getNotes());

        // lock some properties.
        editTextDate.setEnabled(false);

        // get the button and set its listener.
        buttonApply = findViewById(R.id.buttonApplyEdits);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        // once the back button is pressed, close the activity.
        if (item.getItemId() == android.R.id.home)
        {
            finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    
}