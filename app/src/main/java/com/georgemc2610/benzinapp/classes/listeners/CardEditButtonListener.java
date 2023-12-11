package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Intent;
import android.view.View;

import com.georgemc2610.benzinapp.activity_edit.ActivityEditMalfunction;
import com.georgemc2610.benzinapp.activity_edit.ActivityEditRecord;
import com.georgemc2610.benzinapp.activity_edit.ActivityEditService;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.Malfunction;
import com.georgemc2610.benzinapp.classes.Service;
import com.georgemc2610.benzinapp.fragments.history.HistoryFragment;
import com.georgemc2610.benzinapp.fragments.services.ServicesFragment;

/**
 * Listener for edit button. Once it's pressed, it will temporarily open a new activity to edit the record.
 * The listener takes the history fragment for context and the fuel fill record to provide to the activity afterwards.
 */
public class CardEditButtonListener implements View.OnClickListener
{
    private final HistoryFragment historyFragment;
    private final FuelFillRecord record;
    private final ServicesFragment servicesFragment;
    private final Malfunction malfunction;
    private final Service service;

    // required constructor for button listener.
    public CardEditButtonListener(HistoryFragment historyFragment, FuelFillRecord record)
    {
        this.historyFragment = historyFragment;
        this.record = record;

        this.servicesFragment = null;
        this.malfunction = null;
        this.service = null;
    }

    // gets called for the malfunction
    public CardEditButtonListener(ServicesFragment servicesFragment, Malfunction malfunction)
    {
        this.servicesFragment = servicesFragment;
        this.malfunction = malfunction;

        this.historyFragment = null;
        this.service = null;
        this.record = null;
    }

    // gets called for the service
    public CardEditButtonListener(ServicesFragment servicesFragment, Service service)
    {
        this.servicesFragment = servicesFragment;
        this.service = service;

        this.malfunction = null;
        this.historyFragment = null;
        this.record = null;
    }

    @Override
    public void onClick(View v)
    {
        // depending on which constructor was called, the right activity should be redirected to.
        if (servicesFragment == null)
        {
            // if the services fragment is null, then there is absolutely no interference with a malfunction or a service.
            // open the edit record activity.
            Intent intent = new Intent(historyFragment.getContext(), ActivityEditRecord.class);
            intent.putExtra("record", record);
            historyFragment.startActivity(intent);
            return;
        }

        // if the service object is null, we're talking about a malfunction. Otherwise we're talking about a service.
        Intent intent = new Intent(servicesFragment.getActivity(), (service == null ? ActivityEditMalfunction.class : ActivityEditService.class));
        intent.putExtra((service == null ? "malfunction" : "service"), (service == null ? malfunction : service));
        servicesFragment.startActivity(intent);
    }
}
