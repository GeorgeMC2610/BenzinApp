package com.georgemc2610.benzinapp.activity_edit;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.activity_maps.MapsCreateTripActivity;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.JSONCoordinatesTool;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityEditRepeatedTrip extends AppCompatActivity
{
    private EditText title, timesRepeating;
    private CheckBox isRepeating;
    private Button selectTrip;
    private TextView trip, totalKm;
    private Geocoder geocoder;
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

        // add the button listener
        selectTrip.setOnClickListener(this::onSelectTripClicked);

        // initialize geocoder.
        geocoder = new Geocoder(this);

        // set addresses to the trip.
        try
        {
            // json object with coordinates
            JSONObject jsonObject = new JSONObject(repeatedTrip.getOrigin());

            // newer api requires listener
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            {
                // for the origin.
                geocoder.getFromLocation(jsonObject.getJSONArray("origin_coordinates").getDouble(0), jsonObject.getJSONArray("origin_coordinates").getDouble(1), 1, addresses ->
                {
                    if (addresses.isEmpty())
                        return;

                    originAddress = addresses.get(0);
                    runOnUiThread(this::setTripTitle);
                });

                // for the destination
                geocoder.getFromLocation(jsonObject.getJSONArray("destination_coordinates").getDouble(0), jsonObject.getJSONArray("destination_coordinates").getDouble(1), 1, addresses ->
                {
                    if (addresses.isEmpty())
                        return;

                    destinationAddress = addresses.get(0);
                    runOnUiThread(this::setTripTitle);
                });
            }
            // older api runs on ui thread
            else
            {
                // retrieve the addresses.
                List<Address> originAddresses = geocoder.getFromLocation(jsonObject.getJSONArray("origin_coordinates").getDouble(0), jsonObject.getJSONArray("origin_coordinates").getDouble(1), 1);
                List<Address> destinationAddresses = geocoder.getFromLocation(jsonObject.getJSONArray("destination_coordinates").getDouble(0), jsonObject.getJSONArray("destination_coordinates").getDouble(1), 1);

                if (originAddresses.isEmpty() || destinationAddresses.isEmpty())
                    return;

                // get the addresses.
                originAddress = originAddresses.get(0);
                destinationAddress = destinationAddresses.get(0);

                // set the title if they're not null.
                setTripTitle();
            }
        }
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
            trip.setText("Data are not stored correctly.");
            trip.setTextColor(Color.RED);
        }
        catch (IOException e)
        {
            System.err.println(e.getMessage());
            trip.setText("Unable to load addresses.");
            trip.setTextColor(Color.RED);
        }

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

    private void setTripTitle()
    {
        // addresses must not be null.
        if (originAddress == null || destinationAddress == null)
            return;

        // make string trip.
        String trip = "FROM: " +
                originAddress.getAddressLine(0) +
                "\n\n" +
                "TO: " +
                destinationAddress.getAddressLine(0);

        // assign the trip addresses.
        this.trip.setText(trip);
    }


    private void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        timesRepeating.setText(isChecked? "1" : "");
        timesRepeating.setEnabled(!isChecked);
    }

    private void onSelectTripClicked(View view)
    {
        // initialize opening activity.
        Intent intent = new Intent(this, MapsCreateTripActivity.class);

        // get the coordinates of the trip.
        Map<String, double[]> coordinates = JSONCoordinatesTool.getCoordinatesFromJSON(repeatedTrip.getOrigin());

        // if they exist
        if (coordinates != null)
        {
            // pass the data to the next activity.
            intent.putExtra("origin", coordinates.get("origin"));
            intent.putExtra("destination", coordinates.get("destination"));
        }

        // start the activity in any case (either with or without data).
        startActivity(intent);
    }
}