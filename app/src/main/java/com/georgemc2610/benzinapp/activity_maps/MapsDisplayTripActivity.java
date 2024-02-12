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
            destinationCoordinates = new LatLng(jsonCoordinates.getJSONArray("destination_coordinates").getDouble(0), jsonCoordinates.getJSONArray("destination_coordinates").getDouble(1));
        }
        // in case something goes wrong print it out.
        catch (JSONException e)
        {
            // print the message on the console.
            System.err.println(e.getMessage());

            // build a dialog that immediately closes the activity.
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder = builder.setMessage("The details of the trip are not stored correctly. Please edit this trip, so they're correct."); // TODO: REMOVE HARDCODED STRING
            builder = builder.setNeutralButton("OK", (dialog, which) -> finish());
            builder.show();
        }

        // actionbar
        DisplayActionBarTool.displayActionBar(this, "Trip Display"); // TODO: REMOVE HARDCODED STRING
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

                origin.setTitle(addresses.get(0).getAddressLine(0));
                origin.showInfoWindow();
            });

            geocoder.getFromLocation(destinationCoordinates.latitude, destinationCoordinates.longitude, 1, addresses ->
            {
                if (addresses.isEmpty())
                    return;

                destination.setTitle(addresses.get(0).getAddressLine(0));
                destination.showInfoWindow();
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
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(destinationCoordinates, 10f));
    }
}