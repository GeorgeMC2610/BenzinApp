package com.georgemc2610.benzinapp.fragments.repeated_trips;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddTripActivityListener;
import com.georgemc2610.benzinapp.databinding.FragmentRepeatedTripsBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class RepeatedTripsFragment extends Fragment
{

    private FragmentRepeatedTripsBinding binding;
    private FloatingActionButton buttonAddTrip;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // initialize fragment.
        binding = FragmentRepeatedTripsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get button and set listener for redirection
        buttonAddTrip = root.findViewById(R.id.button_add);
        buttonAddTrip.setOnClickListener(new ButtonRedirectToAddTripActivityListener(getContext()));

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }
}