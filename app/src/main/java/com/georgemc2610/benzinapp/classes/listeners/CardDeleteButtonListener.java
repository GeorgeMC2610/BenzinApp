package com.georgemc2610.benzinapp.classes.listeners;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.View;

import com.georgemc2610.benzinapp.ActivityEditRecord;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.ui.history.HistoryFragment;

/**
 * Listener for delete button. Once it's pressed, it will show a dialog box for confirmation.
 * "Yes" and "No" buttons are provided. When "Yes" is pressed, it will delete the fuel fill record.
 */
public class CardDeleteButtonListener implements View.OnClickListener
{
    private final HistoryFragment historyFragment;
    private final FuelFillRecord record;

    // required constructor for the listener to previously have all the data available.
    public CardDeleteButtonListener(HistoryFragment historyFragment, FuelFillRecord record)
    {
        this.historyFragment = historyFragment;
        this.record = record;
    }


    @Override
    public void onClick(View v)
    {
        // create a dialog builder.
        AlertDialog.Builder dialog = new AlertDialog.Builder(historyFragment.getContext());

        // set titles and warning message.
        dialog.setTitle(historyFragment.getString(R.string.dialog_delete_title));
        dialog.setMessage(historyFragment.getString(R.string.dialog_delete_confirmation));

        // listener for YES button.
        dialog.setPositiveButton(historyFragment.getString(R.string.dialog_yes), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // when the yes button is pressed, it will delete the fuel fill record and refresh the history fragment page.
                RequestHandler.getInstance().DeleteFuelFillRecord(historyFragment.getActivity(), record.getId());
                RequestHandler.getInstance().GetFuelFillRecords(historyFragment.getActivity(), historyFragment);
            }
        });

        // listener for NO button (nothing happens)
        dialog.setNegativeButton(historyFragment.getString(R.string.dialog_no), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // foo
            }
        });

        // show the dialog box.
        dialog.setCancelable(true);
        dialog.create().show();
    }
}
