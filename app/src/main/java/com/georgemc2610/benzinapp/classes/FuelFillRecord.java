package com.georgemc2610.benzinapp.classes;

import java.time.LocalDate;

public class FuelFillRecord
{
    private float liters, cost_eur, kilometers;
    private float gallons, cost_usd, miles;
    private LocalDate date;

    private final float lt_per_100km, km_per_lt, costEur_per_km;
    private final float mpg, costUsd_per_mile;

    public FuelFillRecord(float liters, float cost_eur, float kilometers, LocalDate date)
    {
        // initialize values
        this.liters = liters;
        this.cost_eur = cost_eur;
        this.kilometers = kilometers;
        this.date = date;

        // conversions
        this.miles = (float) (kilometers / 1.609);
        this.gallons = (float) (liters / 3.785);
        this.cost_usd = (float) (cost_eur * 1.09);

        // based on the values above,
        lt_per_100km = 100 * liters / kilometers;
        km_per_lt = kilometers / liters;
        costEur_per_km = cost_eur / kilometers;

        // also convert the other values
        mpg = miles / gallons;
        costUsd_per_mile = cost_usd / miles;
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

    public float getCost_usd() {
        return cost_usd;
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

    public float getCostUsd_per_mile() {
        return costUsd_per_mile;
    }
}
