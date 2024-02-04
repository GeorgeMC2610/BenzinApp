package com.georgemc2610.benzinapp.activity_add;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.georgemc2610.benzinapp.MapsCreateTripActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import org.json.JSONException;
import org.json.JSONObject;

public class ActivityAddRepeatedTrip extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener
{
    private EditText title, timesRepeating;
    private CheckBox isRepeating;
    private TextView trip, totalKm, totalKmLegend;

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
        if (!setErrors(title, timesRepeating))
            return;

        String title = getFilteredViewSequence(this.title);
        int timesRepeating = Integer.parseInt(getFilteredViewSequence(this.timesRepeating));

        JSONObject jsonObject = new JSONObject();

        jsonObject.append("origin", 30.29182);
        jsonObject.append("origin", 49.29182);
        jsonObject.put("originAddress", "Karaiskaki 31, Athens, 15341");
        jsonObject.put("originCustomName", "HOME");

        jsonObject.append("destination", 39.2813);
        jsonObject.append("destination", 49.13928);
        jsonObject.put("destinationAddress", "Parakalo 39, Epistimi, 39910");
        jsonObject.put("destinationCustomName", "WORK");

        String trip1 = jsonObject.toString();

        RequestHandler.getInstance().AddRepeatedTrip(this, title, trip1, "ekei 2-0", timesRepeating, 59f);
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        timesRepeating.setText(isChecked? "1" : "");
        timesRepeating.setEnabled(!isChecked);
    }

    private boolean isAnyFieldFilled()
    {
        if (!isEditTextEmpty(title) || !isEditTextEmpty(timesRepeating))
            return true;

        return !getFilteredViewSequence(trip).equals("Select Trip...");
    }

    private boolean isEditTextEmpty(EditText editText)
    {
        return getFilteredViewSequence(editText).isEmpty();
    }

    private String getFilteredViewSequence(EditText editText)
    {
        return editText.getText().toString().trim();
    }

    private String getFilteredViewSequence(TextView textView)
    {
        return textView.getText().toString().trim();
    }

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
}