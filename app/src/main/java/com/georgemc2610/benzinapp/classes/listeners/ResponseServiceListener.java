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

                // get the data
                JSONObject JsonObject = JsonArrayResponse.getJSONObject(i);

                // required data
                int id = JsonObject.getInt("id");
                int at_km = JsonObject.getInt("at_km");
                //double cost = JsonObject.getDouble("cost");
                String description = JsonObject.getString("description");
                int next_km = JsonObject.getInt("next_km");
                LocalDate date_happened = LocalDate.parse(JsonObject.getString("date_happened"));

                // create instance of the malfunction class.
                Service service = new Service(id, at_km, description, date_happened);

                // set the optional values of the object.
                //if (!Double.isNaN(cost))
                    //service.setCost((float) cost);

                if (next_km != 0)
                    service.setNextKm(next_km);

                NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());

                // set the views data
                at_kmView.setText(numberFormat.format(at_km) + "km");
                //costView.setText('€' + String.valueOf(cost));
                dateView.setText(date_happened.toString());
                next_kmView.setText( next_km == 0 ? "-" : "Next at: " + numberFormat.format(next_km) + " km");
                idHidden.setText(String.valueOf(id));

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
