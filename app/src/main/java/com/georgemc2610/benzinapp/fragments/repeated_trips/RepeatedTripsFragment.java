package com.georgemc2610.benzinapp.fragments.repeated_trips;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.georgemc2610.benzinapp.databinding.FragmentRepeatedTripsBinding;

public class RepeatedTripsFragment extends Fragment
{

    private FragmentRepeatedTripsBinding binding;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        binding = FragmentRepeatedTripsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }
}