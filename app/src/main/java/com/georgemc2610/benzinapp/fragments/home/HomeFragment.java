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
    LineData lineDataLtPer100, lineDataKmPerLt, lineDataCostPerKm;
    LineDataSet lineDataSetLtPer100, lineDataSetKmPerLt, lineDataSetCostPerKm;
    ArrayList<Entry> entriesLtPer100, entriesKmPerLt, entriesCostPerKm;
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

        // calculate car averages
        DataHolder.getInstance().car.calculateAverages();

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
                switch (position)
                {
                    case 0:
                        lineChart.setData(lineDataLtPer100);
                        lineChart.forceLayout();
                        break;
                    case 1:
                        lineChart.setData(lineDataKmPerLt);
                        lineChart.forceLayout();
                        break;
                    case 2:
                        lineChart.setData(lineDataCostPerKm);
                        lineChart.forceLayout();
                        break;
                }
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
        // entries for the data.
        entriesLtPer100 = new ArrayList<>();
        entriesKmPerLt = new ArrayList<>();
        entriesCostPerKm = new ArrayList<>();

        // time x-axis
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

        // get all the possible points
        for (FuelFillRecord record : DataHolder.getInstance().records)
        {
            // initialize all entries.
            Entry entryLtPer100 = new Entry();
            Entry entryKmPerLt = new Entry();
            Entry entryCostPerKm = new Entry();

            // add the y values.
            entryLtPer100.setY(record.getLt_per_100km());
            entryKmPerLt.setY(record.getKm_per_lt());
            entryCostPerKm.setY(record.getCostEur_per_km());

            // add the x values.
            entryLtPer100.setX(record.getDate().toEpochDay());
            entryCostPerKm.setX(record.getDate().toEpochDay());
            entryKmPerLt.setX(record.getDate().toEpochDay());

            // and then add them to the list.
            entriesLtPer100.add(entryLtPer100);
            entriesKmPerLt.add(entryKmPerLt);
            entriesCostPerKm.add(entryCostPerKm);
        }

        // get line data set for liters per 100 km.
        lineDataSetLtPer100 = new LineDataSet(entriesLtPer100, getString(R.string.graph_view_liters_per_100_km));
        lineDataSetLtPer100.setAxisDependency(AxisDependency.LEFT);
        lineDataSetLtPer100.setColor(ColorTemplate.getHoloBlue());
        lineDataSetLtPer100.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSetLtPer100.setLineWidth(1.5f);
        lineDataSetLtPer100.setDrawCircles(false);
        lineDataSetLtPer100.setFillColor(ColorTemplate.getHoloBlue());
        lineDataSetLtPer100.setHighLightColor(Color.rgb(244, 117, 117));

        // get line data set for km per lt
        lineDataSetKmPerLt = new LineDataSet(entriesKmPerLt, getString(R.string.graph_view_km_per_lt));
        lineDataSetKmPerLt.setAxisDependency(AxisDependency.LEFT);
        lineDataSetKmPerLt.setColor(ColorTemplate.rgb("#dd0000"));
        lineDataSetKmPerLt.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSetKmPerLt.setLineWidth(1.5f);
        lineDataSetKmPerLt.setDrawCircles(false);
        lineDataSetKmPerLt.setFillColor(ColorTemplate.rgb("#aa0000"));
        lineDataSetKmPerLt.setHighLightColor(Color.rgb(244, 0, 0));

        // get line data set for cost per km
        lineDataSetCostPerKm = new LineDataSet(entriesCostPerKm, getString(R.string.graph_view_cost_per_km));
        lineDataSetCostPerKm.setAxisDependency(AxisDependency.LEFT);
        lineDataSetCostPerKm.setColor(ColorTemplate.rgb("#00dd00"));
        lineDataSetCostPerKm.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSetCostPerKm.setLineWidth(1.5f);
        lineDataSetCostPerKm.setDrawCircles(false);
        lineDataSetCostPerKm.setFillColor(ColorTemplate.rgb("#00aa00"));
        lineDataSetCostPerKm.setHighLightColor(Color.rgb(244, 0, 0));

        // get line data for lt per 100 km
        lineDataLtPer100 = new LineData(lineDataSetLtPer100);
        lineDataLtPer100.setValueTextColor(Color.WHITE);
        lineDataLtPer100.setValueTextSize(9f);

        // get line data for km per lt
        lineDataKmPerLt = new LineData(lineDataSetKmPerLt);
        lineDataKmPerLt.setValueTextColor(Color.WHITE);
        lineDataKmPerLt.setValueTextSize(9f);

        // get line data for cost per km
        lineDataCostPerKm = new LineData(lineDataSetCostPerKm);
        lineDataCostPerKm.setValueTextColor(Color.WHITE);
        lineDataCostPerKm.setValueTextSize(9f);

        // and set the different colours
        lineChart.setData(lineDataLtPer100);

        DecimalFormat format = new DecimalFormat("#.##");
        String TextAvgLtPer100Km = Float.isNaN(DataHolder.getInstance().car.getAverageLitersPer100Km())     ? getString(R.string.text_view_no_data) : format.format(DataHolder.getInstance().car.getAverageLitersPer100Km()) + " " + getString(R.string.lt_short) + "/100 " + getString(R.string.km_short);
        String TextAvgKmPerLt    = Float.isNaN(DataHolder.getInstance().car.getAverageKilometersPerLiter()) ? getString(R.string.text_view_no_data) : format.format(DataHolder.getInstance().car.getAverageKilometersPerLiter()) + " " + getString(R.string.km_short) + "/" + getString(R.string.lt_short);
        String TextAvgCostPerKm  = Float.isNaN(DataHolder.getInstance().car.getAverageCostPerKm())          ? getString(R.string.text_view_no_data) : '€' + format.format(DataHolder.getInstance().car.getAverageCostPerKm()) + " " + getString(R.string.km_short);

        avg_ltPer100Km.setText(TextAvgLtPer100Km);
        avg_KmPerLt.setText(TextAvgKmPerLt);
        avg_CostPerKm.setText(TextAvgCostPerKm);
    }
}