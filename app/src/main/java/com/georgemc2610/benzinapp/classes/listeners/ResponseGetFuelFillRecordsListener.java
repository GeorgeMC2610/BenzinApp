package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.content.Intent;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Comparator;

public class ResponseGetFuelFillRecordsListener implements Response.Listener<String>
{
    private final Activity activity;

    public ResponseGetFuelFillRecordsListener(Activity activity)
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

            System.out.println("JUST ADDED " + DataHolder.getInstance().records.size() + " FUEL FILL RECORDS.");
            CheckForActivityOpening();
        }
        catch (JSONException e)
        {
            System.out.println("THIS IS THE EXCEPTION WHILE GETTING THE FUEL FILL RECORDS: " + e.getMessage());
        }
    }
}
