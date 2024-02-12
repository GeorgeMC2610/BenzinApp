package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;

import android.location.Address;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;

public class ActivityEditRepeatedTrip extends AppCompatActivity
{
    private EditText title, timesRepeating;
    private CheckBox isRepeating;
    private Button selectTrip;
    private TextView trip, totalKm;
    private Address originAddress, destinationAddress;
    private float km;
    private String encodedTrip, jsonTrip;
    private RepeatedTrip repeatedTrip;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_repeated_trip);

        // get the views.
        title = findViewById(R.id.edit_repeated_trips_edit_text_title);
        timesRepeating = findViewById(R.id.edit_repeated_trips_edit_text_times_repeating);
        isRepeating = findViewById(R.id.edit_repeated_trips_checkbox_not_repeating);
        trip = findViewById(R.id.edit_repeated_trips_text_view_origin);
        selectTrip = findViewById(R.id.edit_repeated_trips_button_origin);
        totalKm = findViewById(R.id.edit_repeated_trips_text_view_kilometers);

        // initialize repeated trip
        repeatedTrip = (RepeatedTrip) getIntent().getSerializableExtra("repeatedTrip");
        isRepeating.setOnCheckedChangeListener(this::onCheckedChanged);

        // set the views' values
        title.setText(repeatedTrip.getTitle());
        timesRepeating.setText(String.valueOf(repeatedTrip.getTimesRepeating()));
        isRepeating.setChecked(repeatedTrip.getTimesRepeating() == 1);
        totalKm.setText(String.valueOf(repeatedTrip.getTotalKm()));

        // actionbar
        DisplayActionBarTool.displayActionBar(this, "Edit Trip");
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

    private void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        timesRepeating.setText(isChecked? "1" : "");
        timesRepeating.setEnabled(!isChecked);
    }
}