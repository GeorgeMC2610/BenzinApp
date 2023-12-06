package com.georgemc2610.benzinapp.fragments.services;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ScrollView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddServiceActivityListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseMalfunctionListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseServiceListener;
import com.georgemc2610.benzinapp.databinding.FragmentServicesBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.tabs.TabLayout;

public class ServicesFragment extends Fragment implements TabLayout.OnTabSelectedListener
{

    private FragmentServicesBinding binding;
    private TabLayout tabLayout;
    private ScrollView servicesScrollView, malfunctionsScrollView;
    private LinearLayout servicesLinearLayout, malfunctionsLinearLayout;
    private FloatingActionButton buttonAddService;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // Inflate the layout for this fragment
        binding = FragmentServicesBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // Get the tab layout.
        tabLayout = root.findViewById(R.id.tab_layout);

        // Get the other scroll views.
        servicesScrollView = root.findViewById(R.id.scroll_view_services);
        malfunctionsScrollView = root.findViewById(R.id.scroll_view_malfunctions);

        // button add service
        buttonAddService = root.findViewById(R.id.button_add_service);
        buttonAddService.setOnClickListener(new ButtonRedirectToAddServiceActivityListener(getContext(), tabLayout));

        // find layouts
        servicesLinearLayout = root.findViewById(R.id.linear_layout_services);
        malfunctionsLinearLayout = root.findViewById(R.id.linear_layout_malfunctions);

        // inflate sample layouts
        View v = inflater.inflate(R.layout.cardview_service, null);
        servicesLinearLayout.addView(v);

        // Add the tab view listener to be this class and select the first element.
        tabLayout.addOnTabSelectedListener(this);
        tabLayout.selectTab(tabLayout.getTabAt(0));

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }

    @Override
    public void onResume()
    {
        super.onResume();

        ResponseServiceListener responseServiceListener = new ResponseServiceListener(servicesLinearLayout, getLayoutInflater());
        ResponseMalfunctionListener responseMalfunctionListener = new ResponseMalfunctionListener(malfunctionsLinearLayout, getLayoutInflater());

        RequestHandler.getInstance().GetServices(getActivity(), responseServiceListener);
        RequestHandler.getInstance().GetMalfunctions(getActivity(), responseMalfunctionListener);
    }

    @Override
    public void onTabSelected(TabLayout.Tab tab)
    {
        System.out.println("TAB SELECTED: " + tabLayout.getSelectedTabPosition());

        switch (tabLayout.getSelectedTabPosition())
        {
            case 0:
                servicesScrollView.setVisibility(View.GONE);
                malfunctionsScrollView.setVisibility(View.VISIBLE);
                break;
            case 1:
                servicesScrollView.setVisibility(View.VISIBLE);
                malfunctionsScrollView.setVisibility(View.GONE);
                break;
            default:
                throw new UnsupportedOperationException();
        }
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