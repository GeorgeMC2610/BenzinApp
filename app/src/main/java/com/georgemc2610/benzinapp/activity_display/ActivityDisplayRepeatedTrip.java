package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

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
import com.georgemc2610.benzinapp.activity_edit.ActivityEditRepeatedTrip;
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
    private TextView title, timesRepeating, trip, km, costAvg, costAvgPerTime, costWorst, costWorstPerTime,
            costBest, costBestPerTime, ltAvg, ltAvgPerTime, ltWorst, ltWorstPerTime, ltBest, ltBestPerTime;
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
        CardView showOnMapButton = findViewById(R.id.display_repeated_trip_button_show_on_map);
        CardView deleteButton = findViewById(R.id.buttonDelete);
        CardView editButton = findViewById(R.id.buttonEdit);
        km = findViewById(R.id.display_repeated_trip_text_view_total_km);
        costAvg = findViewById(R.id.display_repeated_trip_text_view_average_cost);
        costAvgPerTime = findViewById(R.id.averageCostPerTime);
        costWorst = findViewById(R.id.display_repeated_trip_text_view_worst_cost);
        costWorstPerTime = findViewById(R.id.worstCostPerTime);
        costBest = findViewById(R.id.display_repeated_trip_text_view_best_cost);
        costBestPerTime = findViewById(R.id.bestCostPerTime);
        ltAvg = findViewById(R.id.display_repeated_trip_text_view_average_consumption);
        ltAvgPerTime = findViewById(R.id.averageConsumptionPerTime);
        ltWorst = findViewById(R.id.display_repeated_trip_text_view_worst_consumption);
        ltWorstPerTime = findViewById(R.id.worstConsumptionPerTime);
        ltBest = findViewById(R.id.display_repeated_trip_text_view_best_consumption);
        ltBestPerTime = findViewById(R.id.bestConsumptionPerTime);

        // get the serializable object
        repeatedTrip = (RepeatedTrip) getIntent().getSerializableExtra("repeated_trip");

        // show on map button listener
        showOnMapButton.setOnClickListener(this::onButtonShowOnMapClicked);
        deleteButton.setOnClickListener(this::onButtonDeleteRecordClicked);
        editButton.setOnClickListener(this::onButtonEditClicked);

        // view assigning
        assignValues();

        // action bar displaying.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_display_data));
    }

    private void onButtonShowOnMapClicked(View view)
    {
        Intent intent = new Intent(this, MapsDisplayTripActivity.class);
        intent.putExtra("origin_latitude", repeatedTrip.getOriginLatitude());
        intent.putExtra("origin_longitude", repeatedTrip.getOriginLongitude());
        intent.putExtra("destination_latitude", repeatedTrip.getDestinationLatitude());
        intent.putExtra("destination_longitude", repeatedTrip.getDestinationLongitude());
        intent.putExtra("polyline", repeatedTrip.getPolyline());
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
    protected void onResume()
    {
        super.onResume();
        repeatedTrip = DataHolder.getInstance().trips.stream()
                .filter(r -> r.getId() == repeatedTrip.getId())
                .findFirst().get();
        assignValues();
    }

    private void assignValues()
    {
        // formats to display the values
        NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.getDefault());

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

        String[] formattedAvgValuesEur = formatEuros(repeatedTrip.getAvgCostEur(car), repeatedTrip.getTimesRepeating());
        String[] formattedWorstValuesEur = formatEuros(repeatedTrip.getWorstCostEur(car), repeatedTrip.getTimesRepeating());
        String[] formattedBestValuesEur = formatEuros(repeatedTrip.getBestCostEur(car), repeatedTrip.getTimesRepeating());

        // all scenarios for consumption.
        String[] formattedAvgValuesLiters = formatLiters(repeatedTrip.getAvgLt(car), repeatedTrip.getTimesRepeating());
        String[] formattedWorstValuesLiters = formatLiters(repeatedTrip.getWorstLt(car), repeatedTrip.getTimesRepeating());
        String[] formattedBestValuesLiters = formatLiters(repeatedTrip.getBestLt(car), repeatedTrip.getTimesRepeating());

        // set the views' texts
        title.setText(repeatedTrip.getTitle());
        timesRepeating.setText(repeatingText);
        trip.setText(getString(R.string.loading));
        km.setText(formattedTotalKm);

        // set the cost
        costAvg.setText(formattedAvgValuesEur[0]);
        costBest.setText(formattedBestValuesEur[0]);
        costWorst.setText(formattedWorstValuesEur[0]);

        // set the consumption
        ltAvg.setText(formattedAvgValuesLiters[0]);
        ltBest.setText(formattedBestValuesLiters[0]);
        ltWorst.setText(formattedWorstValuesLiters[0]);

        // times repeating per time
        if (repeatedTrip.getTimesRepeating() > 1)
        {
            costAvgPerTime.setText(formattedAvgValuesEur[1]);
            costBestPerTime.setText(formattedBestValuesEur[1]);
            costWorstPerTime.setText(formattedWorstValuesEur[1]);

            ltAvgPerTime.setText(formattedAvgValuesEur[1]);
            ltBestPerTime.setText(formattedBestValuesEur[1]);
            ltWorstPerTime.setText(formattedWorstValuesEur[1]);
        }
        else
        {
            costAvgPerTime.setVisibility(View.GONE);
            costBestPerTime.setVisibility(View.GONE);
            costWorstPerTime.setVisibility(View.GONE);

            ltAvgPerTime.setVisibility(View.GONE);
            ltBestPerTime.setVisibility(View.GONE);
            ltWorstPerTime.setVisibility(View.GONE);
        }

        // get the addresses from the locations.
        Geocoder geocoder = new Geocoder(this);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
        {
            // get the address for the origin.
            geocoder.getFromLocation(repeatedTrip.getOriginLatitude(), repeatedTrip.getOriginLongitude(), 10, addresses ->
            {
                // check if any address exists.
                if (addresses.isEmpty())
                    return;

                // if it exists, assign the first one.
                origin = addresses.get(0);
                runOnUiThread(this::displayAddresses);
            });

            // get the address for the destination.
            geocoder.getFromLocation(repeatedTrip.getDestinationLatitude(), repeatedTrip.getDestinationLongitude(), 10, addresses ->
            {
                // check for any address
                if (addresses.isEmpty())
                    return;

                // and assign it to the destination also.
                destination = addresses.get(0);
                runOnUiThread(this::displayAddresses);
            });
        }
        else
        {
            try
            {
                // get the addresses
                List<Address> originAddresses = geocoder.getFromLocation(repeatedTrip.getOriginLatitude(), repeatedTrip.getOriginLongitude(), 10);
                List<Address> destinationAddresses = geocoder.getFromLocation(repeatedTrip.getDestinationLatitude(), repeatedTrip.getDestinationLongitude(), 10);

                // assign the first one to the origin.
                if (!originAddresses.isEmpty())
                    origin = originAddresses.get(0);

                // assign the first one to the destination address.
                if (!destinationAddresses.isEmpty())
                    destination = destinationAddresses.get(0);

                displayAddresses();
            }
            catch (IOException e)
            {
                // if an IOException occurs, then the geocoder failed.
                System.err.println(e.getMessage());
                trip.setText("Addresses failed to load.");
                trip.setTextColor(Color.RED);
            }
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

    private String[] formatLiters(float consumption, int times)
    {
        // get a formatter for better visuals
        NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.getDefault());

        // store values in a string array
        String[] values = new String[2];

        // the first value is how many times it's repeating
        String value1 = numberFormat.format(consumption * times) + ' ' + getString(R.string.lt_short) + (times == 1? getString(R.string.per_time) : getString(R.string.card_repeated_trip_per_week));
        values[0] = value1;

        // and another one for how many eur for every time.
        if (times > 1)
        {
            String value2 = numberFormat.format(consumption) + ' ' + getString(R.string.lt_short) + getString(R.string.per_time);
            values[1] = value2;
        }

        return values;
    }

    private String[] formatEuros(float cost, int times)
    {
        DecimalFormat decimalFormat = new DecimalFormat("#.##");
        String[] values = new String[2];

        String value1 = '€' + decimalFormat.format(cost * times) + (times == 1? getString(R.string.per_time) : getString(R.string.card_repeated_trip_per_week));
        values[0] = value1;

        if (times > 1)
        {
            String value2 = '€' + decimalFormat.format(cost) + getString(R.string.per_time);
            values[1] = value2;
        }

        return values;
    }

    private void onButtonDeleteRecordClicked(View view)
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

    private void onButtonEditClicked(View v)
    {
        Intent intent = new Intent(this, ActivityEditRepeatedTrip.class);
        intent.putExtra("repeatedTrip", repeatedTrip);
        startActivity(intent);
    }

}