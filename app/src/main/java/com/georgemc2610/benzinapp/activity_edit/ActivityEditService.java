package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
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
import com.georgemc2610.benzinapp.classes.original.Service;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditService extends AppCompatActivity
{
    Service service;
    EditText atKmView, descView, nextKmView, costView;
    TextView datePickedView;
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

        // get the fuel fill record passed to edit.
        service = (Service) getIntent().getSerializableExtra("service");

        // set the views' texts
        atKmView.setText(String.valueOf(service.getAtKm()));
        descView.setText(service.getDescription());
        nextKmView.setText(String.valueOf(service.getNextKm()));
        costView.setText(String.valueOf(service.getCost()));
        datePickedView.setText(service.getDateHappened().toString());
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
            service.setCost(0f);
        else
            service.setCost(Float.parseFloat(costView.getText().toString().trim()));

        if (nextKmView.getText().toString().trim().isEmpty())
            service.setNextKm(0);
        else
            service.setNextKm(Integer.parseInt(nextKmView.getText().toString().trim()));

        // send request with applied edits.
        RequestHandler.getInstance().EditService(this, service);
    }
}