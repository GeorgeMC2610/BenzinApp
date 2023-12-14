package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.Malfunction;

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
            JSONArray jsonArray = new JSONArray(response);
            DataHolder.getInstance().malfunctions = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++)
            {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                Malfunction malfunction = Malfunction.GetMalfunctionFromJson(jsonObject);
                DataHolder.getInstance().malfunctions.add(malfunction);
            }

            System.out.println("JUST ADDED " + DataHolder.getInstance().malfunctions.size() + " MALFUNCTIONS.");
            CheckForActivityOpening();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE MALFUNCTIONS: " + e.getMessage());
        }
    }
}
