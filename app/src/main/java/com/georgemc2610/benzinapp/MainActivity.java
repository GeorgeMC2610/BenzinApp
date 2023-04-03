package com.georgemc2610.benzinapp;

import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.google.android.material.bottomnavigation.BottomNavigationView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.georgemc2610.benzinapp.databinding.ActivityMainBinding;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity implements Response.Listener
{

    private ActivityMainBinding binding;
    private SQLiteDatabase DB;

    private List<FuelFillRecord> fuelFillRecords;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        BottomNavigationView navView = findViewById(R.id.nav_view);
        // Passing each menu ID as a set of Ids because each
        // menu should be considered as top level destinations.
        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(R.id.navigation_home, R.id.navigation_all_records, R.id.navigation_settings).build();
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_activity_main);
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
        NavigationUI.setupWithNavController(binding.navView, navController);

        // here is where the singleton is created
        DB = openOrCreateDatabase("benzinAppDB.db", MODE_PRIVATE, null);
        DatabaseManager.create(DB);

        // this is for the request.
        RequestHandler.getInstance().GetFuelFillRecords(this, this);
    }

    @Override
    public void onResponse(Object response)
    {
        try
        {
            JSONArray JsonArrayResponse = new JSONArray(response.toString());
            List<FuelFillRecord> records = new ArrayList<>();

            for (int i = 0; i < JsonArrayResponse.length(); i++)
            {
                JSONObject JsonObject = JsonArrayResponse.getJSONObject(i);

                int id = JsonObject.getInt("id");
                float km = (float) JsonObject.getDouble("km");
                float cost_eur = (float) JsonObject.getDouble("cost_eur");
                float lt = (float) JsonObject.getDouble("lt");
                String fuelType = JsonObject.getString("fuel_type");
                String notes = JsonObject.getString("notes");
                LocalDate date = LocalDate.parse(JsonObject.getString("created_at"), DateTimeFormatter.ISO_LOCAL_DATE_TIME);

                FuelFillRecord record = new FuelFillRecord(lt, cost_eur, km, date);
                System.out.println("All went good.");
            }
        }
        catch (JSONException e)
        {
            throw new RuntimeException(e);
        }
    }
}