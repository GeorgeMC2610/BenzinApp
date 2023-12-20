package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import androidx.fragment.app.Fragment;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Comparator;

public class ResponseGetFuelFillRecordsListener extends ResponseGetListener implements Response.Listener<String>
{
    public ResponseGetFuelFillRecordsListener(Activity activity)
    {
        super(activity);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            JSONArray jsonArray = new JSONArray(response);
            DataHolder.getInstance().records = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++)
            {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                FuelFillRecord record = FuelFillRecord.GetRecordFromJson(jsonObject);
                DataHolder.getInstance().records.add(record);
            }

            DataHolder.getInstance().records.sort(new Comparator<FuelFillRecord>()
            {
                @Override
                public int compare(FuelFillRecord o1, FuelFillRecord o2)
                {
                    if (o1.getDate().isEqual(o2.getDate()))
                        return 0;

                    return o1.getDate().isBefore(o2.getDate())? -1 : 1;
                }
            });

            handleActivity();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE FUEL FILL RECORDS: " + e.getMessage());
        }
    }
}
