package com.georgemc2610.benzinapp.activity_edit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.KeyboardButtonAppearingTool;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityEditRecord extends AppCompatActivity
{
    private FuelFillRecord record;
    private EditText editTextLiters, editTextCost, editTextKilometers, editTextPetrolType, editTextStation, editTextNotes;
    private TextView textViewDate;
    private CardView pickDate, pickToday, applyEdits;
    int mYear, mDay, mMonth;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // necessary code for activity creation.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_record);

        // get the fuel fill record passed to edit.
        record = (FuelFillRecord) getIntent().getSerializableExtra("record");

        // get edit texts.
        editTextLiters     = findViewById(R.id.liters);
        editTextCost       = findViewById(R.id.cost);
        editTextKilometers = findViewById(R.id.kilometers);
        editTextPetrolType = findViewById(R.id.fuelType);
        textViewDate       = findViewById(R.id.dateText);
        editTextStation    = findViewById(R.id.fuelStation);
        editTextNotes      = findViewById(R.id.notes);

        // buttons.
        pickDate = findViewById(R.id.dateButton);
        pickToday = findViewById(R.id.todayButton);
        applyEdits = findViewById(R.id.applyEditsButton);

        // button listeners.
        pickDate.setOnClickListener(this::onEditTextDateTimeClicked);
        pickToday.setOnClickListener(this::onButtonPickTodayDateClicked);
        applyEdits.setOnClickListener(this::onButtonApplyEditsClicked);

        // apply text to the edit texts.
        editTextLiters    .setText(String.valueOf(record.getLiters()));
        editTextCost      .setText(String.valueOf(record.getCost_eur()));
        editTextKilometers.setText(String.valueOf(record.getKilometers()));
        textViewDate      .setText(String.valueOf(record.getDate()));
        editTextPetrolType.setText(record.getFuelType());
        editTextStation   .setText(record.getStation());
        editTextNotes     .setText(record.getNotes());

        // add listener for the keyboard showing.
        LinearLayout contentView = findViewById(R.id.editRecordLinearLayout);
        new KeyboardButtonAppearingTool(contentView, applyEdits);

        // action bar.
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_edit_record));
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

    private void onButtonApplyEditsClicked(View v)
    {
        // get floats (that will be nulled if empty)
        Float newLiters     = getFloatFromEditText(editTextLiters);
        Float newCost       = getFloatFromEditText(editTextCost);
        Float newKilometers = getFloatFromEditText(editTextKilometers);

        // get strings (that will be nulled if empty)
        String newPetrolType = getStringFromEditText(editTextPetrolType);
        String newStation    = getStringFromEditText(editTextStation);
        String newNotes      = getStringFromEditText(editTextNotes);

        // parse the date
        String date = textViewDate.getText().toString().trim();
        LocalDate newDate = LocalDate.parse(date);

        // edit the object
        if (newLiters != null)
            record.setLiters(newLiters);

        if (newCost != null)
            record.setCost_eur(newCost);

        if (newKilometers != null)
            record.setKilometers(newKilometers);

        if (newPetrolType != null)
            record.setFuelType(newPetrolType);
        else
            record.setFuelType("");

        if (newStation != null)
            record.setStation(newStation);
        else
            record.setStation("");

        record.setDate(newDate);

        if (newNotes != null)
            record.setNotes(newNotes);
        else
            record.setNotes("");

        // send the request.
        RequestHandler.getInstance().EditFuelFillRecord(this, record);
    }

    /**
     * From any "EditText" view, takes the text and gets the Float type from it. If it's empty, it nullifies it.
     * @param editText Any EditText view that contains a floating point number.
     * @return An object of type Float.
     */
    private Float getFloatFromEditText(EditText editText)
    {
        return editText.getText().toString().trim().isEmpty() ? null : Float.parseFloat(editText.getText().toString().trim());
    }

    /**
     * From any "EditText" view, takes the text and trims it. If the text is empty it nullifies it.
     * @param editText Any EditText view that contains text.
     * @return An object of type String.
     */
    private String getStringFromEditText(EditText editText)
    {
        return editText.getText().toString().trim().isEmpty() ? null : editText.getText().toString().trim();
    }

    private void onButtonPickTodayDateClicked(View v)
    {
        LocalDate date = LocalDate.now();
        textViewDate.setText(date.toString());
    }

    private void onEditTextDateTimeClicked(View v)
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
                textViewDate.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }
}