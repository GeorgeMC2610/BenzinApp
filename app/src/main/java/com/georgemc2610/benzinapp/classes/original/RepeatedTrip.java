package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.time.LocalDate;

public class RepeatedTrip implements Serializable
{
    private int id, timesRepeating;
    private String title, origin, destination;
    private float totalKm;

    private LocalDate dateAdded;

    private RepeatedTrip(int id, int timesRepeating, String title, String origin, String destination, float totalKm, LocalDate dateAdded)
    {
        this.id = id;
        this.timesRepeating = timesRepeating;
        this.title = title;
        this.origin = origin;
        this.destination = destination;
        this.totalKm = totalKm;
        this.dateAdded = dateAdded;
    }

    /**
     * Generates a {@link RepeatedTrip} object from a String JSON Response. Since
     * there are no optional parameters, everything gets retrieved and goes straight
     * to the object.
     * @param jsonObject The String JSON Response that generates the RepeatedTrip object.
     * @return The RepeatedTrip object with all its data.
     */
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
            LocalDate date = LocalDate.parse(jsonObject.getString("created_at"));

            return new RepeatedTrip(id, timesRepeating, title, origin, destination, totalKm, date);
        }
        catch (JSONException e)
        {
            return null;
        }
    }

    public float getTotalLt(Car car)
    {
        return car.getAverageLitersPer100Km() * totalKm / 100;
    }

    public float getTotalCostEur(Car car)
    {
        return car.getAverageCostPerKm() * totalKm;
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

    public LocalDate getDateAdded()
    {
        return dateAdded;
    }
}
