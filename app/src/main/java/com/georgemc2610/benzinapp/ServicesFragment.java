package com.georgemc2610.benzinapp;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.georgemc2610.benzinapp.databinding.FragmentServicesBinding;
import com.georgemc2610.benzinapp.databinding.FragmentSettingsBinding;

public class ServicesFragment extends Fragment
{

    private FragmentServicesBinding binding;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // Inflate the layout for this fragment
        binding = FragmentServicesBinding.inflate(inflater, container, false);
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