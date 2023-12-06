package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityAddService extends AppCompatActivity implements Response.Listener<String>
{
    EditText atKm, nextKm, costEur, notes;
    TextView location, date;
    int mYear, mMonth, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_service);

        // get edit texts and text views.
        atKm = findViewById(R.id.editTextServiceAtKilometers);
        nextKm = findViewById(R.id.editTextServiceNextKm);
        costEur = findViewById(R.id.editTextServiceCost);
        notes = findViewById(R.id.editTextServiceDescription);
        location = findViewById(R.id.textViewServiceLocation);
        date = findViewById(R.id.textViewServiceDatePicked);

        // action bar
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Add Service");
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

    public void OnButtonAddClicked(View v)
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
        int at_km = Integer.parseInt(atKm.getText().toString().trim());
        int next_km = Integer.parseInt(nextKm.getText().toString().trim());
        float cost_eur = Float.parseFloat(costEur.getText().toString().trim());
        String description = notes.getText().toString().trim();
        String locationString = location.getText().toString().trim();
        LocalDate date_happened = LocalDate.parse(date.getText().toString().trim());

        // send it to the cloud.
        RequestHandler.getInstance().AddService(this, this, at_km, cost_eur, description, locationString, date_happened, next_km);
    }

    public void OnPickDateClicked(View v)
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

    @Override
    public void onResponse(String response)
    {
        Toast.makeText(this, getString(R.string.toast_record_added), Toast.LENGTH_LONG).show();
        finish();
    }
}