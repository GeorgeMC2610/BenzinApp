package com.georgemc2610.benzinapp.classes.listeners;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.classes.original.Service;
import com.georgemc2610.benzinapp.fragments.history.HistoryFragment;
import com.georgemc2610.benzinapp.fragments.repeated_trips.RepeatedTripsFragment;
import com.georgemc2610.benzinapp.fragments.services.ServicesFragment;

/**
 * Listener for delete button. Once it's pressed, it will show a dialog box for confirmation.
 * "Yes" and "No" buttons are provided. When "Yes" is pressed, it will delete the fuel fill record.
 */
public class CardDeleteButtonListener implements View.OnClickListener
{
    private final HistoryFragment historyFragment;
    private final ServicesFragment servicesFragment;
    private final RepeatedTripsFragment repeatedTripsFragment;
    private final FuelFillRecord record;
    private final Service service;
    private final Malfunction malfunction;
    private final RepeatedTrip repeatedTrip;

    // gets called from the record
    public CardDeleteButtonListener(HistoryFragment historyFragment, FuelFillRecord record)
    {
        this.historyFragment = historyFragment;
        this.record = record;

        this.servicesFragment = null;
        this.malfunction = null;
        this.service = null;
        this.repeatedTrip = null;
        this.repeatedTripsFragment = null;
    }

    // gets called from the service
    public CardDeleteButtonListener(ServicesFragment servicesFragment, Service service)
    {
        this.servicesFragment = servicesFragment;
        this.service = service;
        this.malfunction = null;

        this.record = null;
        this.historyFragment = null;
        this.repeatedTrip = null;
        this.repeatedTripsFragment = null;
    }

    // gets called from the malfunction
    public CardDeleteButtonListener(ServicesFragment servicesFragment, Malfunction malfunction)
    {
        this.servicesFragment = servicesFragment;
        this.malfunction = malfunction;
        this.service = null;

        this.record = null;
        this.historyFragment = null;
        this.repeatedTrip = null;
        this.repeatedTripsFragment = null;
    }

    // gets called from the repeated trip
    public CardDeleteButtonListener(RepeatedTripsFragment repeatedTripsFragment, RepeatedTrip repeatedTrip)
    {
        this.repeatedTripsFragment = repeatedTripsFragment;
        this.repeatedTrip = repeatedTrip;

        this.record = null;
        this.historyFragment = null;
        this.service = null;
        this.malfunction = null;
        this.servicesFragment = null;
    }


    @Override
    public void onClick(View v)
    {
        // context gets called from either fragment.
        Context context = historyFragment == null ? servicesFragment.getContext() : historyFragment.getContext();

        // create a dialog builder.
        AlertDialog.Builder dialog = new AlertDialog.Builder(context);

        // set titles and warning message.
        dialog.setTitle(context.getString(R.string.dialog_delete_title));
        dialog.setMessage(context.getString(R.string.dialog_delete_confirmation));

        // listener for YES button.
        dialog.setPositiveButton(context.getString(R.string.dialog_yes), new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                // when the yes button is pressed, it will check which fragment is present
                if (historyFragment != null)
                {
                    // this is for the fuel fill records
                    RequestHandler.getInstance().DeleteFuelFillRecord(historyFragment.getActivity(), record.getId());
                }
                else
                {
                    if (service != null)
                        RequestHandler.getInstance().DeleteService(servicesFragment.getActivity(), service.getId());
                    else
                        RequestHandler.getInstance().DeleteMalfunction(servicesFragment.getActivity(), malfunction.getId());
                }
            }
        });

        // listener for NO button (nothing happens)
        dialog.setNegativeButton(context.getString(R.string.dialog_no), new DialogInterface.OnClickListener()
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
