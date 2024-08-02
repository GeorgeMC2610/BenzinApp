package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.original.Car;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

public class ActivityEditAccount extends AppCompatActivity
{
    EditText username, manufacturer, model, year;
    CardView apply;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_account);

        // button + listener
        apply = findViewById(R.id.applyButton);
        apply.setOnClickListener(this::onButtonApplyEditsClicked);

        // edit texts
        username = findViewById(R.id.username);
        manufacturer = findViewById(R.id.manufacturer);
        model = findViewById(R.id.model);
        year = findViewById(R.id.year);

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

    private void onButtonApplyEditsClicked(View view)
    {
        // check data integrity before proceeding.
        if (!ViewTools.setErrors(this, manufacturer, model, year))
            return;

        // get the views' values.
        String manufacturer = ViewTools.getFilteredViewSequence(this.manufacturer);
        String model = ViewTools.getFilteredViewSequence(this.model);
        String year = ViewTools.getFilteredViewSequence(this.year);

        // call the request handler to edit the car properties.
        RequestHandler.getInstance().EditCar(this, manufacturer, model, year);
    }
}