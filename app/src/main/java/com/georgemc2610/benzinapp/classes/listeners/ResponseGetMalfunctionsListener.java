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
import java.util.Comparator;

public class ResponseGetMalfunctionsListener extends ResponseGetListener implements Response.Listener<String>
{
    public ResponseGetMalfunctionsListener(Activity activity)
    {
        super(activity);
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

            DataHolder.getInstance().malfunctions.sort(new Comparator<Malfunction>()
            {
                @Override
                public int compare(Malfunction o1, Malfunction o2)
                {
                    if (o1.getStarted().isEqual(o2.getStarted()))
                        return 0;

                    return o1.getStarted().isBefore(o2.getStarted())? -1 : 1;
                }
            });

            handleActivity();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE MALFUNCTIONS: " + e.getMessage());
        }
    }
}
