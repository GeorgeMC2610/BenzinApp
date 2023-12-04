package com.georgemc2610.benzinapp.classes.listeners;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.Malfunction;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.LocalDate;

public class ResponseMalfunctionListener implements Response.Listener<String>
{
    private final LinearLayout linearLayout;
    private final LayoutInflater inflater;

    public ResponseMalfunctionListener(LinearLayout linearLayout, LayoutInflater inflater)
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

            for (int i = 0; i < JsonArrayResponse.length(); i++)
            {
                // get the card view
                View v = inflater.inflate(R.layout.cardview_malfunction, null);

                // card view text views
                TextView titleView = v.findViewById(R.id.card_malfunction_title);
                TextView at_kmView = v.findViewById(R.id.card_malfunction_at_km);
                TextView dateView = v.findViewById(R.id.card_malfunction_date);
                TextView statusView = v.findViewById(R.id.card_malfunction_status);

                // card view buttons
                FloatingActionButton deleteButton = v.findViewById(R.id.card_malfunction_button_delete);
                FloatingActionButton editButton = v.findViewById(R.id.card_malfunction_button_edit);
                FloatingActionButton fixButton = v.findViewById(R.id.card_malfunction_button_fix);

                // get the data
                JSONObject JsonObject = JsonArrayResponse.getJSONObject(i);

                int id = JsonObject.getInt("id");
                int at_km = JsonObject.getInt("at_km");
                String title = JsonObject.getString("title");
                String description = JsonObject.getString("description");
                LocalDate started = LocalDate.parse(JsonObject.getString("started"));

                // create instance of the malfunction class.
                Malfunction malfunction = new Malfunction();

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
