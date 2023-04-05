package com.georgemc2610.benzinapp.classes;

import java.io.Serializable;
import java.time.LocalDate;

public class FuelFillRecord implements Serializable
{
    private int id;
    private float liters, cost_eur, kilometers;
    private float gallons, miles;
    private LocalDate date;
    private String station, fuelType, notes;

    private final float lt_per_100km, km_per_lt, costEur_per_km;
    private final float mpg;

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

        // conversions
        this.miles = (float) (kilometers / 1.609);
        this.gallons = (float) (liters / 3.785);

        // based on the values above,
        lt_per_100km = 100 * liters / kilometers;
        km_per_lt = kilometers / liters;
        costEur_per_km = cost_eur / kilometers;

        // also convert the other values
        mpg = miles / gallons;
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

    public float getGallons() {
        return gallons;
    }

    public float getMiles() {
        return miles;
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

    public float getMpg() {
        return mpg;
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
}
