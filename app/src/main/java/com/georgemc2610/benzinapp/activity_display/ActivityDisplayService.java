package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.icu.text.NumberFormat;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.classes.original.Service;

import java.util.Locale;

public class ActivityDisplayService extends AppCompatActivity
{
    TextView atKmView, costView, dateHappenedView, descriptionView, nextAtKmView, locationView;
    Service service;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // init activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_service);

        // init views
        atKmView = findViewById(R.id.text_view_display_service_at_km);
        costView = findViewById(R.id.text_view_display_service_cost);
        dateHappenedView = findViewById(R.id.text_view_display_service_date_happened);
        descriptionView = findViewById(R.id.text_view_display_service_desc);
        nextAtKmView = findViewById(R.id.text_view_display_service_next_km);
        locationView = findViewById(R.id.text_view_display_service_location);

        // get the service
        service = (Service) getIntent().getSerializableExtra("service");

        // number format
        NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

        // set the required views data
        atKmView.setText(numberFormat.format(service.getAtKm()) + " " + getString(R.string.km_short));
        dateHappenedView.setText(service.getDateHappened().toString());
        descriptionView.setText(service.getDescription());

        // optional views data
        costView.setText(service.getCost() == 0f? "-" : "€" + numberFormat.format(service.getCost()));
        nextAtKmView.setText(service.getNextKm() == 0? "-" : numberFormat.format(service.getNextKm()) + " " + getString(R.string.km_short));
        locationView.setText("Not supported yet.");

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Service Data"); // TODO: Replace with string value
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
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void DeleteRecord(View view)
    {
        // build a confirmation dialog
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);

        dialog.setTitle(getString(R.string.dialog_delete_title));
        dialog.setMessage(getString(R.string.dialog_delete_confirmation));

        // when the button yes is clicked
        dialog.setPositiveButton(getString(R.string.dialog_yes), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // delete the record by its id.
                RequestHandler.getInstance().DeleteService(ActivityDisplayService.this, service.getId());

                // then close this activity
                finish();
            }
        });

        // when the button no is clicked
        dialog.setNegativeButton(getString(R.string.dialog_no), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // do nothing
            }
        });

        dialog.setCancelable(true);
        dialog.create().show();
    }
}