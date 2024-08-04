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
import com.georgemc2610.benzinapp.classes.activity_tools.NightModeTool;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.original.Service;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.databinding.FragmentHomeBinding;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.components.Description;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis.AxisDependency;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;
import com.github.mikephil.charting.formatter.ValueFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.TimeUnit;

public class HomeFragment extends Fragment
{

    TextView car, year, avg_ltPer100Km, avg_KmPerLt, avg_CostPerKm;
    Spinner spinner;
    LineChart lineChart;
    PieChart pieChart;
    DecimalFormat format;
    LineData lineDataLtPer100, lineDataKmPerLt, lineDataCostPerKm;
    LineDataSet lineDataSetLtPer100, lineDataSetKmPerLt, lineDataSetCostPerKm;
    ArrayList<Entry> entriesLtPer100, entriesKmPerLt, entriesCostPerKm;
    private FragmentHomeBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // fragment init
        binding = FragmentHomeBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get views
        car = root.findViewById(R.id.textView_Car);
        year = root.findViewById(R.id.textView_Year);
        avg_CostPerKm = root.findViewById(R.id.textView_AVG_CostPerKm);
        avg_ltPer100Km = root.findViewById(R.id.textView_AVG_LtPer100Km);
        avg_KmPerLt = root.findViewById(R.id.textView_AVG_KmPerLt);
        lineChart = root.findViewById(R.id.graph);
        pieChart = root.findViewById(R.id.pie_chart_costs);

        // decimal formatter
        format = new DecimalFormat("#.##");

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
        setPieChartView();

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
        String finalCarString = DataHolder.getInstance().car.getManufacturer() +
                " " +
                DataHolder.getInstance().car.getModel();

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

        // color for the texts.
        int color = NightModeTool.getTextColor(getActivity());

        // get line data set for liters per 100 km.
        lineDataSetLtPer100 = new LineDataSet(entriesLtPer100, getString(R.string.graph_view_liters_per_100_km));
        lineDataSetLtPer100.setAxisDependency(AxisDependency.LEFT);
        lineDataSetLtPer100.setColor(ColorTemplate.getHoloBlue());
        lineDataSetLtPer100.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSetLtPer100.setLineWidth(1.5f);
        lineDataSetLtPer100.setDrawCircles(true);
        lineDataSetLtPer100.setFillColor(ColorTemplate.getHoloBlue());
        lineDataSetLtPer100.setHighLightColor(Color.rgb(244, 117, 117));

        // get line data set for km per lt
        lineDataSetKmPerLt = new LineDataSet(entriesKmPerLt, getString(R.string.graph_view_km_per_lt));
        lineDataSetKmPerLt.setAxisDependency(AxisDependency.LEFT);
        lineDataSetKmPerLt.setColor(ColorTemplate.rgb("#dd0000"));
        lineDataSetKmPerLt.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSetKmPerLt.setLineWidth(1.5f);
        lineDataSetKmPerLt.setDrawCircles(true);
        lineDataSetKmPerLt.setFillColor(ColorTemplate.rgb("#aa0000"));
        lineDataSetKmPerLt.setHighLightColor(Color.rgb(244, 0, 0));

        // get line data set for cost per km
        lineDataSetCostPerKm = new LineDataSet(entriesCostPerKm, getString(R.string.graph_view_cost_per_km));
        lineDataSetCostPerKm.setAxisDependency(AxisDependency.LEFT);
        lineDataSetCostPerKm.setColor(ColorTemplate.rgb("#00dd00"));
        lineDataSetCostPerKm.setValueTextColor(ColorTemplate.getHoloBlue());
        lineDataSetCostPerKm.setLineWidth(1.5f);
        lineDataSetCostPerKm.setDrawCircles(true);
        lineDataSetCostPerKm.setFillColor(ColorTemplate.rgb("#00aa00"));
        lineDataSetCostPerKm.setHighLightColor(Color.rgb(244, 0, 0));

        // get line data for lt per 100 km
        lineDataLtPer100 = new LineData(lineDataSetLtPer100);
        lineDataLtPer100.setValueTextColor(color);
        lineDataLtPer100.setValueTextSize(9f);

        // get line data for km per lt
        lineDataKmPerLt = new LineData(lineDataSetKmPerLt);
        lineDataKmPerLt.setValueTextColor(color);
        lineDataKmPerLt.setValueTextSize(9f);

