package com.georgemc2610.benzinapp.acitvity_add;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.georgemc2610.benzinapp.R;

public class ActivityAddRepeatedTrip extends AppCompatActivity
{
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_repeated_trip);

        // action bar
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.title_add_trip));
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }
    }
}