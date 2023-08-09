package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.EditText;

import com.georgemc2610.benzinapp.classes.FuelFillRecord;

public class ActivityEditRecord extends AppCompatActivity
{
    private FuelFillRecord record;
    private EditText editTextLiters, editTextCost, editTextKilometers, editTextDate, editTextPetrolType, editTextStation, editTextNotes;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // necessary code for activity creation.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_record);

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
    }

    
}