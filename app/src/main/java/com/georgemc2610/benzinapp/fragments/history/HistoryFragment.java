package com.georgemc2610.benzinapp.fragments.history;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
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

public class HistoryFragment extends Fragment
{
    private FragmentHistoryBinding binding;

    FloatingActionButton ButtonAdd;
    LinearLayout scrollViewLayout;
    LayoutInflater inflater;
    TextView hint;

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

        // scrollview layout for the cards.
        scrollViewLayout = root.findViewById(R.id.historyFragment_linearLayoutScrollView);
        this.inflater = getLayoutInflater();

        // scrollable cards.
        createCards();

        return root;
    }

    private void createCards()
    {
        // initialize views.
        scrollViewLayout.removeAllViews();
        hint.setText(getString(R.string.text_view_click_cards_message_empty));

        for (FuelFillRecord record : DataHolder.getInstance().records)
        {
            // inflate the card view for the fuel fill records.
            View v = inflater.inflate(R.layout.cardview_fill, null);

            // get the card's views.
            TextView petrolType = v.findViewById(R.id.card_filled_petrol);
            TextView idHidden = v.findViewById(R.id.card_hidden_id);
            TextView lt_per_100 = v.findViewById(R.id.card_lt_per_100);
            TextView cost = v.findViewById(R.id.card_cost);
            TextView date = v.findViewById(R.id.card_date);
            FloatingActionButton deleteButton = v.findViewById(R.id.card_buttonDelete);
            FloatingActionButton editButton = v.findViewById(R.id.card_buttonEdit);

            // set the card's views actual values.
            petrolType.setText(record.getFuelType() + ", " + record.getStation());
            idHidden.setText(String.valueOf(record.getId()));
            lt_per_100.setText(record.getLt_per_100km() + " lt/100km");
            cost.setText("€" + record.getCost_eur());
            date.setText(record.getDate().toString());

            // add the view to the scroll view's layout
            scrollViewLayout.addView(v);

            // set button edit and delete listeners.
            editButton.setOnClickListener(new CardEditButtonListener(this, record));
            deleteButton.setOnClickListener(new CardDeleteButtonListener(this, record));

            // set listener for when the user presses the card view.
            v.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    Intent intent = new Intent(getContext(), ActivityDisplayFuelFillRecord.class);
                    intent.putExtra("record", record);
                    startActivity(intent);
                }
            });

            // change the hint text.
            hint.setText(getString(R.string.text_view_click_cards_message));
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