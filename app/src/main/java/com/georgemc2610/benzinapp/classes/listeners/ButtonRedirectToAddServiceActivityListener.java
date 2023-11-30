package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.georgemc2610.benzinapp.ActivityAddService;

public class ButtonRedirectToAddServiceActivityListener implements View.OnClickListener
{
    private final Context context;

    public ButtonRedirectToAddServiceActivityListener(Context context)
    {
        this.context = context;
    }

    @Override
    public void onClick(View v)
    {
        Intent intent = new Intent(context, ActivityAddService.class);
        context.startActivity(intent);
    }
}
