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

public class ResponseGetServicesListener implements Response.Listener<String>
{
    private final Activity activity;
    private final boolean isForLogin;

    public ResponseGetServicesListener(Activity activity)
    {
        this.activity = activity;
        this.isForLogin = true;
    }

    public ResponseGetServicesListener(Activity activity, boolean isForLogin)
    {
        this.activity = activity;
        this.isForLogin = isForLogin;
    }

    private void CheckForActivityOpening()
    {
        if (!isForLogin)
        {
            activity.finish();
            return;
        }

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
            DataHolder.getInstance().services = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++)
            {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                Service service = Service.GetServiceFromJson(jsonObject);
                DataHolder.getInstance().services.add(service);
            }

            CheckForActivityOpening();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE SERVICES: " + e.getMessage());
        }
    }
}
