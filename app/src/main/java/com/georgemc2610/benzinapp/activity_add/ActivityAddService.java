package com.georgemc2610.benzinapp.activity_add;

import static androidx.fragment.app.FragmentManager.TAG;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.georgemc2610.benzinapp.activity_maps.MapsSelectPointActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.KeyboardButtonAppearingTool;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityAddService extends AppCompatActivity
{
    EditText atKm, nextKm, costEur, notes;
    LocationManager locationManager;
    TextView location, date;
    CardView addButton, pickLocation, pickDate, pickToday, deleteLocation;
    String coordinates, address;
    int mYear, mMonth, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_service);

        // get edit texts and text views.
        atKm = findViewById(R.id.atKm);
        nextKm = findViewById(R.id.nextKm);
        costEur = findViewById(R.id.cost);
        notes = findViewById(R.id.desc);
        location = findViewById(R.id.locationText);
        date = findViewById(R.id.dateText);

        // get the buttons
        addButton = findViewById(R.id.addButton);
        pickLocation = findViewById(R.id.locationButton);
        pickDate = findViewById(R.id.dateButton);
        pickToday = findViewById(R.id.todayButton);
        deleteLocation = findViewById(R.id.removeLocationButton);

        // assign listeners to the buttons
        addButton.setOnClickListener(this::onButtonAddClicked);
        pickLocation.setOnClickListener(this::onSelectLocationClicked);
        pickDate.setOnClickListener(this::onPickDateClicked);
        pickToday.setOnClickListener(this::onButtonPickTodayDateClicked);
        deleteLocation.setOnClickListener(this::onRemoveLocationButtonClicked);

        // ContentView is the root view of the layout of this activity/fragment
        LinearLayout contentView = findViewById(R.id.addServiceLinearLayout);
        new KeyboardButtonAppearingTool(contentView, addButton);

        // action bar
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_add_service));
    }

    private void onKeyboardVisibilityChanged(boolean opened)
    {
        addButton.setVisibility(opened ? View.GONE : View.VISIBLE);
    }

    @Override
    public void onResume()
    {
        super.onResume();

        // get the locations using shared preferences
        SharedPreferences preferences = getSharedPreferences("location", MODE_PRIVATE);

        // retrieve the selected address and location
        coordinates = preferences.getString("picked_location", null);
        address = preferences.getString("picked_address", null);

        if (coordinates != null)
            this.location.setText(address);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {
            case android.R.id.home:

                // when the back button is pressed without saving a record.
                if (AnyEditTextFilled())
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

    private boolean AnyEditTextFilled()
    {
        return (atKm.getText().toString().trim().length() != 0 ||
                notes.getText().toString().trim().length() != 0 ||
                nextKm.getText().toString().trim().length() != 0 ||
                costEur.getText().toString().trim().length() != 0);
    }

    private void onButtonPickTodayDateClicked(View v)
    {
        LocalDate date = LocalDate.now();
        this.date.setText(date.toString());
    }

    private void onButtonAddClicked(View v)
    {
        boolean validated = true;

        // all of the following fields are required. If any of those are not filled, display an error.
        if (atKm.getText().toString().trim().length() == 0)
        {
            atKm.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (notes.getText().toString().trim().length() == 0)
        {
            notes.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (date.getText().toString().trim().equals(getString(R.string.text_view_select_date)))
        {
            Toast.makeText(this, "Please select a date.", Toast.LENGTH_LONG).show();
            validated = false;
        }

        if (!validated)
            return;

        // get the data
        String at_km = atKm.getText().toString().trim();
        String next_km = nextKm.getText().toString().trim();
        String cost_eur = costEur.getText().toString().trim();
        String description = notes.getText().toString().trim();
        String date_happened = date.getText().toString().trim();

        // update the location string.
        String locationString = address == null || coordinates == null? null : address + "|" + coordinates;

        // send it to the cloud.
        RequestHandler.getInstance().AddService(this, at_km, cost_eur, description, locationString, date_happened, next_km);
    }

    private void onPickDateClicked(View v)
    {
        // get calendar and dates to keep track of
        final Calendar calendar = Calendar.getInstance();
        mYear = calendar.get(Calendar.YEAR);
        mMonth = calendar.get(Calendar.MONTH);
        mDay = calendar.get(Calendar.DAY_OF_MONTH);

        // date picker dialog shows up
        DatePickerDialog datePickerDialog = new DatePickerDialog(this, new DatePickerDialog.OnDateSetListener()
        {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth)
            {
                // and when it updates, it sets the value of the edit text.
                date.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }

    private void onSelectLocationClicked(View view)
    {
        Intent intent = new Intent(this, MapsSelectPointActivity.class);

        // initialize location permission
        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        if (    ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED)
        {
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setMessage(getString(R.string.dialog_location_required));
            builder.setNeutralButton("OK", (dialog, which) -> ActivityCompat.requestPermissions(ActivityAddService.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 9918));
            builder.show();
        }
        else
        {
            startActivity(intent);
        }
    }

    private void onRemoveLocationButtonClicked(View v)
    {
        // alert dialog for location delete confirmation.
        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        builder.setMessage(R.string.dialog_location_deletion_confirmation);
        builder.setCancelable(true);
        builder.setPositiveButton(R.string.dialog_yes, (dialog, which) ->
        {
            // set the location view to be default.
            location.setText(R.string.text_view_select_location);

            // edit shared preferences to remove the picked_address and picked_location values.
            SharedPreferences preferences = getSharedPreferences("location", MODE_PRIVATE);

            // put null in each of these values.
            SharedPreferences.Editor editor = preferences.edit();
            editor.putString("picked_location", null);
            editor.putString("picked_address", null);
            editor.apply();

            // also nullify the values retrieved originally
            address = null;
            coordinates = null;
        });

        builder.setNegativeButton(R.string.dialog_no, (dialog, which) -> {});
        builder.show();
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();

        // delete the picked locations and addresses when the activity closes.
        SharedPreferences preferencesLocation = getSharedPreferences("location", MODE_PRIVATE);
        SharedPreferences.Editor locationEditor = preferencesLocation.edit();

        // set the corresponding string values to null.
        locationEditor.putString("picked_location", null);
        locationEditor.putString("picked_address", null);

        // apply edits before closing.
        locationEditor.apply();
    }
}