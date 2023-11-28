package com.georgemc2610.benzinapp;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.georgemc2610.benzinapp.databinding.FragmentServicesBinding;
import com.google.android.material.tabs.TabItem;
import com.google.android.material.tabs.TabLayout;

public class ServicesFragment extends Fragment implements TabLayout.OnTabSelectedListener
{

    private FragmentServicesBinding binding;
    private TabLayout tabLayout;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // Inflate the layout for this fragment
        binding = FragmentServicesBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // Get the tab layout.
        tabLayout = root.findViewById(R.id.tab_layout);

        // Dynamically add two tab items.
        tabLayout.addOnTabSelectedListener(this);
        tabLayout.selectTab(tabLayout.getTabAt(1));

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }

    @Override
    public void onTabSelected(TabLayout.Tab tab)
    {
        System.out.println("TAB SELECTED: " + tab.getText());
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab)
    {
        System.out.println("TAB UNSELECTED: " + tab.getText());
    }

    @Override
    public void onTabReselected(TabLayout.Tab tab)
    {
        System.out.println("TAB RESELECTED: " + tab.getText());
    }
}