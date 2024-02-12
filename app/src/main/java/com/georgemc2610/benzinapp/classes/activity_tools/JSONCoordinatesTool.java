package com.georgemc2610.benzinapp.classes.activity_tools;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public final class JSONCoordinatesTool
{
    /**
     * Extracts data to a {@linkplain HashMap} object with the values from the JSON response of the trip.
     * A prime example of a valid object is something like this:
     * {@code {"origin_coordinates":[20.52, 30.52],"destination_coordinates":[20.52, 30.52]}}.
     * @param response The JSON value of the trip. It must contain "origin_coordinates" and "destination_coordinates" with arrays in them.
     * @return A {@linkplain HashMap} with the values. It has two objects: a "origin" and a "destination". Both of them have a double[] array in them. If the JSON object is wrong, it returns null.
     */
    public static Map<String, double[]> getCoordinatesFromJSON(String response)
    {
        try
        {
            JSONObject jsonObject = new JSONObject(response);

            // extract the values from the json object.
            double[] originCoordinates = new double[] {jsonObject.getJSONArray("origin_coordinates").getDouble(0), jsonObject.getJSONArray("origin_coordinates").getDouble(1)};
            double[] destinationCoordinates = new double[] {jsonObject.getJSONArray("destination_coordinates").getDouble(0), jsonObject.getJSONArray("destination_coordinates").getDouble(1)};

            // map the values.
            Map<String, double[]> values = new HashMap<>();
            values.put("origin", originCoordinates);
            values.put("destination", destinationCoordinates);

            // return the values
            return values;
        }
        catch (JSONException e)
        {
            // in case of the error don't return an object and print the error.
            System.err.println(e.getMessage());
            return null;
        }
    }
}
