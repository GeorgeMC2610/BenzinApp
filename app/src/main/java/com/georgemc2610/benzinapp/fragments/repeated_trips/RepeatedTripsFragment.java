package com.georgemc2610.benzinapp.fragments.repeated_trips;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddTripActivityListener;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.databinding.FragmentRepeatedTripsBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class RepeatedTripsFragment extends Fragment
{

    private FragmentRepeatedTripsBinding binding;
    private FloatingActionButton buttonAddTrip;
    private LinearLayout linearLayout;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // initialize fragment.
        binding = FragmentRepeatedTripsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get button and set listener for redirection
        buttonAddTrip = root.findViewById(R.id.button_add);
        buttonAddTrip.setOnClickListener(new ButtonRedirectToAddTripActivityListener(getContext()));

        // get scroll view to add the cards.
        linearLayout = root.findViewById(R.id.repeated_trips_fragment_linearLayoutScrollView);

        return root;
    }


    private void createCards()
    {
        // remove all cards before creating the new ones.
        linearLayout.removeAllViews();
        LayoutInflater inflater = getLayoutInflater();

        // start from the end of the list to get the most recent ones.
        for (int i = DataHolder.getInstance().trips.size() - 1; i >= 0; i++)
        {
            // create the repeated trip object.
            RepeatedTrip trip = DataHolder.getInstance().trips.get(i);

            // if the repeated trip is not repeating over the week, create a different type of card
            if (trip.getTimesRepeating() == 1)
            {
                // card inflation
                View card = inflater.inflate(R.layout.cardview_trip, null);

                // text views.
                TextView id = card.findViewById(R.id.card_trip_hidden_id);
                TextView title = card.findViewById(R.id.card_trip_title);
                TextView repeating = card.findViewById(R.id.card_trip_one_time);
                TextView cost = card.findViewById(R.id.card_trip_cost);
                TextView date = card.findViewById(R.id.card_trip_date_added);
                TextView totalKm = card.findViewById(R.id.card_trip_km);

                
            }
        }
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }
}