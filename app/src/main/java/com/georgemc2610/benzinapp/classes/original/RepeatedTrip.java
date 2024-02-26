package com.georgemc2610.benzinapp.classes.original;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class RepeatedTrip implements Serializable
{
    private final int id;
    private int timesRepeating;
    private String title, originAddress, destinationAddress, originPlaceId, destinationPlaceId, polyline;
    private float originLatitude, originLongitude, destinationLatitude, destinationLongitude;
    private float totalKm;

    private LocalDate dateAdded;

    public RepeatedTrip(int id, int timesRepeating, String title, String originAddress, String destinationAddress, String originPlaceId, String destinationPlaceId, String polyline, float originLatitude, float originLongitude, float destinationLatitude, float destinationLongitude, float totalKm, LocalDate date)
    {
        this.id = id;
        this.timesRepeating = timesRepeating;
        this.title = title;
        this.originAddress = originAddress;
        this.destinationAddress = destinationAddress;
        this.polyline = polyline;
        this.originPlaceId = originPlaceId;
        this.destinationPlaceId = destinationPlaceId;
        this.originLatitude = originLatitude;
        this.originLongitude = originLongitude;
        this.destinationLatitude = destinationLatitude;
        this.destinationLongitude = destinationLongitude;
        this.totalKm = totalKm;
        this.dateAdded = date;
    }

    /**
     * Generates a {@link RepeatedTrip} object from a String JSON Response. Since
     * there are no optional parameters, everything gets retrieved and goes straight
     * to the object.
     * @param jsonObject The String JSON Response that generates the RepeatedTrip object.
     * @return The RepeatedTrip object with all its data.
     */
    public static RepeatedTrip GetRepeatedTripFromJson(JSONObject jsonObject)
    {
        try
        {
            // mandatory data (not null)
            int id = jsonObject.getInt("id");
            int timesRepeating = jsonObject.getInt("times_repeating");
            float totalKm = (float) jsonObject.getDouble("total_km");
            String title = jsonObject.getString("title");
            String polyline = jsonObject.getString("polyline");
            float originLatitude = (float) jsonObject.getDouble("origin_latitude");
            float originLongitude = (float) jsonObject.getDouble("origin_longitude");
            float destinationLatitude = (float) jsonObject.getDouble("destination_latitude");
            float destinationLongitude = (float) jsonObject.getDouble("destination_longitude");
            LocalDate date = LocalDate.parse(jsonObject.getString("created_at").substring(0, 10));

            // nullable data
            String originAddress = jsonObject.getString("origin_address");
            String destinationAddress = jsonObject.getString("destination_address");
            String originPlaceId = jsonObject.getString("origin_place_id");
            String destinationPlaceId = jsonObject.getString("destination_place_id");

            // return the object
            return new RepeatedTrip(id, timesRepeating, title, originAddress, destinationAddress, originPlaceId, destinationPlaceId, polyline, originLatitude, originLongitude, destinationLatitude, destinationLongitude, totalKm, date);
        }
        catch (JSONException e)
        {
            return null;
        }
    }

    public float getAvgLt(Car car)
    {
        return car.getAverageLitersPer100Km() * totalKm / 100;
    }

    public float getBestLt(Car car)
    {
        return car.getMinimumLitersPer100Km() * totalKm / 100;
    }

    public float getWorstLt(Car car)
    {
        return car.getMaximumLitersPer100Km() * totalKm / 100;
    }

    public float getAvgCostEur(Car car)
    {
        return car.getAverageCostPerKm() * totalKm;
    }

    public float getBestCostEur(Car car)
    {
        return car.getMinimumCostPerKm() * totalKm;
    }

    public float getWorstCostEur(Car car)
    {
        return car.getMaximumCostPerKm() * totalKm;
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

    public String getOriginAddress() {
        return originAddress;
    }

    public void setOriginAddress(String originAddress) {
        this.originAddress = originAddress;
    }

    public String getDestinationAddress() {
        return destinationAddress;
    }

    public void setDestinationAddress(String destinationAddress) {
        this.destinationAddress = destinationAddress;
    }

    public String getOriginPlaceId() {
        return originPlaceId;
    }

    public void setOriginPlaceId(String originPlaceId) {
        this.originPlaceId = originPlaceId;
    }

    public String getDestinationPlaceId() {
        return destinationPlaceId;
    }

    public void setDestinationPlaceId(String destinationPlaceId) {
        this.destinationPlaceId = destinationPlaceId;
    }

    public String getPolyline() {
        return polyline;
    }

    public void setPolyline(String polyline) {
        this.polyline = polyline;
    }

    public float getOriginLatitude() {
        return originLatitude;
    }

    public void setOriginLatitude(float originLatitude) {
        this.originLatitude = originLatitude;
    }

    public float getOriginLongitude() {
        return originLongitude;
    }

    public void setOriginLongitude(float originLongitude) {
        this.originLongitude = originLongitude;
    }

    public float getDestinationLatitude() {
        return destinationLatitude;
    }

    public void setDestinationLatitude(float destinationLatitude) {
        this.destinationLatitude = destinationLatitude;
    }

    public float getDestinationLongitude() {
        return destinationLongitude;
    }

    public void setDestinationLongitude(float destinationLongitude) {
        this.destinationLongitude = destinationLongitude;
    }

    public float getTotalKm()
    {
        return totalKm;
    }

    public void setTotalKm(float totalKm)
    {
        this.totalKm = totalKm;
    }

    public LocalDate getDateAdded()
    {
        return dateAdded;
    }
}
