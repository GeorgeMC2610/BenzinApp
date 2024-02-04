package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.georgemc2610.benzinapp.activity_add.ActivityAddRepeatedTrip;

public class ButtonRedirectToAddTripActivityListener implements View.OnClickListener
{
    private final Context context;

    public ButtonRedirectToAddTripActivityListener(Context context)
    {
        this.context = context;
    }


    @Override
    public void onClick(View v)
    {
        Intent intent = new Intent(context, ActivityAddRepeatedTrip.class);
        context.startActivity(intent);
    }
}
