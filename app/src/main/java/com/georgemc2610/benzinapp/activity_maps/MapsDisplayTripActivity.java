package com.georgemc2610.benzinapp.activity_maps;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.os.Bundle;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.databinding.ActivityMapsDisplayTripBinding;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

public class MapsDisplayTripActivity extends AppCompatActivity implements OnMapReadyCallback
{
    private GoogleMap mMap;
    private ActivityMapsDisplayTripBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity
        super.onCreate(savedInstanceState);
        binding = ActivityMapsDisplayTripBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // get the data for the trip.
        String coordinates;
        String polyline;

        // actionbar
        DisplayActionBarTool.displayActionBar(this, "Trip Display");
    }

    @Override
    public void onMapReady(GoogleMap googleMap)
    {
        // initialize google maps screen.
        mMap = googleMap;
    }
}