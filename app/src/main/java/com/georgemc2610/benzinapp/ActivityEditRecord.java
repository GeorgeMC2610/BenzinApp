package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;

import java.time.LocalDate;

public class ActivityEditRecord extends AppCompatActivity implements Response.Listener<String>
{
    private FuelFillRecord record;
    private EditText editTextLiters, editTextCost, editTextKilometers, editTextDate, editTextPetrolType, editTextStation, editTextNotes;
    private Button buttonApply;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // necessary code for activity creation.
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_record);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Edit Record");
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // get the fuel fill record passed to edit.
        record = (FuelFillRecord) getIntent().getSerializableExtra("record");

        // get edit texts.
        editTextLiters     = findViewById(R.id.editTextLitersEdit);
        editTextCost       = findViewById(R.id.editTextCostEdit);
        editTextKilometers = findViewById(R.id.editTextKilometersEdit);
        editTextPetrolType = findViewById(R.id.editTextPetrolTypeEdit);
        editTextDate       = findViewById(R.id.editTextDateEdit);
        editTextStation    = findViewById(R.id.editTextStationEdit);
        editTextNotes      = findViewById(R.id.editTextNotesEdit);

        // apply text to the edit texts.
        editTextLiters    .setText(String.valueOf(record.getLiters()));
        editTextCost      .setText(String.valueOf(record.getCost_eur()));
        editTextKilometers.setText(String.valueOf(record.getKilometers()));
        editTextDate      .setText(String.valueOf(record.getDate()));
        editTextPetrolType.setText(record.getFuelType());
        editTextStation   .setText(record.getStation());
        editTextNotes     .setText(record.getNotes());

        // lock some properties.
        editTextDate.setEnabled(false);

        // get the button and set its listener.
        buttonApply = findViewById(R.id.buttonApplyEdits);
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
        // get floats (that will be nulled if empty)
        Float newLiters     = getFloatFromEditText(editTextLiters);
        Float newCost       = getFloatFromEditText(editTextCost);
        Float newKilometers = getFloatFromEditText(editTextKilometers);

        // get strings (that will be nulled if empty)
        String newPetrolType = getStringFromEditText(editTextPetrolType);
        String newStation    = getStringFromEditText(editTextStation);
        String newNotes      = getStringFromEditText(editTextNotes);

        // send the request.
        RequestHandler.getInstance().EditFuelFillRecord(this, this, record.getId(), newKilometers, newLiters, newCost, newPetrolType, newStation, newNotes);
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

    @Override
    public void onResponse(String response)
    {
        Toast.makeText(this, "Record Successfully Edited.", Toast.LENGTH_LONG).show();
        finish();
    }
}