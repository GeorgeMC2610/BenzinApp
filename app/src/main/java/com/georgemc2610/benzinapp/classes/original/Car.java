package com.georgemc2610.benzinapp.classes.original;

import com.georgemc2610.benzinapp.classes.requests.DataHolder;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class Car
{
    private String username, manufacturer, model;
    private float averageLitersPer100Km, averageKilometersPerLiter, averageCostPerKm;
    private int year;

    private Car(String username, String manufacturer, String model, int year)
    {
        this.username = username;
        this.manufacturer = manufacturer;
        this.model = model;
        this.year = year;
    }

    public static Car createCarFromJson(JSONObject jsonObject)
    {
        try
        {
            String username = jsonObject.getString("username");
            String manufacturer = jsonObject.getString("manufacturer");
            String model = jsonObject.getString("model");
            int year = jsonObject.getInt("year");

            return new Car(username, manufacturer, model, year);
        }
        catch (JSONException ignored)
        {
            return null;
        }
    }

    public void calculateAverages()
    {

        if (DataHolder.getInstance().records.isEmpty())
        {
            averageLitersPer100Km = Float.NaN;
            averageCostPerKm = Float.NaN;
            averageKilometersPerLiter = Float.NaN;
        }

        // initialize sums for avg.
        float literSum = 0f;
        float kilometerSum = 0f;
        float costSum = 0f;

        // foreach record add the values.
        for (FuelFillRecord record : DataHolder.getInstance().records)
        {
            literSum += record.getLiters();
            kilometerSum += record.getKilometers();
            costSum += record.getCost_eur();
        }

        averageLitersPer100Km     = 100 * literSum / kilometerSum;
        averageCostPerKm          = kilometerSum / literSum;
        averageKilometersPerLiter = costSum / kilometerSum;
    }

    // -- GETTERS -- //
    public String getUsername()
    {
        return username;
    }

    public String getManufacturer()
    {
        return manufacturer;
    }

    public String getModel()
    {
        return model;
    }

    public int getYear()
    {
        return year;
    }

    public float getAverageLitersPer100Km()
    {
        return averageLitersPer100Km;
    }

    public float getAverageKilometersPerLiter()
    {
        return averageKilometersPerLiter;
    }

    public float getAverageCostPerKm()
    {
        return averageCostPerKm;
    }
}
