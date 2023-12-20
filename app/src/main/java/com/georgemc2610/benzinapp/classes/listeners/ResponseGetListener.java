package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;

public abstract class ResponseGetListener
{
    protected final Activity activity;

    public ResponseGetListener(Activity activity)
    {
        this.activity = activity;
    }

    protected void handleActivity()
    {
        if (activity.getLocalClassName().matches(".*(?:add|edit).*"))
        {
            activity.finish();
            return;
        }
        else if (activity.getLocalClassName().equals("MainActivity"))
        {
            MainActivity mainActivity = (MainActivity) activity;
            mainActivity.recreate();
            return;
        }

        boolean canContinue = true;

        if (DataHolder.getInstance().services == null)
            canContinue = false;

        if (DataHolder.getInstance().car == null)
            canContinue = false;

        if (DataHolder.getInstance().malfunctions == null)
            canContinue = false;

        if (DataHolder.getInstance().records == null)
            canContinue = false;

        if (canContinue)
        {
            Intent intent = new Intent(activity, MainActivity.class);
            activity.startActivity(intent);
            activity.finish();
        }
    }
}
