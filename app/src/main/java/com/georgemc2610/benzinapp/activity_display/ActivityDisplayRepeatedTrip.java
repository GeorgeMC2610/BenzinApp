package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;

public class ActivityDisplayRepeatedTrip extends AppCompatActivity
{
    TextView title, timesRepeating, trip, km, cost, lt;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_repeated_trip);

        // get views
        title = findViewById(R.id.display_repeated_trip_text_view_title);
        timesRepeating = findViewById(R.id.display_repeated_trip_text_view_times_repeating);
        trip = findViewById(R.id.display_repeated_trip_text_view_from_origin_to_destination);
        km = findViewById(R.id.display_repeated_trip_text_view_total_km);
        cost = findViewById(R.id.display_repeated_trip_text_view_total_cost);
        lt = findViewById(R.id.display_repeated_trip_text_view_total_lt);
    }
}