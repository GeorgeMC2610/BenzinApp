package com.georgemc2610.benzinapp.activity_add;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.StringRequest;
import com.georgemc2610.benzinapp.MapsCreateTripActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class ActivityAddRepeatedTrip extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener
{
    private EditText title, timesRepeating;
    private CheckBox isRepeating;
    private TextView trip, totalKm, totalKmLegend;
    private Address originAddress, destinationAddress;
    private float km;
    private String encodedTrip, jsonTrip;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_repeated_trip);

        // views
        title = findViewById(R.id.repeated_trips_edit_text_title);
        timesRepeating = findViewById(R.id.repeated_trips_edit_text_times_repeating);
        isRepeating = findViewById(R.id.repeated_trips_checkbox_not_repeating);
        trip = findViewById(R.id.repeated_trips_text_view_origin);
        totalKm = findViewById(R.id.repeated_trips_text_view_kilometers);
        totalKmLegend = findViewById(R.id.repeated_trips_text_view_kilometers_legend);

        // set check box listener
        isRepeating.setOnCheckedChangeListener(this);

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
        Intent intent = new Intent(this, MapsCreateTripActivity.class);
        startActivity(intent);
    }

    @SuppressLint("NewApi")
    public void onButtonAddClicked(View v) throws JSONException
    {
        // set all errors if any edit text has no data.
        if (!setErrors(title, timesRepeating) || checkDataIntegrity())
            return;

        // get title and times repeating.
        String title = getFilteredViewSequence(this.title);
        int timesRepeating = Integer.parseInt(getFilteredViewSequence(this.timesRepeating));

        // send the trip
        RequestHandler.getInstance().AddRepeatedTrip(this, title, jsonTrip, encodedTrip, timesRepeating, km);
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public void onResume()
    {
        // call original on resume (required)
        super.onResume();

        // get shared preferences data
        SharedPreferences preferences = getSharedPreferences("repeated_trip", MODE_PRIVATE); // TODO: Clear upon leaving.
        encodedTrip = preferences.getString("encodedTrip", null);
        jsonTrip = preferences.getString("jsonTrip", null);

        // if they have no data in them.
        if (encodedTrip == null || jsonTrip == null)
            return;

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
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
        }
    }

    private void assignTripViewAddresses()
    {
        if (originAddress == null || destinationAddress == null)
            return;

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
        if (!isEditTextEmpty(title) || !isEditTextEmpty(timesRepeating))
            return true;

        return !getFilteredViewSequence(trip).equals("Select Trip...");
    }

    /**
     * Checks the trimmed content of any {@linkplain EditText} to see if it has any value in it.
     * @param editText The field to be checked.
     * @return True if it has no value, false otherwise.
     */
    private boolean isEditTextEmpty(EditText editText)
    {
        return getFilteredViewSequence(editText).isEmpty();
    }

    /**
     * Filters the text inside an {@linkplain EditText} using the trim method of the {@linkplain String} class.
     * @param editText The wanted field for its text retrieval.
     * @return The content of the {@linkplain  EditText} with no whitespaces.
     */
    private String getFilteredViewSequence(EditText editText)
    {
        return editText.getText().toString().trim();
    }

    /**
     * Filters the text inside an {@linkplain TextView} using the trim method of the {@linkplain String} class.
     * @param textView The wanted field for its text retrieval.
     * @return The content of the {@linkplain TextView} with no whitespaces.
     */
    private String getFilteredViewSequence(TextView textView)
    {
        return textView.getText().toString().trim();
    }

    /**
     * Typically used to see if all the fields are correctly filled with data before proceeding to send it to the cloud.
     * Sets the errors for any fields that have no data in them.
     * @param texts A list of fields to be checked.
     * @return True all the fields have data and it's okay to proceed, false otherwise.
     */
    private boolean setErrors(EditText... texts)
    {
        boolean canContinue = true;

        for (EditText editText: texts)
        {
            if (isEditTextEmpty(editText))
            {
                editText.setError(getString(R.string.error_field_cannot_be_empty));
                canContinue = false;
            }
        }

        return canContinue;
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