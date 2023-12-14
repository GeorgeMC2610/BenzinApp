package com.georgemc2610.benzinapp.acitvity_add;

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
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.util.Calendar;

public class ActivityAddMalfunction extends AppCompatActivity implements Response.Listener<String>
{
    EditText titleView, descriptionView, atKmView;
    TextView dateView;
    private int mYear, mMonth, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_malfunction);

        // retrieve edit texts and text view
        titleView = findViewById(R.id.editTextMalfunctionTitle);
        descriptionView = findViewById(R.id.editTextMalfunctionDesc);
        atKmView = findViewById(R.id.editTextMalfunctionAtKm);
        dateView = findViewById(R.id.textViewMalfunctionDatePicked);

        // action bar
        // action bar
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Add Malfunction");
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
        return (atKmView.getText().toString().trim().length() != 0 ||
                titleView.getText().toString().trim().length() != 0 ||
                descriptionView.getText().toString().trim().length()  != 0);
    }

    public void OnButtonPickDateClicked(View view)
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
                dateView.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }

    public void OnButtonAddMalfunctionClicked(View view)
    {
        boolean validated = true;

        // all of the following fields are required. If any of those are not filled, display an error.
        if (atKmView.getText().toString().trim().length() == 0)
        {
            atKmView.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (titleView.getText().toString().trim().length() == 0)
        {
            titleView.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (descriptionView.getText().toString().trim().length() == 0)
        {
            descriptionView.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (dateView.getText().toString().trim().equals(getString(R.string.text_view_select_date)))
        {
            Toast.makeText(this, "Please select a date.", Toast.LENGTH_LONG).show();
            validated = false;
        }

        // if any of the above are empty or not filled, the system won't proceed.
        if (!validated)
            return;

        // get the data
        String at_km = atKmView.getText().toString().trim();
        String title = titleView.getText().toString().trim();
        String description = descriptionView.getText().toString().trim();
        String date = dateView.getText().toString().trim();

        // send the data to the cloud
        RequestHandler.getInstance().AddMalfunction(this, this, at_km, title, description, date);
    }

    @Override
    public void onResponse(String response)
    {
        Toast.makeText(this, getString(R.string.toast_record_added), Toast.LENGTH_LONG).show();
        finish();
    }
}