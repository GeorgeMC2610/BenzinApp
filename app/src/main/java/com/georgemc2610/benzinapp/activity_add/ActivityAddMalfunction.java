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
import android.widget.DatePicker;
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

public class ActivityAddMalfunction extends AppCompatActivity
{
    EditText titleView, descriptionView, atKmView;
    Button pickDate, pickToday, add;
    TextView dateView;

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
        add.setText(R.string.button_add_malfunction);

        // button listeners
        new ButtonDateListener(pickDate, pickToday, dateView);
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

    private void onButtonAddMalfunctionClicked(View view)
    {
        boolean validated = true;

        // these fields must be filled.
        if (!ViewTools.setErrors(this, atKmView, titleView, descriptionView))
            validated = false;

        // date must be filled.
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