package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

public class Car
{
    private String username, manufacturer, model;
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
}
