package com.georgemc2610.benzinapp.classes.activity_tools;

import androidx.appcompat.app.AppCompatActivity;

public final class DisplayActionBarTool
{
    public static void displayActionBar(AppCompatActivity activity, String title)
    {
        // action bar
        try
        {
            activity.getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            activity.getSupportActionBar().setDisplayShowHomeEnabled(true);
            activity.getSupportActionBar().setTitle(title);
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.err.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }
    }
}
