package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.Malfunction;

public class ActivityEditMalfunction extends AppCompatActivity implements CompoundButton.OnCheckedChangeListener
{
    private LinearLayout linearLayout;
    private EditText titleView, descView, atKmView, costView;
    private TextView dateStartedView, dateEndedView, locationPickedView;
    private CheckBox fixedCheckBox;
    private Malfunction malfunction;


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

}