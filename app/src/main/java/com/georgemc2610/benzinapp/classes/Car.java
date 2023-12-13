package com.georgemc2610.benzinapp.classes;

import org.json.JSONException;
import org.json.JSONObject;

public class Car
{
    private String username, manufacturer, model;
    private int year;

    public Car(String username, String manufacturer, String model, int year)
    {
        this.username = username;
        this.manufacturer = manufacturer;
        this.model = model;
        this.year = year;
    }

    public Car(JSONObject jsonObject)
    {
        try
        {
            this.username = jsonObject.getString("username");
            this.manufacturer = jsonObject.getString("manufacturer");
            this.model = jsonObject.getString("model");
            this.year = jsonObject.getInt("year");
        }
        catch (JSONException e)
        {
            this.username = null;
            this.manufacturer = null;
            this.model = null;
            this.year = -1;
        }

    }
}
