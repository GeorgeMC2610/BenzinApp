package com.georgemc2610.benzinapp;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.FragmentActivity;

import android.annotation.SuppressLint;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.view.View;
import android.widget.Button;
import android.widget.SearchView;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.georgemc2610.benzinapp.databinding.ActivityMapsBinding;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.logging.Handler;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback, SearchView.OnQueryTextListener
{

    private GoogleMap mMap;
    private LatLng SelectedLocation;
    private Geocoder geocoder;
    private Marker marker;
    private Button SendDataButton;
    private SearchView searchView;
    private boolean cameraMoved = false;
    private LocationManager locationManager;
    private ActivityMapsBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize view.
        super.onCreate(savedInstanceState);

        binding = ActivityMapsBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        assert mapFragment != null;
        mapFragment.getMapAsync(this);

        // initialize the selected location with null and disable the send data button.
        SelectedLocation = null;

        SendDataButton = findViewById(R.id.button_maps_send);
        searchView = findViewById(R.id.search_view_maps);

        searchView.setOnQueryTextListener(this);

        // testing the geocoder attribute.
        geocoder = new Geocoder(this);
    }

    @SuppressLint("MissingPermission")
    @Override
    public void onMapReady(@NonNull GoogleMap googleMap)
    {
        // initialize google map object
        mMap = googleMap;
        mMap.setMyLocationEnabled(true);
        mMap.setTrafficEnabled(true);
        mMap.setBuildingsEnabled(true);

        // add listener for long press
        mMap.setOnMapLongClickListener(new GoogleMap.OnMapLongClickListener()
        {
            @Override
            public void onMapLongClick(@NonNull LatLng latLng)
            {
                // select the location.
                SelectedLocation = latLng;

                // set the button to be enabled.
                SendDataButton.setEnabled(true);

                // add the marker and remove the previous one.
                if (marker != null)
                    marker.remove();

                marker = mMap.addMarker(new MarkerOptions().position(latLng));
                mMap.animateCamera(CameraUpdateFactory.newLatLng(latLng));

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                {
                    geocoder.getFromLocation(latLng.latitude, latLng.longitude, 10, new Geocoder.GeocodeListener()
                    {
                        @Override
                        public void onGeocode(@NonNull List<Address> addresses)
                        {
                            for (Address address : addresses)
                            {
                                System.out.println(address.toString());
                            }
                        }
                    });
                }
            }
        });
    }

    public void SelectLocation(View v)
    {
        // save the location and pass it to the previous activity.
        SharedPreferences preferences = getSharedPreferences("location", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        String position = SelectedLocation.latitude + ", " + SelectedLocation.longitude;
        editor.putString("picked_location", position);
        editor.apply();
        finish();
    }

    @Override
    public boolean onQueryTextSubmit(String query)
    {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
        {
            geocoder.getFromLocationName(searchView.getQuery().toString(), 10, new Geocoder.GeocodeListener()
            {
                @Override
                public void onGeocode(@NonNull List<Address> addresses)
                {
                    for (Address address : addresses)
                    {
                        // select the location.
                        SelectedLocation = new LatLng(address.getLatitude(), address.getLongitude());

                        System.out.println(address);
                        runOnUiThread(new Runnable()
                        {
                            @Override
                            public void run()
                            {
                                // set the button to be enabled.
                                SendDataButton.setEnabled(true);

                                // add the marker and remove the previous one.
                                if (marker != null)
                                    marker.remove();

                                marker = mMap.addMarker(new MarkerOptions().position(SelectedLocation));

                                if (marker != null)
                                {
                                    marker.setTitle(address.getAddressLine(0));
                                    marker.showInfoWindow();
                                }


                                mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(SelectedLocation, 17f));
                            }
                        });
                    }
                }
            });
        }

        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText)
    {
        return false;
    }
}