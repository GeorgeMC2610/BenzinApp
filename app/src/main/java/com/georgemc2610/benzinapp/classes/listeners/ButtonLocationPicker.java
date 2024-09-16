package com.georgemc2610.benzinapp.classes.listeners;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.core.app.ActivityCompat;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.activity_maps.MapsSelectPointActivity;


public class ButtonLocationPicker
{
    private final TextView locationTextView;
    private final Activity activity;
    private final boolean existingLocation;
    private final CoordinatesChangeListener removeListener;

    public ButtonLocationPicker(Button pickLocationButton, Button deleteLocationButton, TextView locationTextView, Activity activity, boolean existingLocation, CoordinatesChangeListener removeListener)
    {
        this.locationTextView = locationTextView;
        this.activity = activity;
        this.existingLocation = existingLocation;
        this.removeListener = removeListener;

        pickLocationButton.setOnClickListener(this::onSelectLocationClicked);
        deleteLocationButton.setOnClickListener(this::onRemoveLocationButtonClicked);
    }

    private void onSelectLocationClicked(View view)
    {
        // whenever the select location button is clicked, we must check two cases:
        // the permission is granted.
        if (ActivityCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setMessage(activity.getString(R.string.dialog_location_required));
            builder.setNeutralButton("OK", (dialog, which) -> ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 9918));
            builder.show();
        }

        // the user actually wants to replace this location if it's already picked.
        if (existingLocation)
        {
            // create a dialog that informs them.
            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setMessage(activity.getString(R.string.dialog_select_new_location_confirm));

            // the YES button opens the google maps activity.
            builder.setPositiveButton(R.string.dialog_yes, (dialog, which) ->
            {
                Intent intent = new Intent(activity, MapsSelectPointActivity.class);
                activity.startActivity(intent);
            });

            // the no button cancels.
            builder.setNegativeButton(R.string.dialog_no, (dialog, which) -> {
            });

            builder.show();
            return;
        }

        // in any other case, the maps activity can open regularly.
        Intent intent = new Intent(activity, MapsSelectPointActivity.class);
        activity.startActivity(intent);
    }

    private void onRemoveLocationButtonClicked(View v)
    {
        // alert dialog for location delete confirmation.
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);

        builder.setMessage(R.string.dialog_location_deletion_confirmation);
        builder.setCancelable(true);
        builder.setPositiveButton(R.string.dialog_yes, (dialog, which) ->
        {
            // set the location view to be default.
            locationTextView.setText(R.string.text_view_select_location);

            // edit shared preferences to remove the picked_address and picked_location values.
            SharedPreferences preferences = activity.getSharedPreferences("location", Context.MODE_PRIVATE);

            // put null in each of these values.
            SharedPreferences.Editor editor = preferences.edit();
            editor.putString("picked_location", null);
            editor.putString("picked_address", null);
            editor.apply();

            // also nullify the values retrieved originally
            removeListener.deleteCoordinates();
        });

        builder.setNegativeButton(R.string.dialog_no, (dialog, which) -> {});
        builder.show();
    }
}
