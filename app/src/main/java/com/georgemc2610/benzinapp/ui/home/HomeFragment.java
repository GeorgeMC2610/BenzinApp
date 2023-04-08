package com.georgemc2610.benzinapp.ui.home;

import android.graphics.Color;
import android.graphics.ColorSpace;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentHomeBinding;
import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class HomeFragment extends Fragment implements Response.Listener<String>
{

    TextView car, year;
    GraphView graphView;
    Spinner spinner;
    int graphPosition = 0;
    private FragmentHomeBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {

        binding = FragmentHomeBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get views
        car = root.findViewById(R.id.textView_Car);
        year = root.findViewById(R.id.textView_Year);

        graphView = (GraphView) root.findViewById(R.id.graph);

        // all this just for the spinner
        spinner = root.findViewById(R.id.SpinnerOptions);

        String[] options = new String[] { "Liters per 100 Kilometers", "Kilometers per Liter", "Cost per Kilometer" };

        ArrayAdapter<String> adapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, options);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener()
        {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
            {
                graphPosition = position;
                RequestHandler.getInstance().GetFuelFillRecords(getActivity(), HomeFragment.this);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent)
            {
                // foo
            }
        });

        // make the requests
        RequestHandler.getInstance().GetCarInfo(getActivity(), this);
        RequestHandler.getInstance().GetFuelFillRecords(getActivity(), this);

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }

    // json response handler
    @Override
    public void onResponse(String response)
    {
        try
        {
            // if the response is not an array, then we requested the car info
            if (response.charAt(0) != '[')
            {
                JSONObject jsonObject = new JSONObject(response);
                SetCarInfo(jsonObject);
            }
            // if it is, we requested the fuel fill records
            else
            {
                JSONArray jsonArray = new JSONArray(response);
                SetGraphView(jsonArray);
            }
        }
        catch (JSONException jsonException)
        {
            throw new RuntimeException(jsonException);
        }
    }

    private void SetCarInfo(JSONObject jsonObject) throws JSONException
    {
        String manufacturer = jsonObject.getString("manufacturer");
        String model = jsonObject.getString("model");
        String year = jsonObject.getString("year");

        String wholeCar = manufacturer + " " + model;

        car.setText(wholeCar);
        this.year.setText(year);
    }

    private void SetGraphView(JSONArray jsonArray) throws JSONException
    {
        // create three lines that correspond to different data.
        LineGraphSeries<DataPoint> seriesLtPer100 = new LineGraphSeries<>();
        LineGraphSeries<DataPoint> seriesKmPerLt = new LineGraphSeries<>();
        LineGraphSeries<DataPoint> seriesCostPerKm = new LineGraphSeries<>();

        // get all the possible points
        for (int i = 0; i < jsonArray.length(); i++)
        {
            FuelFillRecord record = new FuelFillRecord(jsonArray.getJSONObject(i));

            DataPoint ltPer100 = new DataPoint(i+1, record.getLt_per_100km());
            seriesLtPer100.appendData(ltPer100, false, jsonArray.length());

            DataPoint kmPerLt = new DataPoint(i+1, record.getKm_per_lt());
            seriesKmPerLt.appendData(kmPerLt, false, jsonArray.length());

            DataPoint costPerKm = new DataPoint(i+1, record.getCostEur_per_km());
            seriesCostPerKm.appendData(costPerKm, false, jsonArray.length());
        }

        // and set the different colours
        seriesLtPer100.setColor(Color.rgb(0, 0, 255));
        seriesKmPerLt.setColor(Color.rgb(0, 255, 0));
        seriesCostPerKm.setColor(Color.rgb(255, 0, 0));

        graphView.removeAllSeries();

        switch (graphPosition)
        {
            case 0:
                graphView.setTitle("Lt./100Km depend on time");
                graphView.addSeries(seriesLtPer100);
                break;
            case 1:
                graphView.setTitle("Km/Lt. depend on time");
                graphView.addSeries(seriesKmPerLt);
                break;
            case 2:
                graphView.setTitle("Cost/Km depend on time");
                graphView.addSeries(seriesCostPerKm);
                break;
        }
    }
}