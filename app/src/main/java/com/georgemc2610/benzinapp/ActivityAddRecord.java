package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.motion.widget.Debug;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class ActivityAddRecord extends AppCompatActivity
{
    EditText editTextLiters;
    EditText editTextCost;
    EditText editTextKilometers;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_record);

        // get edit texts.
        editTextLiters = findViewById(R.id.editTextLiters);
        editTextCost = findViewById(R.id.editTextCost);
        editTextKilometers = findViewById(R.id.editTextKilometers);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getResources().getString(R.string.title_add_record));
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }
    }

    public void OnButtonAddClicked(View v)
    {
        int validation_counter = 0;

        // if either of the edit texts are empty, don't proceed.
        if (editTextCost.getText().toString().length() == 0)
        {
            editTextCost.setError(getResources().getString(R.string.error_field_cannot_be_empty));
            validation_counter--;
        }

        if (editTextLiters.getText().toString().length() == 0)
        {
            editTextLiters.setError(getResources().getString(R.string.error_field_cannot_be_empty));
            validation_counter--;
        }

        if (editTextKilometers.getText().toString().length() == 0)
        {
            editTextKilometers.setError(getResources().getString(R.string.error_field_cannot_be_empty));
            validation_counter--;
        }

        // there must be exactly two correct validations to proceed.
        if (validation_counter != 0)
            return;

        // proceed to add properties.
        Toast.makeText(this, "To be continued...", Toast.LENGTH_LONG).show();
    }
}