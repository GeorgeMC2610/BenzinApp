package com.georgemc2610.benzinapp.classes.listeners;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.location.Address;
import android.location.Geocoder;

import androidx.annotation.NonNull;

import com.google.android.gms.maps.model.Marker;

import java.util.List;

@SuppressLint("NewApi")
public class GeocoderShowMarkerListener implements Geocoder.GeocodeListener
{
    private final Marker marker;
    private final Activity activity;

    public GeocoderShowMarkerListener(Activity activity, Marker marker)
    {
        this.activity = activity;
        this.marker = marker;
    }

    @Override
    public void onGeocode(@NonNull List<Address> addresses)
    {
        activity.runOnUiThread(() ->
        {
            if (addresses.isEmpty())
                return;

            marker.setTitle(addresses.get(0).getAddressLine(0));
            marker.showInfoWindow();
        });
    }
}
