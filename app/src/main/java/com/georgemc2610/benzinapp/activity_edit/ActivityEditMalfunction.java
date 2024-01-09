package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.icu.text.NumberFormat;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditMalfunction extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener, Response.Listener<String>
{
    private LinearLayout linearLayout;
    private EditText titleView, descView, atKmView, costView;
    private TextView dateStartedView, dateEndedView, locationPickedView;
    private CheckBox fixedCheckBox;
    private Malfunction malfunction;
    int mYear, mDay, mMonth;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_malfunction);

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

        // get the views
        linearLayout = findViewById(R.id.linearLayoutEditMalfunction);

        titleView = findViewById(R.id.editTextEditMalfunctionTitle);
        descView = findViewById(R.id.editTextEditMalfunctionDesc);
        atKmView = findViewById(R.id.editTextEditMalfunctionAtKm);
        costView = findViewById(R.id.editTextEditMalfunctionCost);

        dateStartedView = findViewById(R.id.textViewEditMalfunctionDateStartedPicked);
        dateEndedView = findViewById(R.id.textViewEditMalfunctionDateEndedPicked);
        locationPickedView = findViewById(R.id.textViewEditMalfunctionLocationPicked);

        fixedCheckBox = findViewById(R.id.checkBoxEditMalfunctionFixed);

        // set the listeners.
        fixedCheckBox.setOnCheckedChangeListener(this);

        // get the fuel fill record passed to edit.
        malfunction = (Malfunction) getIntent().getSerializableExtra("malfunction");

        // from the malfunction object get and initialize data.
        titleView.setText(malfunction.getTitle());
        descView.setText(malfunction.getDescription());
        atKmView.setText(String.valueOf(malfunction.getAt_km()));
        dateStartedView.setText(malfunction.getStarted().toString());

        if (malfunction.getEnded() != null)
        {
            fixedCheckBox.setChecked(true);
            costView.setText(String.valueOf(malfunction.getCost()));
            dateEndedView.setText(malfunction.getEnded().toString());
        }
    }

    public void PickDate(View view)
    {
        // get calendar and dates to keep track of
        final Calendar calendar = Calendar.getInstance();
        mYear = calendar.get(Calendar.YEAR);
        mMonth = calendar.get(Calendar.MONTH);
        mDay = calendar.get(Calendar.DAY_OF_MONTH);

        TextView date = view.getId() == R.id.buttonEditMalfunctionDateStarted ? findViewById(R.id.textViewEditMalfunctionDateStartedPicked) : findViewById(R.id.textViewEditMalfunctionDateEndedPicked);

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
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked)
    {
        // get the child count of the linear layout.
        final int childCount = linearLayout.getChildCount();

        // for every child...
        for (int i = 0; i < childCount; i++)
        {
            // get the view object.
            final View view = linearLayout.getChildAt(i);

            // see if there are any tags.
            if (view.getTag() == null)
                continue;

            // and if there are and its tag is "additional", conditionally change its visibility.
            if (view.getTag().toString().equals("additional"))
                view.setVisibility(isChecked? View.VISIBLE : View.GONE);
        }
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
        boolean canContinue = true;

        // integrity checks
        if (fixedCheckBox.isChecked())
        {
            if (costView.getText().toString().trim().isEmpty())
            {
                costView.setError(getString(R.string.error_field_cannot_be_empty));
                canContinue = false;
            }

            if (dateEndedView.getText().toString().equals(getString(R.string.text_view_select_date)))
            {
                Toast.makeText(this, getString(R.string.toast_please_select_date), Toast.LENGTH_SHORT).show();
                canContinue = false;
            }
        }

        if (!canContinue) return;

        // apply edits to the object.
        if (!titleView.getText().toString().trim().isEmpty())
            malfunction.setTitle(titleView.getText().toString().trim());

        if (!descView.getText().toString().trim().isEmpty())
            malfunction.setDescription(descView.getText().toString().trim());

        if (!atKmView.getText().toString().trim().isEmpty())
            malfunction.setAt_km(Integer.parseInt(atKmView.getText().toString().trim()));

        malfunction.setStarted(LocalDate.parse(dateStartedView.getText().toString().trim()));

        // set optional data.
        if (fixedCheckBox.isChecked())
        {
            malfunction.setCost(Float.parseFloat(costView.getText().toString().trim()));
            malfunction.setEnded(LocalDate.parse(dateEndedView.getText().toString().trim()));
        }
        else
        {
            malfunction.setCost(-1f);
            malfunction.setEnded(null);
        }

        RequestHandler.getInstance().EditMalfunction(this, malfunction);
    }

    @Override
    public void onResponse(String response)
    {
        Toast.makeText(this, getString(R.string.toast_record_edited), Toast.LENGTH_LONG).show();
        finish();
    }
}