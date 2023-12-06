package com.georgemc2610.benzinapp.classes;

import java.time.LocalDate;

public class Service
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
