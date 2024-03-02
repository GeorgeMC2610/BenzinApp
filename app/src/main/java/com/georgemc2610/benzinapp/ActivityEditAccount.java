package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.MenuItem;

import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;

public class ActivityEditAccount extends AppCompatActivity
{
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // intialize activity
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_account);

        // action bar
        DisplayActionBarTool.displayActionBar(this, getString(R.string.settings_edit_account_label));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        if (item.getItemId() == android.R.id.home)
        {
            finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}