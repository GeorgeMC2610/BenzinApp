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
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.georgemc2610.benzinapp.activity_maps.MapsSelectPointActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.KeyboardButtonAppearingTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.listeners.ButtonDateListener;
import com.georgemc2610.benzinapp.classes.listeners.ButtonLocationPicker;
import com.georgemc2610.benzinapp.classes.listeners.CoordinatesChangeListener;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.classes.original.Service;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditService extends AppCompatActivity implements CoordinatesChangeListener
{
    Service service;
    LinearLayout layout;
    EditText atKmView, descView, nextKmView, costView;
    Button pickDate, pickToday, pickLocation, deleteLocation, applyEdits;
    String coordinates, address;
    TextView datePickedView, locationView;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_service);

        // get views
        atKmView = findViewById(R.id.atKm);
        descView = findViewById(R.id.desc);
        nextKmView = findViewById(R.id.nextKm);
        costView = findViewById(R.id.cost);
        datePickedView = findViewById(R.id.dateText);
        locationView = findViewById(R.id.locationText);
        layout = findViewById(R.id.editServiceLinearLayout);

        // get the buttons
        applyEdits = findViewById(R.id.applyButton);
        pickDate = findViewById(R.id.dateButton);
        pickToday = findViewById(R.id.todayButton);
        pickLocation = findViewById(R.id.locationButton);
        deleteLocation = findViewById(R.id.deleteLocationButton);

        // get the fuel fill record passed to edit.
        service = (Service) getIntent().getSerializableExtra("service");

        // button listeners
        new ButtonDateListener(pickDate, pickToday, datePickedView);
        new ButtonLocationPicker(pickLocation, deleteLocation, locationView, this, service.getLocation() != null, this);
        applyEdits.setOnClickListener(this::onButtonApplyEditsClicked);

        // set the views' required texts
        atKmView.setText(String.valueOf(service.getAtKm()));
        descView.setText(service.getDescription());

        // set the views' optional texts
        nextKmView.setText(service.getNextKm() == -1f? "" :  String.valueOf(service.getNextKm()));
        costView.setText(service.getCost() == -1f? "" : String.valueOf(service.getCost()));
        datePickedView.setText(service.getDateHappened().toString());
        locationView.setText(service.getLocation() == null? getString(R.string.text_view_select_location) : service.getLocation());

        // keyboard hider
        new KeyboardButtonAppearingTool(layout, applyEdits);

        // action bar with back button and correct title name.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_edit_service));
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
            locationView.setText(address);
    }

    private void onButtonApplyEditsClicked(View v)
    {
        // set the object's data.
        if (!atKmView.getText().toString().trim().isEmpty())
            service.setAtKm(Integer.parseInt(atKmView.getText().toString().trim()));

        if (!descView.getText().toString().trim().isEmpty())
            service.setDescription(descView.getText().toString().trim());

        service.setDateHappened(LocalDate.parse(datePickedView.getText().toString()));

        // optional data can be null
        if (costView.getText().toString().trim().isEmpty())
            service.setCost(-1f);
        else
            service.setCost(Float.parseFloat(costView.getText().toString().trim()));

        if (nextKmView.getText().toString().trim().isEmpty())
            service.setNextKm(-1);
        else
            service.setNextKm(Integer.parseInt(nextKmView.getText().toString().trim()));

        // TODO: Will need change
        if (ViewTools.getFilteredViewSequence(locationView).equalsIgnoreCase("select location"))
            service.setLocation("");
        else if (address != null && coordinates != null)
            service.setLocation(address + '|' + coordinates);

        // send request with applied edits.
        RequestHandler.getInstance().EditService(this, service);
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