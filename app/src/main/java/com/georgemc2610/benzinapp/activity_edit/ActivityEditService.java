package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MapsActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.acitvity_add.ActivityAddService;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.classes.original.Service;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditService extends AppCompatActivity
{
    Service service;
    EditText atKmView, descView, nextKmView, costView;
    TextView datePickedView, locationView;
    int mMonth, mYear, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_service);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.title_edit_record));
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // get views
        atKmView = findViewById(R.id.editTextEditServiceAtKilometers);
        descView = findViewById(R.id.editTextEditServiceDescription);
        nextKmView = findViewById(R.id.editTextEditServiceNextKm);
        costView = findViewById(R.id.editTextEditServiceCost);
        datePickedView = findViewById(R.id.textViewEditServiceDatePicked);
        locationView = findViewById(R.id.textViewEditServiceLocationPicked);

        // get the fuel fill record passed to edit.
        service = (Service) getIntent().getSerializableExtra("service");

        // set the views' required texts
        atKmView.setText(String.valueOf(service.getAtKm()));
        descView.setText(service.getDescription());

        // set the views' optional texts
        nextKmView.setText(service.getNextKm() == -1f? "" :  String.valueOf(service.getNextKm()));
        costView.setText(service.getCost() == -1f? "" : String.valueOf(service.getCost()));
        datePickedView.setText(service.getDateHappened().toString());
        locationView.setText(service.getLocation() == null? getString(R.string.text_view_select_location) : service.getLocation());
    }

    public void PickDate(View view)
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
                datePickedView.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
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

        // send request with applied edits.
        RequestHandler.getInstance().EditService(this, service);
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
            builder.setNeutralButton("OK", (dialog, which) -> ActivityCompat.requestPermissions(ActivityEditService.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 9918));
            builder.show();
        }

        // the user actually wants to replace this location if it's already picked.
        if (service.getLocation() != null)
        {
            // create a dialog that informs them.
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setMessage(getString(R.string.dialog_select_new_location_confirm));

            // the YES button opens the google maps activity.
            builder.setPositiveButton(R.string.dialog_yes, (dialog, which) ->
            {
                Intent intent = new Intent(ActivityEditService.this, MapsActivity.class);
                startActivity(intent);
            });

            // the no button cancels.
            builder.setNegativeButton(R.string.dialog_no, (dialog, which) -> {});

            builder.show();
            return;
        }

        // in any other case, the maps activity can open regularly.
        Intent intent = new Intent(this, MapsActivity.class);
        startActivity(intent);
    }

    public void OnDeleteLocationClicked(View v)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(R.string.dialog_location_deletion_confirmation);
        builder.setCancelable(true);

        builder.setPositiveButton(R.string.dialog_yes, new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                locationView.setText(R.string.text_view_select_location);

            }
        });
    }
}