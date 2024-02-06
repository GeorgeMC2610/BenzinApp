package com.georgemc2610.benzinapp;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.android.volley.Response;
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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MapsCreateTripActivity extends AppCompatActivity implements OnMapReadyCallback, GoogleMap.OnMapLongClickListener, Response.Listener<String>
{

    private GoogleMap mMap;
    private Button selectOrigin, selectDestination, searchAddress;
    private boolean selectingOrigin = true;
    private Marker origin, destination;
    private ActivityMapsCreateTripBinding binding;
    private Polyline polyline;

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
        mMap.setTrafficEnabled(true);

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
        }
        else
        {
            if (destination != null)
                destination.remove();

            destination = mMap.addMarker(new MarkerOptions().position(latLng).title("DESTINATION").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED)));
        }

        if (origin != null && destination != null)
            RequestHandler.getInstance().CreateTrip(this, origin.getPosition(), destination.getPosition(), this);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            // get all possible routes (which is an array).
            JSONObject jsonResponse = new JSONObject(response);
            JSONArray routes = jsonResponse.getJSONArray("routes");

            // get the first route and its polylines
            JSONObject route1 = routes.getJSONObject(0);
            JSONObject polyline = route1.getJSONObject("overview_polyline");
            String points = polyline.getString("points");

            ArrayList<LatLng> mapPoints = decodePolyline(points);

            PolylineOptions options = new PolylineOptions().width(10f).color(Color.BLUE).geodesic(true);
            for (LatLng point : mapPoints)
                options.add(point);

            if (this.polyline != null)
                this.polyline.remove();

            this.polyline = mMap.addPolyline(options);
        }
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
        }


    }

    private ArrayList<LatLng> decodePolyline(String polyline)
    {
        Log.i("Location", "String Received: " + polyline);

        ArrayList<LatLng> poly = new ArrayList<>();
        int index = 0, len = polyline.length();
        int lat = 0, lng = 0;

        while (index < len)
        {
            int b, shift = 0, result = 0;
            do
            {
                b = polyline.charAt(index++) - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);

            int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
            lat += dlat;

            shift = 0;
            result = 0;
            do
            {
                b = polyline.charAt(index++) - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);

            int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
            lng += dlng;

            LatLng p = new LatLng((((double) lat / 1E5)),(((double) lng / 1E5)));
            poly.add(p);
        }

        for (int i = 0; i < poly.size(); i++)
            Log.i("Location", "Point sent: Latitude: "+poly.get(i).latitude+" Longitude: "+poly.get(i).longitude);

        return poly;
    }
}