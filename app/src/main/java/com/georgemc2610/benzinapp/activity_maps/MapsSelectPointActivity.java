package com.georgemc2610.benzinapp.activity_maps;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.annotation.SuppressLint;
import android.content.SharedPreferences;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.SearchView;
import android.widget.Toast;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.databinding.ActivityMapsSelectPointBinding;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.IOException;
import java.util.List;

public class MapsSelectPointActivity extends AppCompatActivity implements OnMapReadyCallback, SearchView.OnQueryTextListener
{

    private GoogleMap mMap;
    private Address selectedAddress;
    private LatLng selectedLocation;
    private Geocoder geocoder;
    private Marker marker;
    private Button SendDataButton;
    private SearchView searchView;
    private ActivityMapsSelectPointBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize view.
        super.onCreate(savedInstanceState);

        binding = ActivityMapsSelectPointBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        assert mapFragment != null;
        mapFragment.getMapAsync(this);

        // initialize the selected location with null and disable the send data button.
        selectedLocation = null;

        SendDataButton = findViewById(R.id.button_maps_send);
        searchView = findViewById(R.id.search_view_maps);

        searchView.setOnQueryTextListener(this);

        // testing the geocoder attribute.
        geocoder = new Geocoder(this);

        // action bar.
        DisplayActionBarTool.displayActionBar(this, "Select Location"); // TODO: Replace with res id.
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
        mMap.setOnMapLongClickListener(latLng ->
        {
            // select the location.
            selectedLocation = latLng;

            if (marker != null)
                marker.remove();

            // add a marker on the map with the location's position.
            marker = mMap.addMarker(new MarkerOptions().position(latLng).title(getString(R.string.loading)));

            // marker MUST not be null.
            assert marker != null;

            // display marker's window.
            marker.showInfoWindow();

            // newer API requires listener.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            {
                geocoder.getFromLocation(latLng.latitude, latLng.longitude, 10, addresses ->
                {
                    // upon retrieving the addresses, check if the list is empty.
                    if (addresses.isEmpty())
                    {
                        // if it is, show the message to the user.
                        runOnUiThread(() -> Toast.makeText(MapsSelectPointActivity.this, "No addresses found.", Toast.LENGTH_SHORT).show()); // TODO: Replace with res id.
                        return;
                    }

                    assignMarkerAndData(addresses.get(0), latLng);
                });
            }
            // older api requires List.
            else
            {
                try
                {
                    // retrieve addresses from geocoder.
                    List<Address> addresses = geocoder.getFromLocation(latLng.latitude, latLng.longitude, 10);

                    // if there are no addresses, do nothing
                    if (addresses.isEmpty())
                    {
                        runOnUiThread(() -> Toast.makeText(MapsSelectPointActivity.this, "No addresses found.", Toast.LENGTH_SHORT).show()); // TODO: Replace with res id.
                        return;
                    }

                    assignMarkerAndData(addresses.get(0), latLng);
                }
                catch (IOException e)
                {
                    System.err.println("Something went wrong while trying to get the addresses: \n" + e.getMessage());
                }
            }
        });
    }

    public void SelectLocation(View v)
    {
        // shared preferences to pass the location and address.
        SharedPreferences preferences = getSharedPreferences("location", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();

        // save position and address from the selected location.
        String position = selectedLocation.latitude + ", " + selectedLocation.longitude;
        String address = selectedAddress.getAddressLine(0);

        // put the strings in shared preferences.
        editor.putString("picked_location", position);
        editor.putString("picked_address", address);

        // apply edits and close activity.
        editor.apply();
        finish();
    }

    @Override
    public boolean onQueryTextSubmit(String query)
    {
        // this bit of code doesn't exist in earlier SDKs.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
        {
            // attempt to get all the addresses based on the search view text.
            geocoder.getFromLocationName(searchView.getQuery().toString(), 10, addresses ->
            {
                // upon retrieving the addresses, check if the list is empty.
                if (addresses.isEmpty())
                {
                    // if it is, show the message to the user.
                    runOnUiThread(() -> Toast.makeText(MapsSelectPointActivity.this, "No addresses found.", Toast.LENGTH_SHORT).show());
                    return;
                }

                // otherwise spawn a marker on the map.
                assignMarkerAndData(addresses.get(0), null);
            });
        }
        else
        {
            try
            {
                List<Address> addresses = geocoder.getFromLocationName(searchView.getQuery().toString(), 10);

                if (!addresses.isEmpty())
                    assignMarkerAndData(addresses.get(0), null);
                else
                    Toast.makeText(this, "No addresses found.", Toast.LENGTH_SHORT).show();
            }
            catch (IOException e)
            {
                System.err.println("Something went wrong while trying to get the addresses: \n" + e.getMessage());
            }
        }

        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText)
    {
        return false;
    }

    private void assignMarkerAndData(Address address, @Nullable LatLng location)
    {
        // if the location is picked directly by the marker, then don't change the selected location.
        // this is done to be more precise with the coordinates.
        if (location == null)
            selectedLocation = new LatLng(address.getLatitude(), address.getLongitude());

        selectedAddress = address;

        // print the address of the select location.
        System.out.println(address);

        // geocode might not be running on the main thread, so we
        // run it on the UI Thread in order to tamper with the buttons and/or other views.
        runOnUiThread(() ->
        {
            // set the button to be enabled.
            SendDataButton.setEnabled(true);

            // add the marker and remove the previous one.
            if (marker != null)
                marker.remove();

            marker = mMap.addMarker(new MarkerOptions().position(selectedLocation));

            // show the marker's title
            if (marker != null)
            {
                marker.setTitle(address.getAddressLine(0));
                marker.showInfoWindow();
            }

            // animate the camera to zoom into the place.
            mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(selectedLocation, 17f));
        });
    }
}