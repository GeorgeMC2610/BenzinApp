package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.location.Geocoder;
import android.os.Bundle;
import android.view.MenuItem;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.georgemc2610.benzinapp.databinding.ActivityMapsDisplayPointBinding;

public class MapsDisplayPointActivity extends AppCompatActivity implements OnMapReadyCallback
{

    private GoogleMap mMap;
    private String coordinates, address;
    private ActivityMapsDisplayPointBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        binding = ActivityMapsDisplayPointBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // action bar with back button and correct title name.
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle(R.string.title_activity_maps_display_point); // TODO: Replace with string value
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }

        // obtain the location coordinates and address to display the point on the screen.
        coordinates = (String) getIntent().getSerializableExtra("coordinates");
        address = (String) getIntent().getSerializableExtra("address");
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {
            case android.R.id.home:
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap)
    {
        // initialize google maps fragment.
        mMap = googleMap;
        mMap.setTrafficEnabled(true);
        mMap.setBuildingsEnabled(true);

        // get the coordinates of the location to display.
        String[] latitudeAndLongitude = coordinates.split(",");
        double latitude = Double.parseDouble(latitudeAndLongitude[0]);
        double longitude = Double.parseDouble(latitudeAndLongitude[1]);
        LatLng latLng = new LatLng(latitude, longitude);

        // create the marker based on the coordinates.
        Marker marker = mMap.addMarker(new MarkerOptions().position(latLng));
        marker.setTitle(address);
        marker.showInfoWindow();

        // animate the camera to zoom in to the marker.
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 17f));
    }
}