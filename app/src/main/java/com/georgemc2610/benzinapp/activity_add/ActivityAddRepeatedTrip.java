package com.georgemc2610.benzinapp.activity_add;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.location.LocationListener;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.georgemc2610.benzinapp.activity_maps.MapsCreateTripActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.JSONCoordinatesTool;
import com.georgemc2610.benzinapp.classes.activity_tools.LocationPermissionTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class ActivityAddRepeatedTrip extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener
{
    private EditText title, timesRepeating;
    private CheckBox isRepeating;
    private TextView trip, totalKm, totalKmLegend;
    private Address originAddress, destinationAddress;
    private float km;
    private boolean permissionRequested = false;
    private String encodedTrip, jsonTrip;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_repeated_trip);

        // get the views
        title = findViewById(R.id.repeated_trips_edit_text_title);
        timesRepeating = findViewById(R.id.repeated_trips_edit_text_times_repeating);
        isRepeating = findViewById(R.id.repeated_trips_checkbox_not_repeating);
        trip = findViewById(R.id.repeated_trips_text_view_origin);
        totalKm = findViewById(R.id.repeated_trips_text_view_kilometers);
        totalKmLegend = findViewById(R.id.repeated_trips_text_view_kilometers_legend);

        // set check box listener
        isRepeating.setOnCheckedChangeListener(this);

        // request permissions for the location
        if (!LocationPermissionTool.isLocationPermissionGranted(this))
        {
            LocationPermissionTool.requestPermission(this);
            permissionRequested = true;
        }

        // action bar
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_add_trip));
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults)
    {
        // call super class method.
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode != 9918)
            return;

        if (!permissionRequested)
            return;

        int deniedPermissionResults = 0;

        for (int i : grantResults)
        {
            System.out.println(i);

            if (i == -1)
                deniedPermissionResults++;
        }


        if (deniedPermissionResults != 0 && deniedPermissionResults == grantResults.length)
        {
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setMessage(R.string.dialog_location_mandatory);
            builder.setNeutralButton("OK", (dialog, which) -> finish());
            builder.show();
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {
            case android.R.id.home:

                if (isAnyFieldFilled())
                {
                    AlertDialog.Builder dialog = new AlertDialog.Builder(this);

                    dialog.setTitle(getString(R.string.dialog_exit_confirmation_title));
                    dialog.setMessage(getString(R.string.dialog_exit_confirmation_message));
                    dialog.setCancelable(true);

                    dialog.setPositiveButton(R.string.dialog_yes, new DialogInterface.OnClickListener()
                    {
                        @Override
                        public void onClick(DialogInterface dialog, int which)
                        {
                            finish();
                        }
                    });

                    dialog.setNegativeButton(R.string.dialog_no, new DialogInterface.OnClickListener()
                    {
                        @Override
                        public void onClick(DialogInterface dialog, int which)
                        {
                            // foo.
                        }
                    });

                    dialog.create().show();
                }
                else
                    finish();

                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void onButtonSelectTripClicked(View v)
    {
        // initialize intent for opening activity.
        Intent intent = new Intent(this, MapsCreateTripActivity.class);

        // if they exist
        if (jsonTrip != null)
        {
            // mapping the coordinates.
            Map<String, double[]> coordinates = JSONCoordinatesTool.getCoordinatesFromJSON(jsonTrip);

            // pass the data to the next activity.
            intent.putExtra("origin", coordinates.get("origin"));
            intent.putExtra("destination", coordinates.get("destination"));
            intent.putExtra("polyline", encodedTrip);
            intent.putExtra("km", km);
        }

        // start the activity.
        startActivity(intent);
    }


    public void onButtonAddClicked(View v)
    {
        // set all errors if any edit text has no data.
        if (!ViewTools.setErrors(this, title, timesRepeating) || !checkDataIntegrity())
            return;

        // get title and times repeating.
        String title = ViewTools.getFilteredViewSequence(this.title);
        int timesRepeating = Integer.parseInt(ViewTools.getFilteredViewSequence(this.timesRepeating));

        // send the trip
        RequestHandler.getInstance().AddRepeatedTrip(this, title, jsonTrip, encodedTrip, timesRepeating, km);
    }

    @Override
    public void onResume()
    {
        // call original on resume (required)
        super.onResume();

        // get shared preferences data
        SharedPreferences preferences = getSharedPreferences("repeated_trip", MODE_PRIVATE); // TODO: Clear upon leaving.
        encodedTrip = preferences.getString("encodedTrip", null);
        jsonTrip = preferences.getString("jsonTrip", null);
        km = preferences.getFloat("tripDistance", -1f);

        // if they have no data in them.
        if (encodedTrip == null || jsonTrip == null)
            return;

        // if there is a trip, show its distance.
        if (km != -1f && km != 0f)
        {
            totalKm.setText(km + " " + getString(R.string.km_short));
            totalKm.setVisibility(View.VISIBLE);
            totalKmLegend.setVisibility(View.VISIBLE);
        }

        try
        {
            // loading text...
            trip.setText("Loading addresses...");

            // json objects stored
            JSONObject jsonObject = new JSONObject(jsonTrip);
            JSONArray jsonLatLngOrigin = jsonObject.getJSONArray("origin_coordinates");
            JSONArray jsonLatLngDestination = jsonObject.getJSONArray("destination_coordinates");

            // get latlng objects.
            LatLng originLatLng = new LatLng(jsonLatLngOrigin.getDouble(0), jsonLatLngOrigin.getDouble(1));
            LatLng destinationLatLng = new LatLng(jsonLatLngDestination.getDouble(0), jsonLatLngDestination.getDouble(1));

            // geocoder to set the addresses correctly.
            Geocoder geocoder = new Geocoder(this);

            // newer api requires listener
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            {
                // assign the addresses to the text view.
                geocoder.getFromLocation(originLatLng.latitude, originLatLng.longitude, 5, addresses ->
                {
                    if (addresses.isEmpty())
                        return;

                    originAddress = addresses.get(0);
                    runOnUiThread(this::assignTripViewAddresses);
                });

                // same for the destination.
                geocoder.getFromLocation(destinationLatLng.latitude, destinationLatLng.longitude, 5, addresses ->
                {
                    if (addresses.isEmpty())
                        return;

                    destinationAddress = addresses.get(0);
                    runOnUiThread(this::assignTripViewAddresses);
                });
            }
            // older api requires occupying the entire thread.
            else
            {
                // get all possible addresses
                List<Address> originAddresses = geocoder.getFromLocation(originLatLng.latitude, originLatLng.longitude, 5);
                List<Address> destinationAddresses = geocoder.getFromLocation(destinationLatLng.latitude, destinationLatLng.longitude, 5);

                // if either one is empty, don't assign it.
                if (!originAddresses.isEmpty())
                    originAddress = originAddresses.get(0);

                if (!destinationAddresses.isEmpty())
                    destinationAddress = destinationAddresses.get(0);

                // set the view according to the list sizes.
                assignTripViewAddresses();
            }
        }
        // json exception means the latitude and longitude aren't stored correctly.
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
            trip.setTextColor(Color.RED);
            trip.setText("Invalid coordinates.");
        }
        // io exception means the geocoder (older api) failed.
        catch (IOException e)
        {
            System.err.println(e.getMessage());
            trip.setTextColor(Color.RED);
            trip.setText("Couldn't load addresses.");
        }
    }

    private void assignTripViewAddresses()
    {
        if (originAddress == null || destinationAddress == null)
        {
            trip.setText("No addresses found.");
            return;
        }

        StringBuilder builder = new StringBuilder();
        builder.append("From: ");
        builder.append(originAddress.getAddressLine(0));
        builder.append("\n\n");
        builder.append("To: ");
        builder.append(destinationAddress.getAddressLine(0));

        trip.setText(builder.toString());
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();

        // clear data upon leaving.
        SharedPreferences preferences = getSharedPreferences("repeated_trip", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();

        editor.putString("encodedTrip", null);
        editor.putString("jsonTrip", null);
        editor.apply();
    }


    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        timesRepeating.setText(isChecked? "1" : "");
        timesRepeating.setEnabled(!isChecked);
    }


    /**
     * Checks if all the fields have some value in them.
     * @return True if there is at least one {@linkplain EditText} with text in it, false otherwise.
     */
    private boolean isAnyFieldFilled()
    {
        if (!ViewTools.isEditTextEmpty(title) || !ViewTools.isEditTextEmpty(timesRepeating))
            return true;

        return !ViewTools.getFilteredViewSequence(trip).equals("Make a trip...");
    }

    /**
     * Checks the integrity of the data retrieved from the {@linkplain MapsCreateTripActivity}. Shows a message if the data are not present.
     * @return True if none of the data sent are null, false otherwise.
     */
    private boolean checkDataIntegrity()
    {
        if (jsonTrip == null || encodedTrip == null)
        {
            Toast.makeText(this, "Please select a trip.", Toast.LENGTH_LONG).show();
            return false;
        }

        return true;
    }
}