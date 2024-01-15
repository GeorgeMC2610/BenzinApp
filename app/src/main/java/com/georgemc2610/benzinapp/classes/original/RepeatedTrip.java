package com.georgemc2610.benzinapp.classes.original;

public class RepeatedTrip
{
    private int id, timesRepeating;
    private String title, origin, destination;
    private float totalKm;
    private float totalLt, totalCostEur;

    private RepeatedTrip(int id, int timesRepeating, String title, String origin, String destination, float totalKm)
    {
        this.id = id;
        this.timesRepeating = timesRepeating;
        this.title = title;
        this.origin = origin;
        this.destination = destination;
        this.totalKm = totalKm;
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
}
