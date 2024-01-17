package com.georgemc2610.benzinapp.acitvity_add;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;

public class ActivityAddRepeatedTrip extends AppCompatActivity
{
    private EditText title, timesRepeating;
    private CheckBox isRepeating;
    private TextView origin, destination, totalKm;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_repeated_trip);

        // views
        title = findViewById(R.id.repeated_trips_edit_text_title);
        timesRepeating = findViewById(R.id.repeated_trips_edit_text_times_repeating);
        isRepeating = findViewById(R.id.repeated_trips_checkbox_not_repeating);
        origin = findViewById(R.id.repeated_trips_text_view_origin);
        destination = findViewById(R.id.repeated_trips_text_view_destination);
        totalKm = findViewById(R.id.repeated_trips_text_view_kilometers);

        // action bar
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.title_add_trip));
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

                if (isAnyFieldFilled())
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

    private boolean isAnyFieldFilled()
    {
        if (isEditTextEmpty(title) || isEditTextEmpty(timesRepeating))
            return true;

        return !getFilteredViewSequence(origin).equals(getString(R.string.text_view_select_location)) || !getFilteredViewSequence(destination).equals(getString(R.string.text_view_select_location));
    }

    private boolean isEditTextEmpty(EditText editText)
    {
        return getFilteredViewSequence(editText).isEmpty();
    }

    private String getFilteredViewSequence(EditText editText)
    {
        return editText.getText().toString().trim();
    }

    private String getFilteredViewSequence(TextView textView)
    {
        return textView.getText().toString().trim();
    }
}