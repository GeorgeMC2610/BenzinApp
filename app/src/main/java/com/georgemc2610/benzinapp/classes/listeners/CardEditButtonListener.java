package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Intent;
import android.view.View;
import com.georgemc2610.benzinapp.ActivityEditRecord;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.ui.history.HistoryFragment;

/**
 * Listener for edit button. Once it's pressed, it will temporarily open a new activity to edit the record.
 * The listener takes the history fragment for context and the fuel fill record to provide to the activity afterwards.
 */
public class CardEditButtonListener implements View.OnClickListener
{
    private final HistoryFragment historyFragment;
    private final FuelFillRecord record;

    public CardEditButtonListener(HistoryFragment historyFragment, FuelFillRecord record)
    {
        this.historyFragment = historyFragment;
        this.record = record;
    }


    @Override
    public void onClick(View v)
    {
        Intent intent = new Intent(historyFragment.getContext(), ActivityEditRecord.class);
        intent.putExtra("record", record);
        historyFragment.startActivity(intent);
    }
}
