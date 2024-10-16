package com.georgemc2610.benzinapp.fragments.repeated_trips;

import android.content.Intent;
import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.activity_display.ActivityDisplayRepeatedTrip;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddTripActivityListener;
import com.georgemc2610.benzinapp.classes.listeners.CardDeleteButtonListener;
import com.georgemc2610.benzinapp.classes.listeners.CardEditButtonListener;
import com.georgemc2610.benzinapp.classes.original.RepeatedTrip;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.databinding.FragmentRepeatedTripsBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Locale;

public class RepeatedTripsFragment extends Fragment
{

    private FragmentRepeatedTripsBinding binding;
    private FloatingActionButton buttonAddTrip;
    private LinearLayout linearLayout;
    private ScrollView mainScrollView, noDataScrollView;

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
        mainScrollView = root.findViewById(R.id.scrollView2);
        noDataScrollView = root.findViewById(R.id.scrollViewNoData);

        return root;
    }

    private void createCards()
    {
        // display the related image if there are no trips.
        if (DataHolder.getInstance().trips.isEmpty())
        {
            mainScrollView.setVisibility(View.GONE);
            noDataScrollView.setVisibility(View.VISIBLE);
            return;
        }

        // calculate averages
        DataHolder.getInstance().car.calculateAverages();

        // remove all cards before creating the new ones.
        linearLayout.removeAllViews();
        LayoutInflater inflater = getLayoutInflater();
        NumberFormat format = NumberFormat.getInstance(Locale.getDefault());
        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        // start from the end of the list to get the most recent ones.
        for (int i = DataHolder.getInstance().trips.size() - 1; i >= 0; i--)
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

                // display data view.
                card.setOnClickListener(v ->
                {
                    Intent intent = new Intent(getContext(), ActivityDisplayRepeatedTrip.class);
                    intent.putExtra("repeated_trip", trip);
                    startActivity(intent);
                });

                // buttons.
                FloatingActionButton delete = card.findViewById(R.id.card_trip_button_delete);
                FloatingActionButton edit = card.findViewById(R.id.card_trip_button_edit);

                // listeners for buttons.
                delete.setOnClickListener(new CardDeleteButtonListener(this, trip));
                edit.setOnClickListener(new CardEditButtonListener(this, trip));

                // format the values to their actual values.
                String formattedCost = '€' + decimalFormat.format(trip.getAvgCostEur(DataHolder.getInstance().car));
                String formattedKilometers = format.format(trip.getTotalKm()) + ' ' + getString(R.string.km_short);

                // set the texts to their actual values.
                id.setText(String.valueOf(trip.getId()));
                title.setText(trip.getTitle());
                repeating.setText(R.string.text_view_card_trips_one_time);
                totalKm.setText(formattedKilometers);
                cost.setText(formattedCost);
                date.setText(trip.getDateAdded().toString());

                linearLayout.addView(card);
            }
            else
            {
                // repeated trip card inflation
                View card = inflater.inflate(R.layout.cardview_repeated_trip, null);

                // text views.
                TextView id = card.findViewById(R.id.card_repeated_trip_hidden_id);
                TextView title = card.findViewById(R.id.card_repeated_trip_title);
                TextView times = card.findViewById(R.id.card_repeated_trip_times);
                TextView cost = card.findViewById(R.id.card_repeated_trip_cost);
                TextView liters = card.findViewById(R.id.card_repeated_trip_lt);
                TextView date = card.findViewById(R.id.card_repeated_trip_date);
                TextView km = card.findViewById(R.id.card_repeated_trip_km);

                // display data view.
                card.setOnClickListener(v ->
                {
                    Intent intent = new Intent(getContext(), ActivityDisplayRepeatedTrip.class);
                    intent.putExtra("repeated_trip", trip);
                    startActivity(intent);
                });

                // buttons.
                FloatingActionButton delete = card.findViewById(R.id.card_repeated_button_delete);
                FloatingActionButton edit = card.findViewById(R.id.card_repeated_button_edit);

                // listeners for buttons.
                delete.setOnClickListener(new CardDeleteButtonListener(this, trip));
                edit.setOnClickListener(new CardEditButtonListener(this, trip));

                // format the values.
                String formattedTimesPerWeek = getString(R.string.card_repeated_trip_repeating) + trip.getTimesRepeating() + getString(R.string.card_repeated_trip_times_per_week);
                String formattedCost = "€" + decimalFormat.format(trip.getAvgCostEur(DataHolder.getInstance().car) * trip.getTimesRepeating()) + getString(R.string.card_repeated_trip_per_week);
                String formattedLiters = format.format(trip.getAvgLt(DataHolder.getInstance().car) * trip.getTimesRepeating()) + " " + getString(R.string.lt_short) + getString(R.string.card_repeated_trip_per_week);
                String formattedKilometers = format.format(trip.getTotalKm()) + " " + getString(R.string.km_short) + getString(R.string.card_trip_km_trip);

                // set views' actual values.
                id.setText(String.valueOf(trip.getId()));
                title.setText(trip.getTitle());
                times.setText(formattedTimesPerWeek);
                cost.setText(formattedCost);
                liters.setText(formattedLiters);
                km.setText(formattedKilometers);
                date.setText(trip.getDateAdded().toString());

                linearLayout.addView(card);
            }
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
        createCards();
    }
}