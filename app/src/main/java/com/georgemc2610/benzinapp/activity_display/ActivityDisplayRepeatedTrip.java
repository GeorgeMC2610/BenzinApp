package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;

public class ActivityDisplayRepeatedTrip extends AppCompatActivity
{
    TextView title, timesRepeating, trip, km, cost, lt;
    RepeatedTrip repeatedTrip;

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


        // get the serializable object
        repeatedTrip = (RepeatedTrip) getIntent().getSerializableExtra("repeated_trip");

        // PREPEI NA TA KANW KALYTERA, ALLA AYTO THA GINEI ARGOTERA OK?

        // set the views' texts
        title.setText(repeatedTrip.getTitle());
        timesRepeating.setText("Repeating " + repeatedTrip.getTimesRepeating() + " times per week.");
        trip.setText(repeatedTrip.getOrigin());
        km.setText(repeatedTrip.getTotalKm() + " km trip");
        cost.setText("€" + repeatedTrip.getTotalCostEur(DataHolder.getInstance().car) * repeatedTrip.getTimesRepeating() + "()");
        lt.setText(repeatedTrip.getTotalLt(DataHolder.getInstance().car) * repeatedTrip.getTimesRepeating() + " lt ()");

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