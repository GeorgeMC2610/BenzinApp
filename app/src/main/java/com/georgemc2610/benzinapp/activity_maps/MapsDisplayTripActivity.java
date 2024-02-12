package com.georgemc2610.benzinapp.activity_maps;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.location.Geocoder;
import android.os.Bundle;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.databinding.ActivityMapsDisplayTripBinding;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;

import org.json.JSONException;
import org.json.JSONObject;

public class MapsDisplayTripActivity extends AppCompatActivity implements OnMapReadyCallback
{
    private GoogleMap mMap;
    private ActivityMapsDisplayTripBinding binding;
    private Marker origin, destination;
    private LatLng originCoordinates, destinationCoordinates;
    private String encodedPolyline;
    private Polyline polyline;
    private Geocoder geocoder;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        binding = ActivityMapsDisplayTripBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // geocoder initialize
        geocoder = new Geocoder(this);

        // get the data for the trip.
        String coordinates = (String) getIntent().getSerializableExtra("coordinates");
        encodedPolyline = (String) getIntent().getSerializableExtra("polyline");

        // decode the coordinates from the json object.
        try
        {
            JSONObject jsonCoordinates = new JSONObject(coordinates);

            originCoordinates = new LatLng(jsonCoordinates.getJSONArray("origin_coordinates").getDouble(0), jsonCoordinates.getJSONArray("origin_coordinates").getDouble(1));
            destinationCoordinates = new LatLng(jsonCoordinates.getJSONArray("destination_coordinates").getDouble(0), jsonCoordinates.getJSONArray("destination_coordinates").getDouble(1))
        }
        // in case something goes wrong print it out.
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder = builder.setMessage("The details of the trip are not stored correctly. Please edit this trip, so they're correct.");
            builder = builder.setNeutralButton("OK", (dialog, which) -> finish());
            builder.show();
        }

        // actionbar
        DisplayActionBarTool.displayActionBar(this, "Trip Display");
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap)
    {
        // initialize google maps screen.
        mMap = googleMap;

        // 
    }
}