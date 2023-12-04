package com.georgemc2610.benzinapp.classes;

import java.time.LocalDate;

public class Malfunction
{
    private int id, at_km;
    private float cost;
    private String title, description;
    private LocalDate started, ended;

    public Malfunction(int id, int at_km, String title, String description, LocalDate started)
    {
        this.id = id;
        this.at_km = at_km;
        this.title = title;
        this.description = description;
        this.started = started;
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
}
