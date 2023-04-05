package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.motion.widget.Debug;
import androidx.core.app.NavUtils;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.RequestHandler;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;

public class ActivityAddRecord extends AppCompatActivity implements Response.Listener<String>
{
    EditText editTextLiters, editTextCost, editTextKilometers, editTextDate, editTextPetrolType, editTextStation, editTextNotes;
    int mYear, mMonth, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_record);

        // get edit texts.
        editTextLiters = findViewById(R.id.editTextLiters);
        editTextCost = findViewById(R.id.editTextCost);
        editTextKilometers = findViewById(R.id.editTextKilometers);
        editTextPetrolType = findViewById(R.id.editTextPetrolType);
        editTextDate = findViewById(R.id.editTextDate);
        editTextStation = findViewById(R.id.editTextStation);
        editTextNotes = findViewById(R.id.editTextNotes);


        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getResources().getString(R.string.title_add_record));
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
        return (editTextKilometers.getText().toString().trim().length() != 0 ||
                editTextLiters.getText().toString().trim().length() != 0 ||
                editTextCost.getText().toString().trim().length() != 0 ||
                editTextPetrolType.getText().toString().trim().length() != 0 ||
                editTextDate.getText().toString().trim().length() != 0);
    }

    public void OnButtonAddClicked(View v)
    {
        int validation_counter = 0;

        // if one of the necessary edit texts are empty, don't proceed.
        if (editTextCost.getText().toString().length() == 0)
        {
            editTextCost.setError(getResources().getString(R.string.error_field_cannot_be_empty));
            validation_counter--;
        }

        if (editTextLiters.getText().toString().length() == 0)
        {
            editTextLiters.setError(getResources().getString(R.string.error_field_cannot_be_empty));
            validation_counter--;
        }

        if (editTextKilometers.getText().toString().length() == 0)
        {
            editTextKilometers.setError(getResources().getString(R.string.error_field_cannot_be_empty));
            validation_counter--;
        }

        // there must be exactly correct validations to proceed.
        if (validation_counter != 0)
            return;

        float liters = Float.parseFloat(editTextLiters.getText().toString());
        float cost = Float.parseFloat(editTextCost.getText().toString());
        float kilometers = Float.parseFloat(editTextKilometers.getText().toString());
        String petrolType = editTextPetrolType.getText().toString();
        String station = editTextStation.getText().toString();
        String notes = editTextNotes.getText().toString();

        LocalDate date = LocalDate.parse(editTextDate.getText().toString());

        // proceed to add properties.
        // DatabaseManager.getInstance().AddRecord(liters, cost, kilometers, date, editTextPetrolType.getText().toString());
        RequestHandler.getInstance().AddFuelFillRecord(this, this, kilometers, liters, cost, petrolType, station, date, notes);
    }

    public void OnEditTextDateTimeClicked(View v)
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
                editTextDate.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }

    @Override
    public void onResponse(String response)
    {
        finish();
    }
}