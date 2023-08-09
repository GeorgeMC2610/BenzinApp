package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

import com.georgemc2610.benzinapp.classes.FuelFillRecord;

public class ActivityEditRecord extends AppCompatActivity
{
    private FuelFillRecord record;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // necessary code for activity creation.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_record);

        // get the fuel fill record passed to edit.
        record = (FuelFillRecord) getIntent().getSerializableExtra("record");
    }

    
}