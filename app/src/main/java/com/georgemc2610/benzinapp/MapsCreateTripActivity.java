package com.georgemc2610.benzinapp;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.SearchView;
import android.widget.Toast;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.listeners.GeocoderShowMarkerListener;
import com.georgemc2610.benzinapp.classes.requests.PolylineDecoder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.georgemc2610.benzinapp.databinding.ActivityMapsCreateTripBinding;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class MapsCreateTripActivity extends AppCompatActivity implements OnMapReadyCallback, GoogleMap.OnMapLongClickListener, Response.Listener<String>, SearchView.OnQueryTextListener
{
    private GoogleMap mMap;
    private Button selectOrigin, selectDestination, completeTrip;
    private SearchView addressSearch;
    private boolean isSelectingOrigin = true, ableToCompleteTrip = false;
    private Marker origin, destination;
    private ActivityMapsCreateTripBinding binding;
    private Geocoder geocoder;
    private ArrayList<Polyline> polylines;
    private ArrayList<String> encodedPolylines;
    private ArrayList<Float> routeDistances;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        // initialize activity.
        super.onCreate(savedInstanceState);

        binding = ActivityMapsCreateTripBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // all the views.
        selectOrigin = findViewById(R.id.maps_select_trip_button_origin);
        selectDestination = findViewById(R.id.maps_select_trip_button_destination);
        completeTrip = findViewById(R.id.maps_select_trip_button_make_trip);
        addressSearch = findViewById(R.id.maps_select_trip_search_view_address);

        // click button to pick the origin and block the make trip button
        selectOrigin.performClick();
        setTripCompletionAvailable(false);

        // search view listener
        addressSearch.setOnQueryTextListener(this);

        // array list initializations.
        polylines = new ArrayList<>();
        encodedPolylines = new ArrayList<>();
        routeDistances = new ArrayList<>();

        // geocoder initialization
        geocoder = new Geocoder(this);

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
    public boolean onQueryTextSubmit(String query)
    {
        // decode the address found by the query.
        geocoder.getFromLocationName(query, 10, addresses ->
        {
            // if there are no addresses do not do anything.
            if (addresses.isEmpty())
            {
                runOnUiThread(() -> Toast.makeText(MapsCreateTripActivity.this, "No addresses found.", Toast.LENGTH_SHORT).show());
                return;
            }

            // otherwise add the marker to the map depending on what is selected (origin/destination).
            runOnUiThread(() ->
            {
                // if the origin is being selected, show the origin on the map.
                if (isSelectingOrigin)
                    origin = showMarkerOnMap(origin, addresses.get(0));

                // otherwise show the destination.
                else
                    destination = showMarkerOnMap(destination, addresses.get(0));

                // draw the map polyline if the trip is ready
                checkTripAvailability();
            });
        });

        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText)
    {
        return false;
    }

    public void onButtonSelectOriginClicked(View v)
    {
        // change the logic and make the map select the origin.
        isSelectingOrigin = true;
        selectDestination.setBackgroundColor(Color.GRAY);
        selectOrigin.setBackgroundColor(Color.parseColor("#FFAA00"));
    }

    public void onButtonSelectDestinationClicked(View v)
    {
        // change the logic and make the map select the destination.
        isSelectingOrigin = false;
        selectDestination.setBackgroundColor(Color.parseColor("#FFAA00"));
        selectOrigin.setBackgroundColor(Color.GRAY);
    }

    public void onButtonMakeTripClicked(View v) throws JSONException
    {
        // make sure there is at least one trip.
        if (polylines.isEmpty() || encodedPolylines.isEmpty())
        {
            Toast.makeText(this, "Please select a trip.", Toast.LENGTH_SHORT).show();
            return;
        }

        // shared preferences to save the data.
        SharedPreferences preferences = getSharedPreferences("repeated_trip", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();

        // based on what we want saved on the cloud, we save the shared preferences like this.
        editor.putString("encodedTrip", encodedPolylines.get(0));
        editor.putString("jsonTrip", createTripToJson(origin.getPosition(), destination.getPosition()));
        editor.putFloat("tripDistance", routeDistances.get(0));

        // apply changes.
        editor.apply();

        // close the activity (which returns to the Add Trip Activity).
        finish();
    }

    @Override
    public void onMapLongClick(@NonNull LatLng latLng)
    {
        // select the correct marker according to what button is pressed.
        if (isSelectingOrigin)
            origin = showMarkerOnMap(origin, latLng);
        else
            destination = showMarkerOnMap(destination, latLng);

        // draw the map polyline if the trip is ready
        checkTripAvailability();
    }

    @SuppressLint("NewApi")
    private Marker showMarkerOnMap(Marker marker, LatLng latLng)
    {
        // if the button origin is selected, select the origin.
        if (marker != null)
            marker.remove();

        // add the marker to the map. Green is origin, red is destination.
        marker = mMap.addMarker(new MarkerOptions().
                position(latLng).
                title(isSelectingOrigin ? "ORIGIN" : "DESTINATION").
                icon(BitmapDescriptorFactory.defaultMarker(isSelectingOrigin ? BitmapDescriptorFactory.HUE_GREEN : BitmapDescriptorFactory.HUE_RED)));

        // show its window.
        marker.showInfoWindow();

        // move the camera to the marker
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 14f));

        // retrieve its address and set it as a title.
        geocoder.getFromLocation(latLng.latitude, latLng.longitude, 10, new GeocoderShowMarkerListener(this, marker));

        // return the marker, so the changes are saved.
        return marker;
    }

    private Marker showMarkerOnMap(Marker marker, Address address)
    {
        // retrieve address' coordinates.
        LatLng addressLatLng = new LatLng(address.getLatitude(), address.getLongitude());

        // if the button origin is selected, select the origin.
        if (marker != null)
            marker.remove();

        // add the marker to the map. Green is origin, red is destination.
        marker = mMap.addMarker(new MarkerOptions().
                position(addressLatLng).
                title(address.getAddressLine(0)).
                icon(BitmapDescriptorFactory.defaultMarker(isSelectingOrigin ? BitmapDescriptorFactory.HUE_GREEN : BitmapDescriptorFactory.HUE_RED)));

        // show its window.
        marker.showInfoWindow();

        // move the camera to zoom in on the marker
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(addressLatLng, 14f));

        // return the marker, so the changes are saved.
        return marker;
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            // remove all previous polylines.
            for (Polyline polyline: polylines)
                polyline.remove();

            // clear all the lists.
            polylines.clear();
            encodedPolylines.clear();
            routeDistances.clear();

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

                // get the distance for the route.
                JSONObject leg = route.getJSONArray("legs").getJSONObject(0).getJSONObject("distance");
                float distance = (float) leg.getInt("value") / 1000;

                // add it to the distances.
                routeDistances.add(distance);

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
                encodedPolylines.add(encoded_points);
            }
        }
        catch (JSONException e)
        {
            System.err.println(e.getMessage());
        }
    }

    private void checkTripAvailability()
    {
        // if both origin and destination are assigned, then create the trip.
        if (origin != null && destination != null)
        {
            RequestHandler.getInstance().CreateTrip(this, origin.getPosition(), destination.getPosition(), this);
            ableToCompleteTrip = true;
            setTripCompletionAvailable(true);
        }
        else
        {
            ableToCompleteTrip = false;
            setTripCompletionAvailable(false);
        }
    }

    private void setTripCompletionAvailable(boolean state)
    {
        ableToCompleteTrip = state;
        completeTrip.setEnabled(state);
        completeTrip.setBackgroundColor(state? Color.parseColor("#FFAA00") : Color.GRAY);
    }

    @SuppressLint("NewApi")
    private String createTripToJson(LatLng origin, LatLng destination) throws JSONException
    {
        JSONObject jsonObject = new JSONObject();

        jsonObject.append("origin_coordinates", origin.latitude);
        jsonObject.append("origin_coordinates", origin.longitude);

        jsonObject.append("destination_coordinates", destination.latitude);
        jsonObject.append("destination_coordinates", destination.longitude);

        return jsonObject.toString();
    }
}