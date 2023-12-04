package com.georgemc2610.benzinapp.ui.history;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.ActivityDisplayFuelFillRecord;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.classes.listeners.ButtonRedirectToAddRecordActivityListener;
import com.georgemc2610.benzinapp.classes.listeners.CardDeleteButtonListener;
import com.georgemc2610.benzinapp.classes.listeners.CardEditButtonListener;
import com.georgemc2610.benzinapp.databinding.FragmentHistoryBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.LocalDate;

public class HistoryFragment extends Fragment implements Response.Listener<String>
{

    private FragmentHistoryBinding binding;

    FloatingActionButton ButtonAdd;
    LinearLayout scrollViewLayout;
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

        RequestHandler.getInstance().GetFuelFillRecords(getActivity(), this);
    }

    @Override
    public void onResponse(String response)
    {
        try
        {
            scrollViewLayout.removeAllViews();
            LayoutInflater inflater = getLayoutInflater();
            hint.setText(getString(R.string.text_view_click_cards_message_empty));

            JSONArray JsonArrayResponse = new JSONArray(response);

            for (int i = 0; i < JsonArrayResponse.length(); i++)
            {
                // inflate the view.
                View v = inflater.inflate(R.layout.cardview_fill, null);

                // get views
                TextView petrolType = v.findViewById(R.id.card_filled_petrol);
                TextView idHidden = v.findViewById(R.id.card_hidden_id);
                TextView lt_per_100 = v.findViewById(R.id.card_lt_per_100);
                TextView cost = v.findViewById(R.id.card_cost);
                TextView date = v.findViewById(R.id.card_date);
                FloatingActionButton deleteButton = v.findViewById(R.id.card_buttonDelete);
                FloatingActionButton editButton = v.findViewById(R.id.card_buttonEdit);

                // get data
                JSONObject JsonObject = JsonArrayResponse.getJSONObject(i);

                int id = JsonObject.getInt("id");
                float km = (float) JsonObject.getDouble("km");
                float cost_eur = (float) JsonObject.getDouble("cost_eur");
                float lt = (float) JsonObject.getDouble("lt");
                String station = JsonObject.getString("station");
                String fuelType = JsonObject.getString("fuel_type");
                String notes = JsonObject.getString("notes");
                LocalDate filledAt = LocalDate.parse(JsonObject.getString("filled_at"));

                // create record instance
                FuelFillRecord record = new FuelFillRecord(id, lt, cost_eur, km, filledAt, station, fuelType, notes);

                // fill views
                petrolType.setText(record.getFuelType() + ", " + record.getStation());
                idHidden.setText(String.valueOf(record.getId()));
                lt_per_100.setText(record.getLt_per_100km() + " lt/100km");
                cost.setText("€" + record.getCost_eur());
                date.setText(record.getDate().toString());

                // add view
                scrollViewLayout.addView(v);

                // assign the listeners to the Floating Action Buttons.
                editButton.setOnClickListener(new CardEditButtonListener(this, record));
                deleteButton.setOnClickListener(new CardDeleteButtonListener(this, record));

                // card view click listener
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

                // change the hint
                hint.setText(getString(R.string.text_view_click_cards_message));
            }
        }
        catch (JSONException e)
        {
            throw new RuntimeException(e);
        }
    }
}