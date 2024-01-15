package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.time.LocalDate;

public class Service implements Serializable
{
    private int id, atKm, nextKm;
    private float cost;
    private String description, location;
    private LocalDate dateHappened;

    public Service(int id, int atKm, String description, LocalDate dateHappened)
    {
        this.id = id;
        this.atKm = atKm;
        this.description = description;
        this.dateHappened = dateHappened;
    }

    /**
     * Generates a {@link Service} object from a String JSON Response. It handles
     * all the optional and required data accordingly. Nullifies some primitive values if
     * they're not present in the response (e.g. next_km becomes -1).
     * @param jsonObject The String JSON Response that generates the Service object.
     * @return The Service object with all its data.
     */
    public static Service GetServiceFromJson(JSONObject jsonObject)
    {
        try
        {
            // required data.
            int id = jsonObject.getInt("id");
            int atKm = jsonObject.getInt("at_km");
            String description = jsonObject.getString("description");
            LocalDate date = LocalDate.parse(jsonObject.getString("date_happened"));

            Service service = new Service(id, atKm, description, date);

            // optional data are set to -1 if they're null.
            if (!jsonObject.getString("cost_eur").equals("null"))
                service.setCost((float) jsonObject.getDouble("cost_eur"));
            else
                service.setCost(-1f);

            if (!jsonObject.get("location").equals("null") && !jsonObject.getString("location").isEmpty())
                service.setLocation(jsonObject.getString("location"));

            if (!jsonObject.getString("next_km").equals("null"))
                service.setNextKm(jsonObject.getInt("next_km"));
            else
                service.setNextKm(-1);

            return service;
        }
        catch (JSONException e)
        {
            return null;
        }
    }

    public int getId() {
        return id;
    }

    public int getAtKm() {
        return atKm;
    }

    public void setAtKm(int atKm) {
        this.atKm = atKm;
    }

    public int getNextKm() {
        return nextKm;
    }

    public void setNextKm(int nextKm) {
        this.nextKm = nextKm;
    }

    public float getCost() {
        return cost;
    }

    public void setCost(float cost) {
        this.cost = cost;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public LocalDate getDateHappened() {
        return dateHappened;
    }

    public void setDateHappened(LocalDate dateHappened) {
        this.dateHappened = dateHappened;
    }
}
