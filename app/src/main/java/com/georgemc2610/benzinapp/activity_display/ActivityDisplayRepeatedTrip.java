package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.activity_maps.MapsDisplayTripActivity;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.original.Car;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
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
    private TextView trip;
    private Address origin, destination;
    private RepeatedTrip repeatedTrip;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_repeated_trip);

        // get views
        TextView title = findViewById(R.id.display_repeated_trip_text_view_title);
        TextView timesRepeating = findViewById(R.id.display_repeated_trip_text_view_times_repeating);
        trip = findViewById(R.id.display_repeated_trip_text_view_from_origin_to_destination);
        Button showOnMapButton = findViewById(R.id.display_repeated_trip_button_show_on_map);
        TextView km = findViewById(R.id.display_repeated_trip_text_view_total_km);
        TextView costAvg = findViewById(R.id.display_repeated_trip_text_view_average_cost);
        TextView costWorst = findViewById(R.id.display_repeated_trip_text_view_worst_cost);
        TextView costBest = findViewById(R.id.display_repeated_trip_text_view_best_cost);
        TextView ltAvg = findViewById(R.id.display_repeated_trip_text_view_average_consumption);
        TextView ltWorst = findViewById(R.id.display_repeated_trip_text_view_worst_consumption);
        TextView ltBest = findViewById(R.id.display_repeated_trip_text_view_best_consumption);

        // get the serializable object
        repeatedTrip = (RepeatedTrip) getIntent().getSerializableExtra("repeated_trip");

        // show on map button listener
        showOnMapButton.setOnClickListener(this::onButtonShowOnMapClicked);

        // formats to display the values
        NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.getDefault());
        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        // repeating text for the times in the week.
        String repeatingText;

        if (repeatedTrip.getTimesRepeating() != 1)
            repeatingText = getString(R.string.card_repeated_trip_repeating) + repeatedTrip.getTimesRepeating() + getString(R.string.card_repeated_trip_times_per_week);
        else
            repeatingText = getString(R.string.repeated_trips_doesnt_repeat);

        // formatted strings.
        String formattedTotalKm = numberFormat.format(repeatedTrip.getTotalKm()) + ' ' + getString(R.string.km_short) + getString(R.string.card_trip_km_trip);

        // get the car to calculate all scenarios.
        Car car = DataHolder.getInstance().car;

        // all scenarios for cost.
        String formattedAvgEuros = formatEuros(repeatedTrip.getAvgCostEur(car), repeatedTrip.getTimesRepeating());
        String formattedWorstEuros = formatEuros(repeatedTrip.getWorstCostEur(car), repeatedTrip.getTimesRepeating());
        String formattedBestEuros = formatEuros(repeatedTrip.getBestCostEur(car), repeatedTrip.getTimesRepeating());

        // all scenarios for consumption.
        String formattedAvgLiters = formatLiters(repeatedTrip.getAvgLt(car), repeatedTrip.getTimesRepeating());
        String formattedWorstLiters = formatLiters(repeatedTrip.getWorstLt(car), repeatedTrip.getTimesRepeating());
        String formattedBestLiters = formatLiters(repeatedTrip.getBestLt(car), repeatedTrip.getTimesRepeating());

        // set the views' texts
        title.setText(repeatedTrip.getTitle());
        timesRepeating.setText(repeatingText);
        trip.setText(getString(R.string.loading));
        km.setText(formattedTotalKm);

        // set the cost
        costAvg.setText(formattedAvgEuros);
        costBest.setText(formattedBestEuros);
        costWorst.setText(formattedWorstEuros);

        // set the consumption
        ltAvg.setText(formattedAvgLiters);
        ltBest.setText(formattedBestLiters);
        ltWorst.setText(formattedWorstLiters);

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

    private void onButtonShowOnMapClicked(View view)
    {
        Intent intent = new Intent(this, MapsDisplayTripActivity.class);
        intent.putExtra("coordinates", repeatedTrip.getOrigin());
        intent.putExtra("polyline", repeatedTrip.getDestination());
        startActivity(intent);
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

    private String formatLiters(float consumption, int times)
    {
        NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.getDefault());

        // build a string in the format: ## lt per week (## lt per time)
        return numberFormat.format(consumption * times) +
                ' ' +
                getString(R.string.lt_short) + (times == 1? "" :
                getString(R.string.card_repeated_trip_per_week) +
                " (" +
                numberFormat.format(consumption) +
                ' ' +
                getString(R.string.lt_short) +
                getString(R.string.per_time) +
                ')');
    }

    private String formatEuros(float cost, int times)
    {
        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        // build a string in the format: €#.## per week (€#.## per time)
        return  '€' + decimalFormat.format(cost * times) +
                ' ' + (times == 1? "" :
                getString(R.string.card_repeated_trip_per_week) +
                " (€" +
                decimalFormat.format(cost) +
                getString(R.string.per_time) +
                ')');
    }

    public void onButtonDeleteRecordClicked(View view)
    {
        // build a confirmation dialog
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);

        dialog.setTitle(getString(R.string.dialog_delete_title));
        dialog.setMessage(getString(R.string.dialog_delete_confirmation));

        // when the button yes is clicked
        dialog.setPositiveButton(getString(R.string.dialog_yes), (dialog12, which) ->
        {
            // delete the record by its id.
            RequestHandler.getInstance().DeleteRepeatedTrip(ActivityDisplayRepeatedTrip.this, repeatedTrip.getId());

            // then close this activity
            finish();
        });

        // when the button no is clicked
        dialog.setNegativeButton(getString(R.string.dialog_no), (dialog1, which) -> {});

        dialog.setCancelable(true);
        dialog.create().show();
    }

}