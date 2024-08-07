package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
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
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.KeyboardButtonAppearingTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditMalfunction extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener, Response.Listener<String>
{
    private LinearLayout baseLayout, scrollViewLayout;
    private EditText titleView, descView, atKmView, costView;
    private TextView dateStartedView, dateEndedView, locationPickedView;
    private CheckBox fixedCheckBox;
    private CardView apply, selectDate, selectToday, selectDateFixed, selectTodayFixed, selectLocation, deleteLocation;
    private Malfunction malfunction;
    private String address, coordinates;
    int mYear, mDay, mMonth;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_malfunction);

        // get the views
        baseLayout = findViewById(R.id.editMalfunctionLinearLayout);
        scrollViewLayout = findViewById(R.id.scrollViewLayout);
        titleView = findViewById(R.id.title);
        descView = findViewById(R.id.desc);
        atKmView = findViewById(R.id.atKm);
        costView = findViewById(R.id.cost);
        dateStartedView = findViewById(R.id.dateText);
        dateEndedView = findViewById(R.id.dateFixedText);
        locationPickedView = findViewById(R.id.locationText);
        fixedCheckBox = findViewById(R.id.fixed);

        // get the buttons
        apply = findViewById(R.id.applyButton);
        selectDate = findViewById(R.id.dateButton);
        selectDateFixed = findViewById(R.id.dateFixedButton);
        selectToday = findViewById(R.id.todayButton);
        selectTodayFixed = findViewById(R.id.todayFixedButton);
        selectLocation = findViewById(R.id.locationButton);
        deleteLocation = findViewById(R.id.removeLocationButton);

        // set button listeners
        apply.setOnClickListener(this::onButtonApplyEditsClicked);
        selectDate.setOnClickListener(this::onButtonPickDateClicked);
        selectToday.setOnClickListener(this::setTodayDate);
        selectDateFixed.setOnClickListener(this::onButtonPickDateClicked);
        selectTodayFixed.setOnClickListener(this::setTodayDate);
        selectLocation.setOnClickListener(this::onSelectLocationClicked);
        deleteLocation.setOnClickListener(this::onDeleteLocationClicked);

        // set the listeners.
        fixedCheckBox.setOnCheckedChangeListener(this);
        fixedCheckBox.setChecked(false);

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

        // keyboard disappearing for the apply button.
        new KeyboardButtonAppearingTool(baseLayout, apply);

        // action bar with back button and correct title name.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_edit_malfunction));
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

    public void onButtonPickDateClicked(View view)
    {
        // get calendar and dates to keep track of
        final Calendar calendar = Calendar.getInstance();
        mYear = calendar.get(Calendar.YEAR);
        mMonth = calendar.get(Calendar.MONTH);
        mDay = calendar.get(Calendar.DAY_OF_MONTH);

        TextView date = view.getId() == R.id.dateButton ? dateStartedView : dateEndedView;

        // date picker dialog shows up
        DatePickerDialog datePickerDialog = new DatePickerDialog(this, new DatePickerDialog.OnDateSetListener()
        {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth)
            {
                // set date color back to black.
                // TODO: Make this based on theme.
                date.setTextColor(getColor(R.color.black));

                // and when it updates, it sets the value of the edit text.
                date.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }

    private void setTodayDate(View v)
    {
        TextView textViewDate = v.getId() == R.id.todayButton ? dateStartedView : dateEndedView;
        LocalDate date = LocalDate.now();
        textViewDate.setText(date.toString());
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        setVisibilityByTag(baseLayout, "additional", isChecked);
    }

    private void setVisibilityByTag(ViewGroup parent, String tag, boolean isChecked)
    {
        int childCount = parent.getChildCount();

        if (malfunction.getEnded() != null)
        {
            if (!isChecked)
                findViewById(R.id.warning).setVisibility(View.VISIBLE);
            else
                findViewById(R.id.warning).setVisibility(View.INVISIBLE);
        }

        for (int i = 0; i < childCount; i++)
        {
            View child = parent.getChildAt(i);

            // If the child is a ViewGroup, recursively call this method
            if (child instanceof ViewGroup)
                setVisibilityByTag((ViewGroup) child, tag, isChecked);

            // Check the tag and change visibility if it matches
            if (child.getTag() != null && child.getTag().toString().equals(tag))
                child.setVisibility(isChecked ? View.VISIBLE : View.GONE);
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

    public void onButtonApplyEditsClicked(View v)
    {
        boolean canContinue = true;

        // integrity checks
        if (fixedCheckBox.isChecked())
        {
            if (ViewTools.isEditTextEmpty(costView))
            {
                costView.setError(getString(R.string.error_field_cannot_be_empty));
                canContinue = false;
            }

            if (!ViewTools.dateFilled(dateEndedView))
            {
                Toast.makeText(this, getString(R.string.toast_please_select_date), Toast.LENGTH_SHORT).show();
                dateEndedView.setTextColor(getColor(R.color.red));
                canContinue = false;
            }
        }

        if (!canContinue) return;

        // apply edits to the object.
        if (!ViewTools.isEditTextEmpty(titleView))
            malfunction.setTitle(ViewTools.getFilteredViewSequence(titleView));

        if (!ViewTools.isEditTextEmpty(descView))
            malfunction.setDescription(ViewTools.getFilteredViewSequence(descView));

        if (!ViewTools.isEditTextEmpty(atKmView))
            malfunction.setAt_km(Integer.parseInt(ViewTools.getFilteredViewSequence(atKmView)));

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

    public void onSelectLocationClicked(View v)
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
            return;
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

    public void onDeleteLocationClicked(View v)
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