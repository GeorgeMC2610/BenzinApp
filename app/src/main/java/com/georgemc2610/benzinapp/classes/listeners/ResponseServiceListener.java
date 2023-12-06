package com.georgemc2610.benzinapp.classes.listeners;

import android.icu.text.NumberFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.Malfunction;
import com.georgemc2610.benzinapp.classes.Service;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.LocalDate;
import java.util.Locale;

public class ResponseServiceListener implements Response.Listener<String>
{
    private final LinearLayout linearLayout;
    private final LayoutInflater inflater;

    public ResponseServiceListener(LinearLayout linearLayout, LayoutInflater inflater)
    {
        this.linearLayout = linearLayout;
        this.inflater = inflater;
    }

    @Override
    public void onResponse(String response)
    {
        linearLayout.removeAllViews();

        try
        {
            // json response from the string response that was provided.
            JSONArray JsonArrayResponse = new JSONArray(response);

            System.out.println(response);

            for (int i = 0; i < JsonArrayResponse.length(); i++)
            {
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

                // delete button listeners

                // get the data
                JSONObject JsonObject = JsonArrayResponse.getJSONObject(i);

                // required data
                int id = JsonObject.getInt("id");
                int at_km = JsonObject.getInt("at_km");
                LocalDate date_happened = LocalDate.parse(JsonObject.getString("date_happened"));
                String description = JsonObject.getString("description");

                // create instance of the malfunction class.
                Service service = new Service(id, at_km, description, date_happened);

                // optional data
                String cost_try = JsonObject.getString("cost_eur");
                String next_km_try = JsonObject.getString("next_km");

                // set the optional values of the object.
                if (!cost_try.equals("null"))
                    service.setCost(Float.parseFloat(cost_try));

                if (!next_km_try.equals("null"))
                    service.setNextKm(Integer.parseInt(next_km_try));

                NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

                // set the views data
                // TODO: REMOVE HARDCODED STRINGS
                at_kmView.setText(numberFormat.format(at_km) + "km");
                dateView.setText(date_happened.toString());
                idHidden.setText(String.valueOf(id));

                costView.setText(cost_try.equals("null")? "-" : "€" + numberFormat.format(Float.parseFloat(cost_try)));
                next_kmView.setText(next_km_try.equals("null")? "Next in: -" : "Next in: " + numberFormat.format(Integer.parseInt(next_km_try)) + " km");

                // add the view
                linearLayout.addView(v);
            }
        }
        catch (JSONException e)
        {
            System.out.println("Something went wrong. Exception message:\n" + e.getMessage());
        }
    }
}
