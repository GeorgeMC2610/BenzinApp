package com.georgemc2610.benzinapp;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Debug;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.requests.PolylineDecoder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.georgemc2610.benzinapp.databinding.ActivityMapsCreateTripBinding;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class MapsCreateTripActivity extends AppCompatActivity implements OnMapReadyCallback, GoogleMap.OnMapLongClickListener, Response.Listener<String>
{

    private GoogleMap mMap;
    private Button selectOrigin, selectDestination, searchAddress;
    private boolean selectingOrigin = true;
    private Marker origin, destination;
    private ActivityMapsCreateTripBinding binding;
    private ArrayList<Polyline> polylines;

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

        selectOrigin.performClick();

        // polyline array list
        polylines = new ArrayList<>();

        // action bar
        try
        {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setTitle("Create Trip");
        }
        // if anything goes wrong, print it out.
        catch (Exception e)
        {
            System.out.println("Something went wrong while trying to find Action Bar. Message: " + e.getMessage());
        }
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

    public void onButtonSelectOriginClicked(View v)
    {
        // change the logic and make the map select the origin.
        selectingOrigin = true;
        selectDestination.setBackgroundColor(Color.GRAY);
        selectOrigin.setBackgroundColor(Color.parseColor("#FFAA00"));
    }

    public void onButtonSelectDestinationClicked(View v)
    {
        // change the logic and make the map select the destination.
        selectingOrigin = false;
        selectDestination.setBackgroundColor(Color.parseColor("#FFAA00"));
        selectOrigin.setBackgroundColor(Color.GRAY);
    }

    public void onButtonSelectAddressClicked(View v)
    {

    }

    @SuppressLint("MissingPermission")
    @Override
    public void onMapReady(GoogleMap googleMap)
    {
        // initialize google maps fragment.
        mMap = googleMap;
        mMap.setMyLocationEnabled(true);

        // whenever the map is long pressed add a marker depending on what button is pressed.
        mMap.setOnMapLongClickListener(this);
    }

    @Override
    public void onMapLongClick(@NonNull LatLng latLng)
    {
        if (selectingOrigin)
        {
            if (origin != null)
                origin.remove();

            origin = mMap.addMarker(new MarkerOptions().position(latLng).title("ORIGIN").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN)));
            origin.showInfoWindow();
        }
        else
        {
            if (destination != null)
                destination.remove();

            destination = mMap.addMarker(new MarkerOptions().position(latLng).title("DESTINATION").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED)));
            destination.showInfoWindow();
        }

        if (origin != null && destination != null)
            RequestHandler.getInstance().CreateTrip(this, origin.getPosition(), destination.getPosition(), this);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            // remove all previous polylines.
            for (Polyline polyline: polylines)
                polyline.remove();

            polylines.clear();

            // get all possible routes (which is an array).
            JSONObject jsonResponse = new JSONObject(response);
            JSONArray routes = jsonResponse.getJSONArray("routes");

            Log.i("ROUTES", "Found " + routes.length() + " routes.");

            // for each route in the response:
            for (int i = 0; i < routes.length(); i++)
            {
                // retrieve the encoded route.
                JSONObject route = routes.getJSONObject(i);
                JSONObject encoded_polyline = route.getJSONObject("overview_polyline");
                String encoded_points = encoded_polyline.getString("points");

                // decode the route.
                ArrayList<LatLng> decoded_points = PolylineDecoder.decode(encoded_points);

                // set the polyline settings. for the first route, set it as default, for the rest, let them be gray.
                PolylineOptions options;
                if (i == 0)
                    options = new PolylineOptions().width(10f).color(Color.BLUE).geodesic(true);
                else
                    options = new PolylineOptions().width(16f).color(Color.GRAY).geodesic(true);

                // add the points to the map with the options above
                for (LatLng point : decoded_points)
                    options.add(point);

                // and add the polyline to the map and the list.
                Polyline polyline = mMap.addPolyline(options);
                polylines.add(polyline);
            }
        }
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
        }


    }
}