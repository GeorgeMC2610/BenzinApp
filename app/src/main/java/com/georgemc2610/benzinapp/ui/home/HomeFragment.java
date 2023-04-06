package com.georgemc2610.benzinapp.ui.home;

import android.graphics.Color;
import android.graphics.ColorSpace;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.android.volley.Response;
import com.georgemc2610.benzinapp.R;
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
    private FragmentHomeBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {

        binding = FragmentHomeBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get views
        car = root.findViewById(R.id.textView_Car);
        year = root.findViewById(R.id.textView_Year);

        GraphView graphView = (GraphView) root.findViewById(R.id.graph);

        LineGraphSeries<DataPoint> series = new LineGraphSeries<DataPoint>(new DataPoint[] {
                new DataPoint(-2, 4),
                new DataPoint(-1, 1),
                new DataPoint(0, 0),
                new DataPoint(1, 1),
                new DataPoint(2, 4),
        });

        LineGraphSeries<DataPoint> series2 = new LineGraphSeries<DataPoint>(new DataPoint[] {
                new DataPoint(-2, -2),
                new DataPoint(-1, -1),
                new DataPoint(0, 0),
                new DataPoint(1, 1),
                new DataPoint(2, 2),
        });

        series.setColor(Color.rgb(255, 0, 0));
        series2.setColor(Color.rgb(0, 255, 0));

        graphView.addSeries(series);
        graphView.addSeries(series2);
        graphView.setTitle("ΚΑΤΑΝΑΛΩΣΗ");

        // make the request
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

    @Override
    public void onResponse(String response)
    {
        try
        {
            if (response.charAt(0) != '[')
            {
                JSONObject jsonObject = new JSONObject(response);
                SetCarInfo(jsonObject);
            }
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

    }
}