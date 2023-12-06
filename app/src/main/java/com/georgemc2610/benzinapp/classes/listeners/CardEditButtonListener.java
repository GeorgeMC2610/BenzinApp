package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Intent;
import android.view.View;
import com.georgemc2610.benzinapp.activity_edit.ActivityEditRecord;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.fragments.history.HistoryFragment;

/**
 * Listener for edit button. Once it's pressed, it will temporarily open a new activity to edit the record.
 * The listener takes the history fragment for context and the fuel fill record to provide to the activity afterwards.
 */
public class CardEditButtonListener implements View.OnClickListener
{
    private final HistoryFragment historyFragment;
    private final FuelFillRecord record;

    // required constructor for button listener.
    public CardEditButtonListener(HistoryFragment historyFragment, FuelFillRecord record)
    {
        this.historyFragment = historyFragment;
        this.record = record;
    }


    @Override
    public void onClick(View v)
    {
        // all the "edit" button does is open the ActivityEditRecord and pass the fuel fill record object to it.
        Intent intent = new Intent(historyFragment.getContext(), ActivityEditRecord.class);
        intent.putExtra("record", record);
        historyFragment.startActivity(intent);
    }
}
