package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.DataHolder;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.Malfunction;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ResponseGetMalfunctionsListener implements Response.Listener<String>
{
    private final Activity activity;

    public ResponseGetMalfunctionsListener(Activity activity)
    {
        this.activity = activity;
    }


    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONArray jsonArray = new JSONArray(response);
            DataHolder.getInstance().malfunctions = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++)
            {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                Malfunction malfunction = Malfunction.GetMalfunctionFromJson(jsonObject);
                DataHolder.getInstance().malfunctions.add(malfunction);
            }

            System.out.println("JUST ADDED " + DataHolder.getInstance().malfunctions.size() + " MALFUNCTIONS.");
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE MALFUNCTIONS: " + e.getMessage());
        }
    }
}
