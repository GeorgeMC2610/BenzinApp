package com.georgemc2610.benzinapp.classes.listeners;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.Car;
import com.georgemc2610.benzinapp.classes.DataHolder;

import org.json.JSONException;
import org.json.JSONObject;

public class ResponseGetCarInfoListener implements Response.Listener<String>
{
    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONObject jsonObject = new JSONObject(response);
            DataHolder.getInstance().car = Car.createCarFromJson(jsonObject);

            System.out.println("JUST ADDED DATA TO THE CAR.");
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE CAR: " + e.getMessage());
        }
    }
}
