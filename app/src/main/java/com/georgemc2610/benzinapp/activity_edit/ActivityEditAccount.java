package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.MenuItem;
import android.widget.EditText;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.original.Car;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;

public class ActivityEditAccount extends AppCompatActivity
{
    EditText username, manufacturer, model, year, capacity;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_account);

        // edit texts
        username = findViewById(R.id.edit_account_username_text);
        manufacturer = findViewById(R.id.edit_account_manufacturer_text);
        model = findViewById(R.id.edit_account_model_text);
        year = findViewById(R.id.edit_account_year_text);
        capacity = findViewById(R.id.edit_account_fuel_capacity_text);

        // car object with properties
        Car car = DataHolder.getInstance().car;

        // fill with values
        username.setText(car.getUsername());
        manufacturer.setText(car.getManufacturer());
        model.setText(car.getModel());
        year.setText(String.valueOf(car.getYear()));

        // action bar
        DisplayActionBarTool.displayActionBar(this, getString(R.string.settings_edit_account_label));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        if (item.getItemId() == android.R.id.home)
        {
            finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}