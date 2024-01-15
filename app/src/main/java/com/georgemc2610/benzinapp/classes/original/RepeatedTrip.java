package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

public class RepeatedTrip
{
    private int id, timesRepeating;
    private String title, origin, destination;
    private float totalKm;
    private float totalLt, totalCostEur;

    private RepeatedTrip(int id, int timesRepeating, String title, String origin, String destination, float totalKm)
    {
        this.id = id;
        this.timesRepeating = timesRepeating;
        this.title = title;
        this.origin = origin;
        this.destination = destination;
        this.totalKm = totalKm;
    }

    public static RepeatedTrip GetRepeatedTripFromJson(JSONObject jsonObject)
    {
        try
        {
            // all of the data are required.
            int id = jsonObject.getInt("id");
            int timesRepeating = jsonObject.getInt("times_repeating");
            float totalKm = (float) jsonObject.getDouble("total_km");
            String title = jsonObject.getString("title");
            String origin = jsonObject.getString("origin");
            String destination = jsonObject.getString("destination");

            return new RepeatedTrip(id, timesRepeating, title, origin, destination, totalKm);
        }
        catch (JSONException e)
        {
            return null;
        }
    }

    public int getId()
    {
        return id;
    }

    public int getTimesRepeating()
    {
        return timesRepeating;
    }

    public void setTimesRepeating(int timesRepeating)
    {
        this.timesRepeating = timesRepeating;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getOrigin()
    {
        return origin;
    }

    public void setOrigin(String origin)
    {
        this.origin = origin;
    }

    public String getDestination()
    {
        return destination;
    }

    public void setDestination(String destination)
    {
        this.destination = destination;
    }

    public float getTotalKm()
    {
        return totalKm;
    }

    public void setTotalKm(float totalKm)
    {
        this.totalKm = totalKm;
    }
}
