package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * A Fuel Fill Record represents an event where someone went to the Petrol Station and <b>completely filled their car tank</b>.
 * In this concept, the user enters how much <b>Petrol they filled (in liters)</b>, how much it <b>costed (in Euros)</b> and the car's
 * <b>mileage (in kilometers)</b> before the previous Fuel Fill Record.
 * <br> <br>
 * At this point, this class can automatically calculate the amount <b>liters</b> the car consumes <b>per 100 Kilometers</b>, how many
 * <b>kilometers</b> a singular <b>liter</b> can travel and how much it <b>costs</b> to drive the car <b>for one kilometer</b>.
 * <br> <br>
 * With all this data available, an application could visualise, using a graph, how the car performs over time, since the class can hold
 * the date a Fuel Fill Record happened.
 */
public class FuelFillRecord implements Serializable
{
    private int id;
    private float liters, cost_eur, kilometers;
    private LocalDate date;
    private String station, fuelType, notes;

    private final float lt_per_100km, km_per_lt, costEur_per_km;

    public FuelFillRecord(int id, float liters, float cost_eur, float kilometers, LocalDate date, String station, String fuelType, String notes)
    {
        // initialize values
        this.id = id;
        this.liters = liters;
        this.cost_eur = cost_eur;
        this.kilometers = kilometers;
        this.date = date;
        this.station = station;
        this.fuelType = fuelType;
        this.notes = notes;

        // based on the values above, create the statistics
        lt_per_100km = 100 * liters / kilometers;
        km_per_lt = kilometers / liters;
        costEur_per_km = cost_eur / kilometers;
    }

    /**
     * Creates a new <code>Fuel Fill Record</code> from a JSON Response.
     * @param jsonObject The JSON Object with the data of a fuel fill record.
     * @return A new Fuel Fill Record object with filled data.
     */
    public static FuelFillRecord GetRecordFromJson(JSONObject jsonObject)
    {
        try
        {
            int id = jsonObject.getInt("id");
            float liters = (float) jsonObject.getDouble("lt");
            float cost = (float) jsonObject.getDouble("cost_eur");
            float kilometers = (float) jsonObject.getDouble("km");
            LocalDate localDate = LocalDate.parse(jsonObject.getString("filled_at"));
            String station = jsonObject.getString("station");
            String fuel = jsonObject.getString("fuel_type");
            String notes = jsonObject.getString("notes");

            return new FuelFillRecord(id, liters, cost, kilometers, localDate, station, fuel, notes);
        }
        catch (JSONException ignored)
        {
            return null;
        }
    }

    public float getLiters() {
        return liters;
    }

    public float getCost_eur() {
        return cost_eur;
    }

    public float getKilometers() {
        return kilometers;
    }

    public LocalDate getDate() {
        return date;
    }

    public float getLt_per_100km() {
        return lt_per_100km;
    }

    public float getKm_per_lt() {
        return km_per_lt;
    }

    public float getCostEur_per_km() {
        return costEur_per_km;
    }

    public int getId() {
        return id;
    }

    public String getStation() {
        return station;
    }

    public String getFuelType() {
        return fuelType;
    }

    public String getNotes() {
        return notes;
    }

    public void setLiters(float liters) {
        this.liters = liters;
    }

    public void setCost_eur(float cost_eur) {
        this.cost_eur = cost_eur;
    }

    public void setKilometers(float kilometers) {
        this.kilometers = kilometers;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public void setStation(String station) {
        this.station = station;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
