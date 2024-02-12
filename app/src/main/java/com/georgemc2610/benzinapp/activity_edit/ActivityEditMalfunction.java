package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.activity_maps.MapsSelectPointActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditMalfunction extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener, Response.Listener<String>
{
    private LinearLayout linearLayout;
    private EditText titleView, descView, atKmView, costView;
    private TextView dateStartedView, dateEndedView, locationPickedView;
    private CheckBox fixedCheckBox;
    private Malfunction malfunction;
    private String address, coordinates;
    int mYear, mDay, mMonth;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_malfunction);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(R.string.title_edit_malfunction);
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // get the views
        linearLayout = findViewById(R.id.linearLayoutEditMalfunction);

        titleView = findViewById(R.id.editTextEditMalfunctionTitle);
        descView = findViewById(R.id.editTextEditMalfunctionDesc);
        atKmView = findViewById(R.id.editTextEditMalfunctionAtKm);
        costView = findViewById(R.id.editTextEditMalfunctionCost);

        dateStartedView = findViewById(R.id.textViewEditMalfunctionDateStartedPicked);
        dateEndedView = findViewById(R.id.textViewEditMalfunctionDateEndedPicked);
        locationPickedView = findViewById(R.id.textViewEditMalfunctionLocationPicked);

        fixedCheckBox = findViewById(R.id.checkBoxEditMalfunctionFixed);

        // set the listeners.
        fixedCheckBox.setOnCheckedChangeListener(this);

        // get the fuel fill record passed to edit.
        malfunction = (Malfunction) getIntent().getSerializableExtra("malfunction");

        // from the malfunction object get and initialize data.
        titleView.setText(malfunction.getTitle());
        descView.setText(malfunction.getDescription());
        atKmView.setText(String.valueOf(malfunction.getAt_km()));
        dateStartedView.setText(malfunction.getStarted().toString());

        // if the malfunction is fixed it MUST have additional data.
        if (malfunction.getEnded() != null)
        {
            // the fixed check box at first gets ticked.
            fixedCheckBox.setChecked(true);

            // and then all of the required data appear
            costView.setText(String.valueOf(malfunction.getCost()));
            dateEndedView.setText(malfunction.getEnded().toString());

            // if the malfunction location exists...
            if (malfunction.getLocation() != null && !malfunction.getLocation().isEmpty())
            {
                // it must be in the format: <address>|<coordinates>
                if (malfunction.getLocation().contains("|"))
                {
                    // if it is, split it and get the coordinates and address.
                    String[] locationSplit = malfunction.getLocation().split("\\|");
                    locationPickedView.setText(locationSplit[0]);
                }
                else
                {
                    locationPickedView.setText(malfunction.getLocation());
                }
            }
        }
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

        if (coordinates != null && address != null)
            locationPickedView.setText(address);
    }

    public void PickDate(View view)
    {
        // get calendar and dates to keep track of
        final Calendar calendar = Calendar.getInstance();
        mYear = calendar.get(Calendar.YEAR);
        mMonth = calendar.get(Calendar.MONTH);
        mDay = calendar.get(Calendar.DAY_OF_MONTH);

        TextView date = view.getId() == R.id.buttonEditMalfunctionDateStarted ? findViewById(R.id.textViewEditMalfunctionDateStartedPicked) : findViewById(R.id.textViewEditMalfunctionDateEndedPicked);

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

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        // get the child count of the linear layout.
        final int childCount = linearLayout.getChildCount();

        // for every child...
        for (int i = 0; i < childCount; i++)
        {
            // get the view object.
            final View view = linearLayout.getChildAt(i);

            // see if there are any tags.
            if (view.getTag() == null)
                continue;

            // and if there are and its tag is "additional", conditionally change its visibility.
            if (view.getTag().toString().equals("additional"))
                view.setVisibility(isChecked? View.VISIBLE : View.GONE);
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        // once the back button is pressed, close the activity.
        if (item.getItemId() == android.R.id.home)
        {
            finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void OnButtonApplyEditsClicked(View v)
    {
        boolean canContinue = true;

        // integrity checks
        if (fixedCheckBox.isChecked())
        {
            if (costView.getText().toString().trim().isEmpty())
            {
                costView.setError(getString(R.string.error_field_cannot_be_empty));
                canContinue = false;
            }

            if (dateEndedView.getText().toString().equals(getString(R.string.text_view_select_date)))
            {
                Toast.makeText(this, getString(R.string.toast_please_select_date), Toast.LENGTH_SHORT).show();
                canContinue = false;
            }
        }

        if (!canContinue) return;

        // apply edits to the object.
        if (!titleView.getText().toString().trim().isEmpty())
            malfunction.setTitle(titleView.getText().toString().trim());

        if (!descView.getText().toString().trim().isEmpty())
            malfunction.setDescription(descView.getText().toString().trim());

        if (!atKmView.getText().toString().trim().isEmpty())
            malfunction.setAt_km(Integer.parseInt(atKmView.getText().toString().trim()));

        malfunction.setStarted(LocalDate.parse(dateStartedView.getText().toString().trim()));

        // set optional data.
        if (fixedCheckBox.isChecked())
        {
            malfunction.setCost(Float.parseFloat(costView.getText().toString().trim()));
            malfunction.setEnded(LocalDate.parse(dateEndedView.getText().toString().trim()));

            if (address != null && coordinates != null)
                malfunction.setLocation(address + '|' + coordinates);
            else
                malfunction.setLocation(null);
        }
        else
        {
            malfunction.setCost(-1f);
            malfunction.setEnded(null);
            malfunction.setLocation(null);
        }

        RequestHandler.getInstance().EditMalfunction(this, malfunction);
    }

    @Override
    public void onResponse(String response)
    {
        Toast.makeText(this, getString(R.string.toast_record_edited), Toast.LENGTH_LONG).show();
        finish();
    }

    public void OnSelectLocationClicked(View v)
    {
        // whenever the select location button is clicked, we must check two cases:
        // the permission is granted.
        if (    ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED)
        {
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setMessage(getString(R.string.dialog_location_required));
            builder.setNeutralButton("OK", (dialog, which) -> ActivityCompat.requestPermissions(ActivityEditMalfunction.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 9918));
            builder.show();
        }

        // the user actually wants to replace this location if it's already picked.
        if (malfunction.getLocation() != null)
        {
            // create a dialog that informs them.
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setMessage(getString(R.string.dialog_select_new_location_confirm));

            // the YES button opens the google maps activity.
            builder.setPositiveButton(R.string.dialog_yes, (dialog, which) ->
            {
                Intent intent = new Intent(ActivityEditMalfunction.this, MapsSelectPointActivity.class);
                startActivity(intent);
            });

            // the no button cancels.
            builder.setNegativeButton(R.string.dialog_no, (dialog, which) -> {});

            builder.show();
            return;
        }

        // in any other case, the maps activity can open regularly.
        Intent intent = new Intent(this, MapsSelectPointActivity.class);
        startActivity(intent);
    }

    public void OnDeleteLocationClicked(View v)
    {
        // alert dialog for location delete confirmation.
        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        builder.setMessage(R.string.dialog_location_deletion_confirmation);
        builder.setCancelable(true);
        builder.setPositiveButton(R.string.dialog_yes, (dialog, which) ->
        {
            // set the location view to be default.
            locationPickedView.setText(R.string.text_view_select_location);

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