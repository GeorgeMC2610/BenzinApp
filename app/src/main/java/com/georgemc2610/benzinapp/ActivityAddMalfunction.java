package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.EditText;
import android.widget.TextView;

public class ActivityAddMalfunction extends AppCompatActivity
{
    EditText title, description, atKm;
    TextView date;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_malfunction);

        // retrieve edit texts and text view
        title = findViewById(R.id.editTextMalfunctionTitle);
        description = findViewById(R.id.editTextMalfunctionDesc);
        atKm = findViewById(R.id.editTextMalfunctionAtKm);
        date = findViewById(R.id.textViewMalfunctionDatePicked);
    }
}