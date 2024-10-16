package com.georgemc2610.benzinapp.fragments.services;

import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Color;
import android.icu.text.NumberFormat;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatDelegate;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.activity_display.ActivityDisplayMalfunction;
import com.georgemc2610.benzinapp.activity_display.ActivityDisplayService;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.original.Service;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddServiceActivityListener;
import com.georgemc2610.benzinapp.classes.listeners.CardDeleteButtonListener;
import com.georgemc2610.benzinapp.classes.listeners.CardEditButtonListener;
import com.georgemc2610.benzinapp.databinding.FragmentServicesBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.tabs.TabLayout;

import java.util.Locale;

public class ServicesFragment extends Fragment implements TabLayout.OnTabSelectedListener
{

    private FragmentServicesBinding binding;
    private TabLayout tabLayout;
    private ScrollView servicesScrollView, noDataServicesScrollView, malfunctionsScrollView, noDataMalfunctionsScrollView;
    private LinearLayout servicesLinearLayout, malfunctionsLinearLayout;
    private LayoutInflater inflater;
    private FloatingActionButton buttonAddService;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // Inflate the layout for this fragment
        binding = FragmentServicesBinding.inflate(inflater, container, false);
        View root = binding.getRoot();
        this.inflater = getLayoutInflater();

        // Get the tab layout.
        tabLayout = root.findViewById(R.id.tab_layout);

        // Get the other scroll views.
        servicesScrollView = root.findViewById(R.id.scroll_view_services);
        malfunctionsScrollView = root.findViewById(R.id.scroll_view_malfunctions);
        noDataMalfunctionsScrollView = root.findViewById(R.id.scroll_view_malfunctions_no_data);
        noDataServicesScrollView = root.findViewById(R.id.scroll_view_services_no_data);

        // button add service
        buttonAddService = root.findViewById(R.id.button_add_service);
        buttonAddService.setOnClickListener(new ButtonRedirectToAddServiceActivityListener(getContext(), tabLayout));

        // find layouts
        servicesLinearLayout = root.findViewById(R.id.linear_layout_services);
        malfunctionsLinearLayout = root.findViewById(R.id.linear_layout_malfunctions);

        // Add the tab view listener to be this class and select the first element.
        tabLayout.addOnTabSelectedListener(this);
        tabLayout.selectTab(tabLayout.getTabAt(0));

        // this must be done, even though we call the function above
        servicesScrollView.setVisibility(View.GONE);
        noDataServicesScrollView.setVisibility(View.GONE);

        boolean noMalfunctions = DataHolder.getInstance().malfunctions.isEmpty();
        noDataMalfunctionsScrollView.setVisibility(noMalfunctions ? View.VISIBLE : View.GONE);
        malfunctionsScrollView.setVisibility(noMalfunctions ? View.GONE : View.VISIBLE);

