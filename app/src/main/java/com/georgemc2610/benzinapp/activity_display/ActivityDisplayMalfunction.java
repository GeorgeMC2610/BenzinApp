package com.georgemc2610.benzinapp.activity_display;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

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
import android.widget.Button;
import android.widget.TextView;

import com.georgemc2610.benzinapp.activity_edit.ActivityEditMalfunction;
import com.georgemc2610.benzinapp.activity_edit.ActivityEditService;
import com.georgemc2610.benzinapp.activity_maps.MapsDisplayPointActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.util.Locale;

public class ActivityDisplayMalfunction extends AppCompatActivity
{
    TextView titleView, descriptionView, startedView, endedView, atKmView, costView, locationView, statusView;
    Button delete, edit;
    CardView fixedData;
    String coordinates;
    Malfunction malfunction;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize view
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_malfunction);

        // get text views
        titleView = findViewById(R.id.text_view_display_malfunction_title);
        descriptionView = findViewById(R.id.text_view_display_malfunction_desc);
        startedView = findViewById(R.id.text_view_display_malfunction_date_started);
        endedView = findViewById(R.id.text_view_display_malfunction_date_ended);
        atKmView = findViewById(R.id.text_view_display_malfunction_discovered_at_km);
        costView = findViewById(R.id.text_view_display_malfunction_cost);
        locationView = findViewById(R.id.text_view_display_malfunction_location);
        statusView = findViewById(R.id.text_view_display_malfunction_status);

        // get the buttons (cards) and the fixed data card view.
        delete = findViewById(R.id.buttonDelete);
        edit = findViewById(R.id.buttonEdit);
        fixedData = findViewById(R.id.card_fix);

        // get the serializable object
        malfunction = (Malfunction) getIntent().getSerializableExtra("malfunction");

        // assign view's values
        assignViewValues();

        // action bar.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_display_malfunction));
    }

    @Override
    protected void onResume()
    {
        super.onResume();
        malfunction = DataHolder.getInstance().malfunctions.stream()
                .filter(m -> m.getId() == malfunction.getId())
                .findFirst().get();
        assignViewValues();
    }

    private void assignViewValues()
    {
        // get number format
        NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

        // set required views content
        titleView.setText(malfunction.getTitle());
        descriptionView.setText(malfunction.getDescription());
        startedView.setText(malfunction.getStarted().toString());
        atKmView.setText(numberFormat.format(malfunction.getAt_km()) + " " + getString(R.string.km_short));

        // Set "status" depending on the actual status.
        statusView.setText(malfunction.getEnded() == null? getText(R.string.card_view_malfunction_ongoing) : getText(R.string.card_view_malfunction_fixed));
        statusView.setTextColor(malfunction.getEnded() == null? getColor(R.color.dark_red) : getColor(R.color.dark_green));

        // Set Card Visibility depending on the malfunction's status.
        fixedData.setVisibility(malfunction.getEnded() == null? View.GONE : View.VISIBLE);

        // set optional views content
        endedView.setText(malfunction.getEnded() == null? "-" : malfunction.getEnded().toString());
        costView.setText(malfunction.getCost() == -1f? "-" : "€" + numberFormat.format(malfunction.getCost()));

        // set the buttons' listeners
        delete.setOnClickListener(this::DeleteRecord);
        edit.setOnClickListener(this::EditRecord);

        // if the malfunction location exists...
        if (malfunction.getLocation() != null && !malfunction.getLocation().isEmpty())
        {
            // it must be in the format: <address>|<coordinates>
            if (malfunction.getLocation().contains("|"))
            {
                // if it is, split it and get the coordinates and address.
                String[] locationSplit = malfunction.getLocation().split("\\|");

                // display the address and make it clickable.
                SpannableString address = new SpannableString(locationSplit[0]);
                address.setSpan(new UnderlineSpan(), 0, locationSplit[0].length(), 0);

                // make the text clickable with an underline.
                locationView.setText(address, TextView.BufferType.SPANNABLE);
                locationView.setClickable(true);
                locationView.setTextColor(Color.BLUE);

                // once the location is clicked, then display the point marker.
                locationView.setOnClickListener(v ->
                {
                    Intent intent = new Intent(ActivityDisplayMalfunction.this, MapsDisplayPointActivity.class);
                    intent.putExtra("coordinates", locationSplit[1]);
                    intent.putExtra("address", locationSplit[0]);
                    startActivity(intent);
                });
            }
            // if it's not, then the ability to see the location on the map will be disabled
            else
            {
                // display the text as normal.
                locationView.setText(malfunction.getLocation());
                coordinates = null;
            }
        }
        // otherwise if the location doesn't exist, then just show a dash.
        else
            locationView.setText("-");
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

    private void EditRecord(View v)
    {
        Intent intent = new Intent(this, ActivityEditMalfunction.class);
        intent.putExtra("malfunction", malfunction);
        startActivity(intent);
    }

    public void DeleteRecord(View v)
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
                RequestHandler.getInstance().DeleteMalfunction(ActivityDisplayMalfunction.this, malfunction.getId());

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