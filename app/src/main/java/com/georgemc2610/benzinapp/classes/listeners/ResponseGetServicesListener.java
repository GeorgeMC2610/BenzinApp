package com.georgemc2610.benzinapp.classes.listeners;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.DataHolder;
import com.georgemc2610.benzinapp.classes.Malfunction;
import com.georgemc2610.benzinapp.classes.Service;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ResponseGetServicesListener implements Response.Listener<String>
{
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

            System.out.println("JUST ADDED " + DataHolder.getInstance().services.size() + " SERVICES.");
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE SERVICES: " + e.getMessage());
        }
    }
}
