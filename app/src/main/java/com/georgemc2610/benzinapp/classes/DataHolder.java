package com.georgemc2610.benzinapp.classes;

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
    public Car car;
}

