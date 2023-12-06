package com.georgemc2610.benzinapp.classes.listeners;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.georgemc2610.benzinapp.acitvity_add.ActivityAddMalfunction;
import com.georgemc2610.benzinapp.acitvity_add.ActivityAddService;
import com.google.android.material.tabs.TabLayout;

public class ButtonRedirectToAddServiceActivityListener implements View.OnClickListener
{
    private final Context context;
    private final TabLayout tabLayout;

    public ButtonRedirectToAddServiceActivityListener(Context context, TabLayout tabLayout)
    {
        this.context = context;
        this.tabLayout = tabLayout;
    }

    @Override
    public void onClick(View v)
    {
        Intent intent;

        if (tabLayout.getSelectedTabPosition() == 0)
            intent = new Intent(context, ActivityAddMalfunction.class);
        else
            intent = new Intent(context, ActivityAddService.class);

        context.startActivity(intent);
    }
}