        return root;
    }

    private void createMalfunctionCards()
    {
        malfunctionsLinearLayout.removeAllViews();

        for (int i = DataHolder.getInstance().malfunctions.size() - 1; i >= 0; i--)
        {
            // get the malfunction object.
            Malfunction malfunction = DataHolder.getInstance().malfunctions.get(i);

            // get the card view
            View v = inflater.inflate(R.layout.cardview_malfunction, null);

            // card view text views
            TextView titleView = v.findViewById(R.id.card_malfunction_title);
            TextView at_kmView = v.findViewById(R.id.card_malfunction_at_km);
            TextView dateView = v.findViewById(R.id.card_malfunction_date);
            TextView statusView = v.findViewById(R.id.card_malfunction_status);
            TextView idHidden = v.findViewById(R.id.card_malfunction_hidden_id);

            // card view buttons
            FloatingActionButton deleteButton = v.findViewById(R.id.card_malfunction_button_delete);
            FloatingActionButton editButton = v.findViewById(R.id.card_malfunction_button_edit);

            // set click listener for when the card is clicked
            v.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    Intent intent = new Intent(inflater.getContext(), ActivityDisplayMalfunction.class);
                    intent.putExtra("malfunction", malfunction);
                    inflater.getContext().startActivity(intent);
                }
            });

            // listeners for the buttons
            deleteButton.setOnClickListener(new CardDeleteButtonListener(this, malfunction));
            editButton.setOnClickListener(new CardEditButtonListener(this, malfunction));

            // number formatting depending on the locale.
            NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

            // set the views' data
            titleView.setText(malfunction.getTitle());
            at_kmView.setText(inflater.getContext().getString(R.string.card_view_malfunction_discovered_at) + " " + numberFormat.format(malfunction.getAt_km()) + " " + inflater.getContext().getString(R.string.km_short));
            dateView.setText(malfunction.getStarted().toString());

            if (malfunction.getEnded() == null)
            {
                statusView.setText(inflater.getContext().getString(R.string.card_view_malfunction_ongoing));
                statusView.setTextColor((getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES? getActivity().getColor(R.color.red) : getActivity().getColor(R.color.dark_red));
            }
            else
            {
                statusView.setText(inflater.getContext().getString(R.string.card_view_malfunction_fixed));
                statusView.setTextColor((getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES? getActivity().getColor(R.color.green) : getActivity().getColor(R.color.dark_green));
            }

            idHidden.setText(String.valueOf(malfunction.getId()));

            // add the view
            malfunctionsLinearLayout.addView(v);
        }

    }

    private void createServiceCards()
    {
        servicesLinearLayout.removeAllViews();

        for (int i = DataHolder.getInstance().services.size() - 1; i >= 0; i--)
        {
            // retrieve the service.
            Service service = DataHolder.getInstance().services.get(i);

            // get the card view
            View v = inflater.inflate(R.layout.cardview_service, null);

            // card view text views
            TextView at_kmView = v.findViewById(R.id.card_service_at_km);
            TextView costView = v.findViewById(R.id.card_service_cost);
            TextView dateView = v.findViewById(R.id.card_service_date);
            TextView next_kmView = v.findViewById(R.id.card_service_next_km);
            TextView idHidden = v.findViewById(R.id.card_service_hidden_id);

            // card view buttons
            FloatingActionButton deleteButton = v.findViewById(R.id.card_service_button_delete);
            FloatingActionButton editButton = v.findViewById(R.id.card_service_button_edit);

            // set click listener for when the card is clicked
            v.setOnClickListener(v1 ->
            {
                Intent intent = new Intent(inflater.getContext(), ActivityDisplayService.class);
                intent.putExtra("service", service);
                inflater.getContext().startActivity(intent);
            });

            // card view button listeners
            deleteButton.setOnClickListener(new CardDeleteButtonListener(this, service));
            editButton.setOnClickListener(new CardEditButtonListener(this, service));

            // data formatting based on locale.
            NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

            // set the views data
            at_kmView.setText(numberFormat.format(service.getAtKm()) + " " + inflater.getContext().getString(R.string.km_short));
            dateView.setText(service.getDateHappened().toString());
            idHidden.setText(String.valueOf(service.getId()));

            costView.setText(service.getCost() == -1f ? "-" : "€" + numberFormat.format(service.getCost()));
            next_kmView.setText(inflater.getContext().getString(R.string.card_view_service_next_service) + (service.getNextKm() == -1? " -" : " " + numberFormat.format(service.getNextKm()) + " " + inflater.getContext().getString(R.string.km_short)));

            // add the view
            servicesLinearLayout.addView(v);
        }
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

        createServiceCards();
        createMalfunctionCards();
    }

    @Override
    public void onTabSelected(TabLayout.Tab tab)
    {
        switch (tabLayout.getSelectedTabPosition())
        {
            case 0:
                servicesScrollView.setVisibility(View.GONE);
                noDataServicesScrollView.setVisibility(View.GONE);

                boolean noMalfunctions = DataHolder.getInstance().malfunctions.isEmpty();
                noDataMalfunctionsScrollView.setVisibility(noMalfunctions ? View.VISIBLE : View.GONE);
                malfunctionsScrollView.setVisibility(noMalfunctions ? View.GONE : View.VISIBLE);
                break;
            case 1:
                malfunctionsScrollView.setVisibility(View.GONE);
                noDataMalfunctionsScrollView.setVisibility(View.GONE);

                boolean noServices = DataHolder.getInstance().services.isEmpty();
                noDataServicesScrollView.setVisibility(noServices ? View.VISIBLE : View.GONE);
                servicesScrollView.setVisibility(noServices ? View.GONE : View.VISIBLE);

                break;
            default:
                throw new UnsupportedOperationException();
        }
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab)
    {

    }

    @Override
    public void onTabReselected(TabLayout.Tab tab)
    {

    }
}