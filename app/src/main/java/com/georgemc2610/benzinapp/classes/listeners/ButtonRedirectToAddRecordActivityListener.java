package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import com.georgemc2610.benzinapp.activity_add.ActivityAddRecord;

public class ButtonRedirectToAddRecordActivityListener implements View.OnClickListener
{
    private final Context context;

    public ButtonRedirectToAddRecordActivityListener(Context context)
    {
        this.context = context;
    }

    @Override
    public void onClick(View v)
    {
        Intent intent = new Intent(context, ActivityAddRecord.class);
        context.startActivity(intent);
    }
}
