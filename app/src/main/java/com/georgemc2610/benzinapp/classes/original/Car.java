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
    private float minimumLitersPer100Km, minimumKilometersPerLiter, minimumCostPerKm;
    private float maximumLitersPer100Km, maximumKilometersPerLiter, maximumCostPerKm;
    private int year;

    private Car(String username, String manufacturer, String model, int year)
    {
        this.username = username;
        this.manufacturer = manufacturer;
        this.model = model;
        this.year = year;

        this.maximumKilometersPerLiter = -1f;
        this.maximumLitersPer100Km = -1f;
        this.maximumCostPerKm = -1f;

        this.minimumKilometersPerLiter = Float.MAX_VALUE;
        this.minimumLitersPer100Km = Float.MAX_VALUE;
        this.minimumCostPerKm = Float.MAX_VALUE;
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
        if (DataHolder.getInstance().records == null)
            return;

        // NaN values if the records are empty.
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

            // calculate maximums.
            if (record.getLt_per_100km() > this.maximumLitersPer100Km)
                this.maximumLitersPer100Km = record.getLt_per_100km();

            if (record.getKm_per_lt() > this.maximumKilometersPerLiter)
                this.maximumKilometersPerLiter = record.getKm_per_lt();

            if (record.getCostEur_per_km() > this.maximumCostPerKm)
                this.maximumCostPerKm = record.getCostEur_per_km();

            // calculate minimums.
            if (record.getLt_per_100km() < this.minimumLitersPer100Km)
                this.minimumLitersPer100Km = record.getLt_per_100km();

            if (record.getKm_per_lt() < this.minimumKilometersPerLiter)
                this.minimumKilometersPerLiter = record.getKm_per_lt();

            if (record.getCostEur_per_km() < this.minimumCostPerKm)
                this.minimumCostPerKm = record.getCostEur_per_km();
        }

        // assign the averages.
        averageLitersPer100Km     = 100 * literSum / kilometerSum;
        averageCostPerKm          = costSum / kilometerSum;
        averageKilometersPerLiter = kilometerSum / literSum;
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

    public float getMinimumLitersPer100Km() {
        return minimumLitersPer100Km;
    }

    public float getMinimumKilometersPerLiter() {
        return minimumKilometersPerLiter;
    }

    public float getMinimumCostPerKm() {
        return minimumCostPerKm;
    }

    public float getMaximumLitersPer100Km() {
        return maximumLitersPer100Km;
    }

    public float getMaximumKilometersPerLiter() {
        return maximumKilometersPerLiter;
    }

    public float getMaximumCostPerKm() {
        return maximumCostPerKm;
    }

}
