package com.georgemc2610.benzinapp;

import androidx.fragment.app.FragmentActivity;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.georgemc2610.benzinapp.databinding.ActivityMapsCreateTripBinding;

public class MapsCreateTripActivity extends FragmentActivity implements OnMapReadyCallback
{

    private GoogleMap mMap;
    private Button selectOrigin, selectDestination, searchAddress;
    private boolean selectingOrigin = true;
    private ActivityMapsCreateTripBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);

        binding = ActivityMapsCreateTripBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // all the buttons
        selectOrigin = findViewById(R.id.maps_select_trip_button_origin);
        selectDestination = findViewById(R.id.maps_select_trip_button_destination);
        searchAddress = findViewById(R.id.maps_select_trip_button_search_address);
    }

    public void onButtonSelectOriginClicked(View v)
    {
        selectingOrigin = true;
        selectDestination.setBackgroundColor(Color.GRAY);
        selectOrigin.setBackgroundColor(Color.MAGENTA);
    }

    public void onButtonSelectDestinationClicked(View v)
    {
        selectingOrigin = false;
        selectDestination.setBackgroundColor(Color.MAGENTA);
        selectOrigin.setBackgroundColor(Color.GRAY);
    }

    public void onButtonSelectAddressClicked(View v)
    {

    }

    @Override
    public void onMapReady(GoogleMap googleMap)
    {
        mMap = googleMap;
    }
}