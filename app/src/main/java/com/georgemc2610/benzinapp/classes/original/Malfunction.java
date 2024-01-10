package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.time.LocalDate;

public class Malfunction implements Serializable
{
    private int id, at_km;
    private float cost;
    private String title, description, location;
    private LocalDate started, ended;

    public Malfunction(int id, int at_km, String title, String description, LocalDate started)
    {
        this.id = id;
        this.at_km = at_km;
        this.title = title;
        this.description = description;
        this.started = started;
    }

    /**
     * Generates a <code href="Service">Service</code> object from a String JSON Response. It handles
     * all the optional and required data accordingly. Nullifies some primitive values if
     * they're not present in the response (e.g. cost becomes -1).
     * @param jsonObject The String JSON Response that generates the Malfunction object.
     * @return The Malfunction object with all its data.
     */
    public static Malfunction GetMalfunctionFromJson(JSONObject jsonObject)
    {
        try
        {
            // required data.
            int id = jsonObject.getInt("id");
            int at_km = jsonObject.getInt("at_km");
            String title = jsonObject.getString("title");
            String description = jsonObject.getString("description");
            LocalDate started = LocalDate.parse(jsonObject.getString("started"));

            Malfunction malfunction = new Malfunction(id, at_km, title, description, started);

            // optional data are set to -1 if they're null.
            if (!jsonObject.getString("cost_eur").equals("null"))
                malfunction.setCost((float) jsonObject.getDouble("cost_eur"));
            else
                malfunction.setCost(-1f);

            if (!jsonObject.getString("ended").equals("null"))
                malfunction.setEnded(LocalDate.parse(jsonObject.getString("ended")));

            if (!jsonObject.getString("location").equals("null") && !jsonObject.getString("location").isEmpty())
                malfunction.setLocation(jsonObject.getString("location"));

            return malfunction;
        }
        catch (JSONException e)
        {
            return null;
        }
    }

    // GETTERS
    public int getId()
    {
        return id;
    }

    public int getAt_km()
    {
        return at_km;
    }

    public float getCost()
    {
        return cost;
    }

    public String getTitle()
    {
        return title;
    }

    public String getDescription()
    {
        return description;
    }

    public LocalDate getStarted()
    {
        return started;
    }

    public LocalDate getEnded()
    {
        return ended;
    }

    public String getLocation()
    {
        return location;
    }

    // SETTERS

    public void setAt_km(int at_km)
    {
        this.at_km = at_km;
    }

    public void setCost(float cost)
    {
        this.cost = cost;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public void setStarted(LocalDate started)
    {
        this.started = started;
    }

    public void setEnded(LocalDate ended)
    {
        this.ended = ended;
    }

    public void setLocation(String location)
    {
        this.location = location;
    }
}
