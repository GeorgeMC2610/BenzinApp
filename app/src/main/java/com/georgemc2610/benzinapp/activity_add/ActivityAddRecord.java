package com.georgemc2610.benzinapp.activity_add;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.KeyboardButtonAppearingTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.listeners.ButtonDateListener;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityAddRecord extends AppCompatActivity
{
    EditText editTextLiters, editTextCost, editTextKilometers, editTextPetrolType, editTextStation, editTextNotes;
    TextView textViewDate;
    Button buttonAdd, buttonPickDate, buttonPickToday;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_record);

        // get edit texts.
        editTextLiters = findViewById(R.id.liters);
        editTextCost = findViewById(R.id.cost);
        editTextKilometers = findViewById(R.id.kilometers);
        editTextPetrolType = findViewById(R.id.fuelType);
        textViewDate = findViewById(R.id.dateText);
        editTextStation = findViewById(R.id.fuelStation);
        editTextNotes = findViewById(R.id.notes);

        // add button listener
        buttonAdd = findViewById(R.id.addButton);
        buttonAdd.setOnClickListener(this::onButtonAddClicked);

        // location buttons and listeners
        buttonPickDate = findViewById(R.id.dateButton);
        buttonPickToday = findViewById(R.id.todayButton);
        new ButtonDateListener(buttonPickDate, buttonPickToday, textViewDate);

        // add listener for the keyboard showing.
        LinearLayout contentView = findViewById(R.id.addRecordLinearLayout);
        new KeyboardButtonAppearingTool(contentView, buttonAdd);

        // action bar.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_add_record));
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

                    dialog.setPositiveButton(R.string.dialog_yes, (dialog12, which) -> finish());

                    dialog.setNegativeButton(R.string.dialog_no, (dialog1, which) -> {
                        // foo.
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
                editTextPetrolType.getText().toString().trim().length() != 0);
    }

    public void onButtonAddClicked(View v)
    {
        if (!ViewTools.setErrors(this, editTextCost, editTextKilometers, editTextLiters))
            return;

        if (!ViewTools.dateFilled(textViewDate))
        {
            Toast.makeText(this, getString(R.string.toast_please_select_date), Toast.LENGTH_SHORT).show();
            return;
        }

        float liters = Float.parseFloat(editTextLiters.getText().toString());
        float cost = Float.parseFloat(editTextCost.getText().toString());
        float kilometers = Float.parseFloat(editTextKilometers.getText().toString());
        String petrolType = editTextPetrolType.getText().toString();
        String station = editTextStation.getText().toString();
        String notes = editTextNotes.getText().toString();
        LocalDate date = LocalDate.parse(textViewDate.getText().toString());

        RequestHandler.getInstance().AddFuelFillRecord(this, kilometers, liters, cost, petrolType, station, date, notes);
    }
}