package com.georgemc2610.benzinapp.fragments.history;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.activity_display.ActivityDisplayFuelFillRecord;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddRecordActivityListener;
import com.georgemc2610.benzinapp.classes.listeners.CardDeleteButtonListener;
import com.georgemc2610.benzinapp.classes.listeners.CardEditButtonListener;
import com.georgemc2610.benzinapp.databinding.FragmentHistoryBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

public class HistoryFragment extends Fragment
{
    private FragmentHistoryBinding binding;

    FloatingActionButton ButtonAdd;
    ImageView image;
    LinearLayout scrollViewLayout;
    LayoutInflater inflater;
    TextView hint, totalFuelFillRecords;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // necessary code for creating the fragment.
        binding = FragmentHistoryBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // Floating Action Button for adding a new record.
        ButtonAdd = root.findViewById(R.id.button_add);
        ButtonAdd.setOnClickListener(new ButtonRedirectToAddRecordActivityListener(getContext()));

        // hint located in the downside of the cards.
        hint = root.findViewById(R.id.textViewClickCardsMsg);

        // image view can have its visibility revoked if there are no entries.
        image = root.findViewById(R.id.image_view_records_nothing);

        // scrollview layout for the cards.
        scrollViewLayout = root.findViewById(R.id.historyFragment_linearLayoutScrollView);
        this.inflater = getLayoutInflater();

        // text view with total fuel fill records
        totalFuelFillRecords = root.findViewById(R.id.text_view_history_total_fuel_fill_records);

        if (DataHolder.getInstance().records.isEmpty())
        {
            image.setVisibility(View.VISIBLE);
            totalFuelFillRecords.setVisibility(View.GONE);
            hint.setVisibility(View.GONE);
            scrollViewLayout.setVisibility(View.GONE);
        }
        else if (DataHolder.getInstance().records.size() == 1)
            totalFuelFillRecords.setText(R.string.text_view_one_record);
        else
            totalFuelFillRecords.setText(DataHolder.getInstance().records.size() + getString(R.string.text_view_total_records));

        return root;
    }

    private void createCards()
    {
        // initialize views.
        scrollViewLayout.removeAllViews();
        hint.setText(getString(R.string.text_view_click_cards_message_empty));

        // Group objects by year and month
        Map<YearMonth, List<FuelFillRecord>> groupedRecords = new TreeMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM yyyy", Locale.getDefault());

        for (int i = DataHolder.getInstance().records.size() - 1; i >= 0; i--)
        {
            FuelFillRecord record = DataHolder.getInstance().records.get(i);

            YearMonth key = YearMonth.from(record.getDate());
            groupedRecords.computeIfAbsent(key, k -> new ArrayList<>()).add(record);
        }

        for (int i = groupedRecords.keySet().size() - 1; i >= 0; i--)
        {
            YearMonth key = new ArrayList<>(groupedRecords.keySet()).get(i);

            List<FuelFillRecord> recordsInMonthYear = groupedRecords.get(key);
            String stringYearMonth = key.format(formatter);

            for (FuelFillRecord record : recordsInMonthYear)
            {
                // inflate the card view for the fuel fill records.
                View v;

                if (recordsInMonthYear.indexOf(record) == 0)
                {
                    v = inflater.inflate(R.layout.cardview_fill_with_legend, null);
                    TextView legend = v.findViewById(R.id.card_year_month_legend);
                    legend.setText(stringYearMonth);
                }
                else
                    v = inflater.inflate(R.layout.cardview_fill, null);

                // get the card's views.
                TextView petrolType = v.findViewById(R.id.card_filled_petrol);
                TextView idHidden = v.findViewById(R.id.card_hidden_id);
                TextView lt_per_100 = v.findViewById(R.id.card_lt_per_100);
                TextView cost = v.findViewById(R.id.card_cost);
                TextView date = v.findViewById(R.id.card_date);
                FloatingActionButton deleteButton = v.findViewById(R.id.card_buttonDelete);
                FloatingActionButton editButton = v.findViewById(R.id.card_buttonEdit);

                // text formatting init
                DecimalFormat decimalFormat = new DecimalFormat("#.##");
                NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.getDefault());

                // format the texts.
                String formattedCost = '€' + decimalFormat.format(record.getCost_eur());
                String formattedLitersPer100Km = numberFormat.format(record.getLt_per_100km()) + ' ' + getString(R.string.lt_short) + "/100 " + getString(R.string.km_short);

                // station text
                String station;

                if (record.getStation() == null || record.getStation().isEmpty())
                {
                    if (record.getFuelType() == null || record.getFuelType().isEmpty())
                        station = "-";

                    else
                        station = record.getFuelType();

                }
                else
                {
                    if (record.getFuelType() == null || record.getFuelType().isEmpty())
                        station = record.getStation();

                    else
                        station = record.getFuelType() + ", " + record.getStation();

                }

                // set the card's views actual values.
                petrolType.setText(station);
                idHidden.setText(String.valueOf(record.getId()));
                lt_per_100.setText(formattedLitersPer100Km);
                cost.setText(formattedCost);
                date.setText(record.getDate().toString());

                // add the view to the scroll view's layout
                scrollViewLayout.addView(v);

                // set button edit and delete listeners.
                editButton.setOnClickListener(new CardEditButtonListener(this, record));
                deleteButton.setOnClickListener(new CardDeleteButtonListener(this, record));

                // set listener for when the user presses the card view.
                v.setOnClickListener(v1 ->
                {
                    Intent intent = new Intent(getContext(), ActivityDisplayFuelFillRecord.class);
                    intent.putExtra("record", record);
                    startActivity(intent);
                });

                // change the hint text.
                hint.setText(getString(R.string.text_view_click_cards_message));
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