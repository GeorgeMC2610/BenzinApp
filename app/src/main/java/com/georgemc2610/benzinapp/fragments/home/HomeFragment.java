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

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.databinding.FragmentHomeBinding;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis.AxisDependency;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.ValueFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public class HomeFragment extends Fragment
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
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent)
            {
                // foo
            }
        });

        SetCarInfo();
        SetGraphView();

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }

    private void SetCarInfo()
    {
        // this sets the car label to be the manufacturer + model.
        StringBuilder builder = new StringBuilder();
        builder.append(DataHolder.getInstance().car.getManufacturer());
        builder.append(" ");
        builder.append(DataHolder.getInstance().car.getModel());

        String finalCarString = builder.toString();

        car.setText(finalCarString);

        // set the year below the label of the car model + manufacturer
        year.setText(String.valueOf(DataHolder.getInstance().car.getYear()));
    }

    private void SetGraphView()
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
        for (FuelFillRecord record : DataHolder.getInstance().records)
        {
            Entry entry = new Entry();

            entry.setY(record.getLt_per_100km());
            entry.setX(record.getDate().toEpochDay());

            entries.add(entry);

            kilometerSum += record.getKilometers();
            literSum += record.getLiters();
            costSum += record.getCost_eur();
        }

        // get line data set.
        lineDataSet = new LineDataSet(entries, "lt/100km");
        lineDataSet = new LineDataSet(entries, getString(R.string.graph_view_liters_per_100_km));
        lineDataSet.setAxisDependency(AxisDependency.LEFT);
        lineDataSet.setColor(ColorTemplate.getHoloBlue());
        lineDataSet.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSet.setLineWidth(1.5f);
        lineDataSet.setDrawCircles(false);
        lineDataSet.setFillColor(ColorTemplate.getHoloBlue());
        lineDataSet.setHighLightColor(Color.rgb(244, 117, 117));

        // get line data.
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