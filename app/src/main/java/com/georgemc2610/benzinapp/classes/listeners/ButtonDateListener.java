package com.georgemc2610.benzinapp.classes.listeners;

import android.app.DatePickerDialog;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.time.LocalDate;
import java.util.Calendar;

/**
 * <h2>Main Purpose</h2>
 * From the shared layout <code>select_date</code> there are two buttons and one text view. This class
 * assigns the correct listeners to the "Select Date" button and "Select Today" button. These two buttons
 * modify the date text view, which then displays the correct date picked.
 */
public class ButtonDateListener
{
    private Button pickDateButton, pickTodayButton;
    private TextView dateTextView;

    private int mYear, mMonth, mDay;


    public ButtonDateListener(Button pickDateButton, Button pickTodayButton, TextView dateTextView)
    {
        this.pickDateButton = pickDateButton;
        this.pickTodayButton = pickTodayButton;
        this.dateTextView = dateTextView;

        this.pickDateButton.setOnClickListener(this::onButtonPickDateClicked);
        this.pickTodayButton.setOnClickListener(this::onButtonPickTodayDateClicked);
    }

    private void onButtonPickTodayDateClicked(View v)
    {
        LocalDate date = LocalDate.now();
        dateTextView.setText(date.toString());
    }

    private void onButtonPickDateClicked(View v)
    {
        // get calendar and dates to keep track of
        final Calendar calendar = Calendar.getInstance();
        mYear = calendar.get(Calendar.YEAR);
        mMonth = calendar.get(Calendar.MONTH);
        mDay = calendar.get(Calendar.DAY_OF_MONTH);

        // date picker dialog shows up
        DatePickerDialog datePickerDialog = new DatePickerDialog(dateTextView.getContext(), (view, year, month, dayOfMonth) ->
        {
            // and when it updates, it sets the value of the edit text.
            dateTextView.setText(year + "-" + (month < 9 ? "0" + (++month) : ++month) + "-" + (dayOfMonth < 10? "0" + dayOfMonth : dayOfMonth));
        }, mYear, mMonth, mDay);

        // show the dialog.
        datePickerDialog.show();
    }

}
