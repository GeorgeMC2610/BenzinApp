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
import android.widget.Button;
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
import com.georgemc2610.benzinapp.classes.listeners.ButtonDateListener;
import com.georgemc2610.benzinapp.classes.listeners.ButtonLocationPicker;
import com.georgemc2610.benzinapp.classes.listeners.CoordinatesChangeListener;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditMalfunction extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener, Response.Listener<String>, CoordinatesChangeListener
{
    private LinearLayout baseLayout;
    private EditText titleView, descView, atKmView, costView;
    private TextView dateStartedView, dateEndedView, locationPickedView;
    private CheckBox fixedCheckBox;
    private Button selectDate, selectToday, selectDateFixed, selectTodayFixed, selectLocation, deleteLocation, apply;
    private Malfunction malfunction;
    private String address, coordinates;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_malfunction);

        // get the fuel fill record passed to edit.
        malfunction = (Malfunction) getIntent().getSerializableExtra("malfunction");

        // get the views
        baseLayout = findViewById(R.id.editMalfunctionLinearLayout);
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
        new ButtonDateListener(selectDate, selectToday, dateStartedView);
        new ButtonDateListener(selectDateFixed, selectTodayFixed, dateEndedView);
        new ButtonLocationPicker(selectLocation, deleteLocation, locationPickedView, this, malfunction.getLocation() == null, this);

        // set the listeners.
        fixedCheckBox.setOnCheckedChangeListener(this);
        fixedCheckBox.setChecked(false);

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

    @Override
    public void deleteCoordinates()
    {
        address = null;
        coordinates = null;
    }
}