package com.georgemc2610.benzinapp.activity_add;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.KeyboardButtonAppearingTool;
import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.time.LocalDate;
import java.util.Calendar;

public class ActivityAddMalfunction extends AppCompatActivity
{
    EditText titleView, descriptionView, atKmView;
    CardView pickDate, pickToday, add;
    TextView dateView;
    private int mYear, mMonth, mDay;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_malfunction);

        // retrieve edit texts and text view
        titleView = findViewById(R.id.title);
        descriptionView = findViewById(R.id.desc);
        atKmView = findViewById(R.id.atKm);
        dateView = findViewById(R.id.dateText);

        // buttons
        pickDate = findViewById(R.id.dateButton);
        pickToday = findViewById(R.id.todayButton);
        add = findViewById(R.id.addButton);

        // button listeners
        pickDate.setOnClickListener(this::onButtonPickDateClicked);
        pickToday.setOnClickListener(this::onButtonPickTodayDateClicked);
        add.setOnClickListener(this::onButtonAddMalfunctionClicked);

        // add listener for the keyboard showing.
        LinearLayout contentView = findViewById(R.id.addMalfunctionLinearLayout);
        new KeyboardButtonAppearingTool(contentView, add);

        // action bar
        DisplayActionBarTool.displayActionBar(this, getString(R.string.title_add_malfunction));
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
        return (atKmView.getText().toString().trim().length() != 0 ||
                titleView.getText().toString().trim().length() != 0 ||
                descriptionView.getText().toString().trim().length()  != 0);
    }

    private void onButtonPickDateClicked(View view)
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
                dateView.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
            }
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }

    private void onButtonPickTodayDateClicked(View v)
    {
        LocalDate date = LocalDate.now();
        dateView.setText(date.toString());
    }

    private void onButtonAddMalfunctionClicked(View view)
    {
        boolean validated = true;

        // all of the following fields are required. If any of those are not filled, display an error.
        if (ViewTools.isEditTextEmpty(atKmView))
        {
            atKmView.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (ViewTools.isEditTextEmpty(titleView))
        {
            titleView.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (ViewTools.isEditTextEmpty(descriptionView))
        {
            descriptionView.setError(getString(R.string.error_field_cannot_be_empty));
            validated = false;
        }

        if (!ViewTools.dateFilled(dateView))
        {
            Toast.makeText(this, getString(R.string.toast_please_select_date), Toast.LENGTH_LONG).show();
            validated = false;
        }

        // if any of the above are empty or not filled, the system won't proceed.
        if (!validated)
            return;

        // get the data
        String at_km = ViewTools.getFilteredViewSequence(atKmView);
        String title = ViewTools.getFilteredViewSequence(titleView);
        String description = ViewTools.getFilteredViewSequence(descriptionView);
        String date = ViewTools.getFilteredViewSequence(dateView);

        // send the data to the cloud
        RequestHandler.getInstance().AddMalfunction(this, at_km, title, description, date);
    }
}