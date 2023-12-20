package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.Service;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Comparator;

public class ResponseGetServicesListener extends ResponseGetListener implements Response.Listener<String>
{
    public ResponseGetServicesListener(Activity activity)
    {
        super(activity);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONArray jsonArray = new JSONArray(response);
            DataHolder.getInstance().services = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++)
            {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                Service service = Service.GetServiceFromJson(jsonObject);
                DataHolder.getInstance().services.add(service);
            }

            DataHolder.getInstance().services.sort(new Comparator<Service>()
            {
                @Override
                public int compare(Service o1, Service o2)
                {
                    if (o1.getDateHappened().isEqual(o2.getDateHappened()))
                        return 0;

                    return o1.getDateHappened().isBefore(o2.getDateHappened())? -1 : 1;
                }
            });

            handleActivity();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE SERVICES: " + e.getMessage());
        }
    }
}
