package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.icu.text.NumberFormat;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.style.UnderlineSpan;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.georgemc2610.benzinapp.activity_maps.MapsDisplayPointActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.classes.original.Service;

import java.util.Locale;

public class ActivityDisplayService extends AppCompatActivity
{
    TextView atKmView, costView, dateHappenedView, descriptionView, nextAtKmView, locationView;
    String location;
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
        costView.setText(service.getCost() == -1f? "-" : "€" + numberFormat.format(service.getCost()));
        nextAtKmView.setText(service.getNextKm() == -1? "-" : numberFormat.format(service.getNextKm()) + " " + getString(R.string.km_short));
        locationView.setText(service.getLocation());

        // if the service location exists...
        if (service.getLocation() != null && !service.getLocation().isEmpty())
        {
            // it must be in the format: <address>|<coordinates>
            if (service.getLocation().contains("|"))
            {
                // if it is, split it and get the coordinates and address.
                String[] locationSplit = service.getLocation().split("\\|");

                // display the address and make it clickable.
                SpannableString address = new SpannableString(locationSplit[0]);
                address.setSpan(new UnderlineSpan(), 0, locationSplit[0].length(), 0);

                // make the text clickable with an underline.
                locationView.setText(address, TextView.BufferType.SPANNABLE);
                locationView.setClickable(true);
                locationView.setTextColor(Color.BLUE);

                // store locally the coordinates
                location = locationSplit[1];

                // once the location is clicked, then display the point marker.
                locationView.setOnClickListener(v ->
                {
                    Intent intent = new Intent(ActivityDisplayService.this, MapsDisplayPointActivity.class);
                    intent.putExtra("coordinates", locationSplit[1]);
                    intent.putExtra("address", locationSplit[0]);
                    startActivity(intent);
                });
            }
            // if it's not, then the ability to see the location on the map will be disabled
            else
            {
                // display the text as normal.
                locationView.setText(service.getLocation());
                location = null;

            }
        }
        // otherwise if the location doesn't exist, then just show a dash.
        else
            locationView.setText("-");


        // action bar with back button and correct title name.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_display_service));
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