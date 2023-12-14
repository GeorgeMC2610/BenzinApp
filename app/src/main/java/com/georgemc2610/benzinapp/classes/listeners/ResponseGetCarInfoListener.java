package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.classes.original.Car;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;

import org.json.JSONException;
import org.json.JSONObject;

public class ResponseGetCarInfoListener implements Response.Listener<String>
{
    private final Activity activity;

    public ResponseGetCarInfoListener(Activity activity)
    {
        this.activity = activity;
    }

    private void CheckForActivityOpening()
    {
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

    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONObject jsonObject = new JSONObject(response);
            DataHolder.getInstance().car = Car.createCarFromJson(jsonObject);

            System.out.println("JUST ADDED DATA TO THE CAR.");
            CheckForActivityOpening();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE CAR: " + e.getMessage());
        }
    }
}
