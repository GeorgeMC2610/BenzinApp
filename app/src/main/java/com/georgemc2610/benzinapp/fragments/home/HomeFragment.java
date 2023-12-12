package com.georgemc2610.benzinapp.fragments.home;

import android.graphics.Color;
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
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.components.YAxis.AxisDependency;
import com.github.mikephil.charting.data.ChartData;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.DefaultAxisValueFormatter;
import com.github.mikephil.charting.formatter.IAxisValueFormatter;
import com.github.mikephil.charting.formatter.ValueFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public class HomeFragment extends Fragment implements Response.Listener<String>
{

    TextView car, year, avg_ltPer100Km, avg_KmPerLt, avg_CostPerKm;
    Spinner spinner;
    LineChart lineChart;
    LineData lineData;
    LineDataSet lineDataSet;
    ArrayList<Entry> entries;

    int graphPosition = 0;
    private FragmentHomeBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {

        binding = FragmentHomeBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get views
        car = root.findViewById(R.id.textView_Car);
        year = root.findViewById(R.id.textView_Year);
        avg_CostPerKm = root.findViewById(R.id.textView_AVG_CostPerKm);
        avg_ltPer100Km = root.findViewById(R.id.textView_AVG_LtPer100Km);
        avg_KmPerLt = root.findViewById(R.id.textView_AVG_KmPerLt);
        lineChart = root.findViewById(R.id.graph);

        // all this just for the spinner
        spinner = root.findViewById(R.id.SpinnerOptions);

        String[] options = new String[] { getString(R.string.text_view_liters_per_100_km), getString(R.string.text_view_km_per_liter), getString(R.string.text_view_cost_per_km) };

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
        entries = new ArrayList<>();

        XAxis xAxis = lineChart.getXAxis();
        xAxis.setPosition(XAxis.XAxisPosition.BOTTOM);
        xAxis.setValueFormatter(new ValueFormatter()
        {
            private final SimpleDateFormat mFormat = new SimpleDateFormat("MM/yy", Locale.getDefault());

            @Override
            public String getFormattedValue(float value)
            {
                long millis = TimeUnit.DAYS.toMillis((long) value);
                return mFormat.format(new Date(millis));
            }
        });

        // initialize values for average
        float kilometerSum = 0;
        float literSum = 0;
        float costSum = 0;

        // get all the possible points
        for (int i = jsonArray.length() - 1; i >= 0; i--)
        {
            FuelFillRecord record = new FuelFillRecord(jsonArray.getJSONObject(i));

            Entry entry = new Entry();

            entry.setY(record.getLt_per_100km());
            entry.setX(record.getDate().toEpochDay());

            entries.add(entry);

            kilometerSum += record.getKilometers();
            literSum += record.getLiters();
            costSum += record.getCost_eur();
        }

        lineDataSet = new LineDataSet(entries, getString(R.string.graph_view_liters_per_100_km));
        lineDataSet.setAxisDependency(AxisDependency.LEFT);
        lineDataSet.setColor(ColorTemplate.getHoloBlue());
        lineDataSet.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSet.setLineWidth(1.5f);
        lineDataSet.setDrawCircles(false);
        lineDataSet.setFillColor(ColorTemplate.getHoloBlue());
        lineDataSet.setHighLightColor(Color.rgb(244, 117, 117));

        lineData = new LineData(lineDataSet);
        lineData.setValueTextColor(Color.WHITE);
        lineData.setValueTextSize(9f);

        // and set the different colours
        lineChart.setData(lineData);


        // calculate averages and display them
        float AvgLtPer100Km = 100 * literSum / kilometerSum;
        float AvgKmPerLt = kilometerSum / literSum;
        float AvgCostPerKm = costSum / kilometerSum;

        DecimalFormat format = new DecimalFormat("#.##");
        String TextAvgLtPer100Km = Float.isNaN(AvgLtPer100Km) ? getString(R.string.text_view_no_data) : format.format(AvgLtPer100Km) + " lt/100km";
        String TextAvgKmPerLt    = Float.isNaN(AvgKmPerLt)    ? getString(R.string.text_view_no_data) : format.format(AvgKmPerLt) + " km/lt";
        String TextAvgCostPerKm  = Float.isNaN(AvgCostPerKm)  ? getString(R.string.text_view_no_data) : '€' + format.format(AvgCostPerKm) + "/km";

        avg_ltPer100Km.setText(TextAvgLtPer100Km);
        avg_KmPerLt.setText(TextAvgKmPerLt);
        avg_CostPerKm.setText(TextAvgCostPerKm);
    }
}