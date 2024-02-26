package com.georgemc2610.benzinapp.activity_maps;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.DisplayActionBarTool;
import com.georgemc2610.benzinapp.classes.activity_tools.PolylineDecoder;
import com.georgemc2610.benzinapp.databinding.ActivityMapsDisplayTripBinding;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

        // geocoder initialize
        geocoder = new Geocoder(this);

        // get the data for the trip.
        double originLatitude = (double) getIntent().getSerializableExtra("origin_latitude");
        double originLongitude = (double) getIntent().getSerializableExtra("origin_longitude");
        double destinationLatitude = (double) getIntent().getSerializableExtra("destination_latitude");
        double destinationLongitude = (double) getIntent().getSerializableExtra("destination_longitude");
        encodedPolyline = (String) getIntent().getSerializableExtra("polyline");

        // make latlng objects
        originCoordinates = new LatLng(originLatitude, originLongitude);
        destinationCoordinates = new LatLng(destinationLatitude, destinationLongitude);

        // make the map object.
        mapFragment.getMapAsync(this);

        // actionbar
        DisplayActionBarTool.displayActionBar(this, "Trip Display"); // TODO: REMOVE HARDCODED STRING
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

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap)
    {
        // initialize google maps screen.
        mMap = googleMap;

        // add markers.
        origin = mMap.addMarker(new MarkerOptions().position(originCoordinates).title("ORIGIN").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN))); // TODO: REMOVE HARDCODED STRING
        destination = mMap.addMarker(new MarkerOptions().position(destinationCoordinates).title("DESTINATION").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED))); // TODO: REMOVE HARDCODED STRING

        // markers must not be null.
        assert origin != null;
        assert destination != null;

        // add addresses to the titles.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
        {
            // newer api requires listeners.
            geocoder.getFromLocation(originCoordinates.latitude, originCoordinates.longitude, 1, addresses ->
            {
                if (addresses.isEmpty())
                    return;

                runOnUiThread(() ->
                {
                    origin.setTitle(addresses.get(0).getAddressLine(0));
                    origin.showInfoWindow();
                });
            });

            geocoder.getFromLocation(destinationCoordinates.latitude, destinationCoordinates.longitude, 1, addresses ->
            {
                if (addresses.isEmpty())
                    return;

                runOnUiThread(() ->
                {
                    destination.setTitle(addresses.get(0).getAddressLine(0));
                    destination.showInfoWindow();
                });
            });
        }
        else
        {
            // older api requires running on the ui thread.
            try
            {
                // retrieve an address for each marker.
                List<Address> originAddresses = geocoder.getFromLocation(originCoordinates.latitude, originCoordinates.longitude, 1);
                List<Address> destinationAddresses = geocoder.getFromLocation(destinationCoordinates.latitude, destinationCoordinates.longitude, 1);

                // assign the markers the address.
                if (!originAddresses.isEmpty() && !destinationAddresses.isEmpty())
                {
                    // set the titles.
                    origin.setTitle(originAddresses.get(0).getAddressLine(0));
                    destination.setTitle(destinationAddresses.get(0).getAddressLine(0));

                    // set the windows to be opened.
                    origin.showInfoWindow();
                    destination.showInfoWindow();
                }
            }
            catch (IOException e)
            {
                System.err.println(e.getMessage());
            }
        }

        // get polyline points.
        ArrayList<LatLng> decodedPoints = PolylineDecoder.decode(encodedPolyline);

        // polyline is blue in any case.
        PolylineOptions options = new PolylineOptions().width(10f).color(Color.BLUE);

        // add the points to the polyline
        options.addAll(decodedPoints);

        // show the polyline
        polyline = mMap.addPolyline(options);
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(destinationCoordinates, 2500f/decodedPoints.size()));
    }
}