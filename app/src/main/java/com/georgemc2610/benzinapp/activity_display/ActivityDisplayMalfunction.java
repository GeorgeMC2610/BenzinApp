package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.icu.text.NumberFormat;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.Malfunction;

import java.util.Locale;

public class ActivityDisplayMalfunction extends AppCompatActivity
{
    TextView titleView, descriptionView, startedView, endedView, atKmView, costView;
    Malfunction malfunction;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize view
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_malfunction);

        // get number format
        NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

        // get text views
        titleView = findViewById(R.id.text_view_display_malfunction_title);
        descriptionView = findViewById(R.id.text_view_display_malfunction_desc);
        startedView = findViewById(R.id.text_view_display_malfunction_date_started);
        endedView = findViewById(R.id.text_view_display_malfunction_date_ended);
        atKmView = findViewById(R.id.text_view_display_malfunction_discovered_at_km);
        costView = findViewById(R.id.text_view_display_malfunction_cost);

        // get the serializable object
        malfunction = (Malfunction) getIntent().getSerializableExtra("malfunction");

        // set required views content
        titleView.setText(malfunction.getTitle());
        descriptionView.setText(malfunction.getDescription());
        startedView.setText(malfunction.getStarted().toString());
        atKmView.setText(numberFormat.format(malfunction.getAt_km()) + " " + getString(R.string.km_short));

        // set optional views content
        endedView.setText(malfunction.getEnded() == null? "-" : malfunction.getEnded().toString());
        costView.setText(malfunction.getCost() == 0f? "-" : String.valueOf(malfunction.getCost()));

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Malfunction Data"); // TODO: Replace with string value
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }
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
}