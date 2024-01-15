package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ResponseGetRepeatedTripsListener extends ResponseGetListener implements Response.Listener<String>
{
    public ResponseGetRepeatedTripsListener(Activity activity)
    {
        super(activity);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONArray jsonArray = new JSONArray(response);
            DataHolder.getInstance().trips = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++)
            {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                RepeatedTrip trip = RepeatedTrip.GetRepeatedTripFromJson(jsonObject);
                DataHolder.getInstance().trips.add(trip);
            }

            handleActivity();
        }
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
        }
    }

}
