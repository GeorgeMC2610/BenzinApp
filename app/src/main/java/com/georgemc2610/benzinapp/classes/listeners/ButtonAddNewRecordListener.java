package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import com.georgemc2610.benzinapp.ActivityAddRecord;

public class ButtonAddNewRecordListener implements View.OnClickListener
{
    private final Context context;

    public ButtonAddNewRecordListener(Context context)
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
