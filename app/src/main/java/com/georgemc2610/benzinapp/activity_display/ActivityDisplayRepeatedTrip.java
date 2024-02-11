package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class ActivityDisplayRepeatedTrip extends AppCompatActivity
{
    private TextView title, timesRepeating, trip, km, cost, lt;
    private Address origin, destination;
    private RepeatedTrip repeatedTrip;

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

        // formats to display the values
        NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.getDefault());
        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        // formatted strings.
        String repeatingText = getString(R.string.card_repeated_trip_repeating) + repeatedTrip.getTimesRepeating() + getString(R.string.card_repeated_trip_times_per_week);
        String formattedTotalKm = numberFormat.format(repeatedTrip.getTotalKm()) + ' ' + getString(R.string.km_short) + getString(R.string.card_trip_km_trip);
        String formattedEuros = "€" + decimalFormat.format(repeatedTrip.getTotalCostEur(DataHolder.getInstance().car) * repeatedTrip.getTimesRepeating());
        String formattedLiters = numberFormat.format(repeatedTrip.getTotalLt(DataHolder.getInstance().car) * repeatedTrip.getTimesRepeating()) + ' ' + getString(R.string.lt_short) + getString(R.string.card_repeated_trip_times_per_week);

        // set the views' texts
        title.setText(repeatedTrip.getTitle());
        timesRepeating.setText(repeatingText);
        trip.setText(getString(R.string.loading));
        km.setText(formattedTotalKm);
        cost.setText(formattedEuros);
        lt.setText(formattedLiters);

        // get the addresses from the locations.
        Geocoder geocoder = new Geocoder(this);

        try
        {
            // get the json object and retrieve the coordinates.
            JSONArray jsonOriginCoordinates = new JSONObject(repeatedTrip.getOrigin()).getJSONArray("origin_coordinates");
            JSONArray jsonDestinationCoordinates = new JSONObject(repeatedTrip.getOrigin()).getJSONArray("destination_coordinates");

            // in newer api a listener is used.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            {
                // get the address for the origin.
                geocoder.getFromLocation(jsonOriginCoordinates.getDouble(0), jsonOriginCoordinates.getDouble(1), 10, addresses ->
                {
                    // check if any address exists.
                    if (addresses.isEmpty())
                        return;

                    // if it exists, assign the first one.
                    origin = addresses.get(0);
                    runOnUiThread(this::displayAddresses);
                });

                // get the address for the destination.
                geocoder.getFromLocation(jsonDestinationCoordinates.getDouble(0), jsonDestinationCoordinates.getDouble(1), 10, addresses ->
                {
                    // check for any address
                    if (addresses.isEmpty())
                        return;

                    // and assign it to the destination also.
                    destination = addresses.get(0);
                    runOnUiThread(this::displayAddresses);
                });
            }
            // in the old api it's in the main thread.
            else
            {
                // retrieve all addresses.
                List<Address> originAddresses = geocoder.getFromLocation(jsonOriginCoordinates.getDouble(0), jsonOriginCoordinates.getDouble(1), 10);
                List<Address> destinationAddresses = geocoder.getFromLocation(jsonDestinationCoordinates.getDouble(0), jsonDestinationCoordinates.getDouble(1), 10);

                // assign the first one to the origin.
                if (!originAddresses.isEmpty())
                    origin = originAddresses.get(0);

                // same for the destination.
                if (!destinationAddresses.isEmpty())
                    destination = destinationAddresses.get(0);

                // and if they exist, display them.
                displayAddresses();
            }

        }
        catch (JSONException e)
        {
            // if there is a JSON exception, then the coordinates aren't stored correctly in the cloud.
            System.err.println(e.getMessage());
            trip.setText("Unable to load coordinates.");
            trip.setTextColor(Color.RED);
        }
        catch (IOException e)
        {
            // if an IOException occurs, then the geocoder failed.
            System.err.println(e.getMessage());
            trip.setText("Addresses failed to load.");
            trip.setTextColor(Color.RED);
        }

        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_display_data));
    }

    private void displayAddresses()
    {
        // both addresses have to be valid in order to be displayed.
        if (origin == null || destination == null)
        {
            trip.setText("Unable to load addresses.");
            return;
        }

        // creating a FROM: TO: string to display.
        String builder = "From: " +
                origin.getAddressLine(0) +
                "\n\n" +
                "To: " +
                destination.getAddressLine(0);

        trip.setText(builder);
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