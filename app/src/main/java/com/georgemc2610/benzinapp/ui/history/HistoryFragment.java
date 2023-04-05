package com.georgemc2610.benzinapp.ui.history;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.ActivityAddRecord;
import com.georgemc2610.benzinapp.DatabaseManager;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentHistoryBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class HistoryFragment extends Fragment implements Response.Listener<String>
{

    private FragmentHistoryBinding binding;

    FloatingActionButton ButtonAdd;
    LinearLayout scrollViewLayout;
    TextView hint;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        binding = FragmentHistoryBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        ButtonAdd = root.findViewById(R.id.button_add);
        ButtonAdd.setOnClickListener(new ButtonAddListener(getContext()));

        hint = root.findViewById(R.id.textViewClickCardsMsg);

        scrollViewLayout = root.findViewById(R.id.historyFragment_linearLayoutScrollView);
        //DatabaseManager.getInstance().DisplayCards(scrollViewRelativeLayout, getLayoutInflater(), hint);

        RequestHandler.getInstance().GetFuelFillRecords(getActivity(), this);

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
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

                // add click listeners
                // TODO: ADD LISTENERS FOR ONLCLICK
                // delete button click listener
                deleteButton.setOnClickListener(new View.OnClickListener()
                {
                    @Override
                    public void onClick(View v)
                    {
                        AlertDialog.Builder dialog = new AlertDialog.Builder(getContext());

                        dialog.setTitle(getString(R.string.dialog_delete_title));
                        dialog.setMessage(getString(R.string.dialog_delete_confirmation));

                        dialog.setPositiveButton(getString(R.string.dialog_yes), new DialogInterface.OnClickListener()
                        {
                            @Override
                            public void onClick(DialogInterface dialog, int which)
                            {

                            }
                        });

                        dialog.setNegativeButton(getString(R.string.dialog_no), new DialogInterface.OnClickListener()
                        {
                            @Override
                            public void onClick(DialogInterface dialog, int which)
                            {
                                // foo
                            }
                        });

                        dialog.setCancelable(true);
                        dialog.create().show();
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


class ButtonAddListener implements View.OnClickListener
{
    private final Context context;

    ButtonAddListener(Context context)
    {
        this.context = context;
    }

    @Override
    public void onClick(View v)
    {
        Intent intent = new Intent(context, ActivityAddRecord.class);
        context.startActivity(intent);
    }
}