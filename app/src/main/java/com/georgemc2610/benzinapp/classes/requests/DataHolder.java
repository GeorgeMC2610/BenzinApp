package com.georgemc2610.benzinapp.classes.requests;

import com.georgemc2610.benzinapp.classes.original.Car;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.original.Service;

import java.util.List;

public class DataHolder
{
    private static DataHolder instance;

    private DataHolder()
    {
        instance = this;
    }

    public static DataHolder getInstance()
    {
        return instance;
    }

    public static void Create()
    {
        instance = new DataHolder();
    }

    public List<FuelFillRecord> records;
    public List<Malfunction> malfunctions;
    public List<Service> services;
    public List<RepeatedTrip> trips;
    public Car car;
}

