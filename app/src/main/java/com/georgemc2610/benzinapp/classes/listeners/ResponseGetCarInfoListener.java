package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.classes.original.Car;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;

import org.json.JSONException;
import org.json.JSONObject;

public class ResponseGetCarInfoListener extends ResponseGetListener implements Response.Listener<String>
{
    public ResponseGetCarInfoListener(Activity activity)
    {
        super(activity);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONObject jsonObject = new JSONObject(response);
            DataHolder.getInstance().car = Car.createCarFromJson(jsonObject);

            handleActivity();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE CAR: " + e.getMessage());
        }
    }
}