        // get line data for cost per km
        lineDataCostPerKm = new LineData(lineDataSetCostPerKm);
        lineDataCostPerKm.setValueTextColor(color);
        lineDataCostPerKm.setValueTextSize(9f);

        // and set the different colours
        lineChart.setData(lineDataLtPer100);

        // description label
        Description description = new Description();
        description.setText("");

        // color text for the graph.
        description.setTextColor(color);
        lineChart.setDescription(description);

        // format the strings for averages.
        String TextAvgLtPer100Km = Float.isNaN(DataHolder.getInstance().car.getAverageLitersPer100Km())     ? getString(R.string.text_view_no_data) : format.format(DataHolder.getInstance().car.getAverageLitersPer100Km()) + " " + getString(R.string.lt_short) + "/100 " + getString(R.string.km_short);
        String TextAvgKmPerLt    = Float.isNaN(DataHolder.getInstance().car.getAverageKilometersPerLiter()) ? getString(R.string.text_view_no_data) : format.format(DataHolder.getInstance().car.getAverageKilometersPerLiter()) + " " + getString(R.string.km_short) + "/" + getString(R.string.lt_short);
        String TextAvgCostPerKm  = Float.isNaN(DataHolder.getInstance().car.getAverageCostPerKm())          ? getString(R.string.text_view_no_data) : '€' + format.format(DataHolder.getInstance().car.getAverageCostPerKm()) + "/" + getString(R.string.km_short);

        // set the formats in the text views.
        avg_ltPer100Km.setText(TextAvgLtPer100Km);
        avg_KmPerLt.setText(TextAvgKmPerLt);
        avg_CostPerKm.setText(TextAvgCostPerKm);
    }

    private void setPieChartView()
    {
        ArrayList<PieEntry> pieEntries = new ArrayList<>();

        // get all total costs
        float fuelCosts = 0f, serviceCosts = 0f, malfunctionCosts = 0f;

        // firstly from fuel
        for (FuelFillRecord record : DataHolder.getInstance().records)
            fuelCosts += record.getCost_eur();

        // then from services
        for (Service service : DataHolder.getInstance().services)
            if (service.getCost() != -1f)
                serviceCosts += service.getCost();

        // then from malfunctions
        for (Malfunction malfunction : DataHolder.getInstance().malfunctions)
            if (malfunction.getCost() != -1f)
                malfunctionCosts += malfunction.getCost();

        // mapping the costs with their type.
        Map<String, Float> costAmountMap = new HashMap<>();
        costAmountMap.put("Fuel", fuelCosts); // TODO: Replace with string values
        costAmountMap.put("Malfunctions", malfunctionCosts); // TODO: Replace with string values
        costAmountMap.put("Services", serviceCosts); // TODO: Replace with string values

        // array list with colors
        ArrayList<Integer> colors = new ArrayList<>();
        colors.add(getResources().getColor(R.color.car_model_light, getContext().getTheme()));
        colors.add(getResources().getColor(R.color.car_manufacturer_light, getContext().getTheme()));
        colors.add(getResources().getColor(R.color.main, getContext().getTheme()));

        // total combined costs string.
        String finalCosts = "Total: €";
        finalCosts += format.format(fuelCosts + serviceCosts + malfunctionCosts);

        // description label
        Description description = new Description();
        description.setText(finalCosts);

        // color text for the graph.
        description.setTextColor(NightModeTool.getTextColor(getActivity()));
        pieChart.setDescription(description);

        // put to pie chart data
        for (String type: costAmountMap.keySet())
            pieEntries.add(new PieEntry(costAmountMap.get(type), type));

        PieDataSet pieDataSet = new PieDataSet(pieEntries, "");
        pieDataSet.setValueTextSize(14f);
        pieDataSet.setColors(colors);
        pieDataSet.setDrawValues(true);

        PieData pieData = new PieData(pieDataSet);
        pieData.setValueFormatter(new ValueFormatter()
        {
            @Override
            public String getFormattedValue(float value)
            {
                float actualValue = Float.parseFloat(super.getFormattedValue(value));
                return DecimalFormat.getCurrencyInstance(new Locale("el_GR")).format(actualValue).replace('¤', '€');
            }
        });

        pieData.setValueTextColor(Color.BLACK);
        pieData.setHighlightEnabled(true);
        pieData.setDrawValues(true);

        pieChart.setData(pieData);
        pieChart.setDrawEntryLabels(false);
        pieChart.setDrawHoleEnabled(false);
        pieChart.setDrawSlicesUnderHole(true);
    }
}