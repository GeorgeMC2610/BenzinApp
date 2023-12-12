package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.Malfunction;
import com.georgemc2610.benzinapp.classes.Service;

public class ActivityEditService extends AppCompatActivity
{
    Service service;
    EditText atKmView, descView, nextKmView, costView;
    TextView datePickedView;
    int mMonth, mYear, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_service);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.title_edit_record));
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // get views
        atKmView = findViewById(R.id.editTextEditServiceAtKilometers);
        descView = findViewById(R.id.editTextEditServiceDescription);
        nextKmView = findViewById(R.id.editTextEditServiceNextKm);
        costView = findViewById(R.id.editTextEditServiceCost);
        datePickedView = findViewById(R.id.textViewEditServiceDatePicked);

        // get the fuel fill record passed to edit.
        service = (Service) getIntent().getSerializableExtra("service");

        // set the views' texts
        atKmView.setText(String.valueOf(service.getAtKm()));
        descView.setText(service.getDescription());
        nextKmView.setText(String.valueOf(service.getNextKm()));
        costView.setText(String.valueOf(service.getCost()));
        datePickedView.setText(service.getDateHappened().toString());
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