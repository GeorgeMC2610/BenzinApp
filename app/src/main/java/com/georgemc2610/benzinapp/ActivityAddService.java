package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class ActivityAddService extends AppCompatActivity
{
    EditText atKm, nextKm, costEur, notes;
    TextView location, date;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_service);

        // get edit texts and text views.
        atKm = findViewById(R.id.editTextServiceAtKilometers);
        nextKm = findViewById(R.id.editTextServiceNextKm);
        costEur = findViewById(R.id.editTextServiceCost);
        notes = findViewById(R.id.editTextServiceDescription);
        location = findViewById(R.id.textViewServiceLocation);
        date = findViewById(R.id.textViewServiceDatePicked);

        // action bar
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Add Service");
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }
    }

    public void OnButtonAddClicked(View v)
    {
        boolean validated = true;

        // all of the following fields are required. If any of those are not filled, display an error.
        if (atKm.getText().toString().trim().length() == 0)
        {
            atKm.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (notes.getText().toString().trim().length() == 0)
        {
            notes.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        System.out.println("WHAT THERE IS: " + date.getText().toString().trim());
        System.out.println("WHAT WE WANT:" + getString(R.string.edit_text_datetime_hint));

        if (date.getText().toString().trim().equals(getString(R.string.text_view_select_date)))
        {
            Toast.makeText(this, "Please select a date.", Toast.LENGTH_LONG).show();
            validated = false;
        }

        if (!validated)
            return;

        Toast.makeText(this, "Proceeding...", Toast.LENGTH_SHORT).show();
    }
}