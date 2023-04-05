package com.georgemc2610.benzinapp.ui.home;

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

        // make the request
        RequestHandler.getInstance().GetCarInfo(getActivity(), this);

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
            JSONObject jsonObject = new JSONObject(response);

            String manufacturer = jsonObject.getString("manufacturer");
            String model = jsonObject.getString("model");
            String year = jsonObject.getString("year");

            String wholeCar = manufacturer + " " + model;

            car.setText(wholeCar);
            this.year.setText(year);
        }
        catch (JSONException jsonException)
        {
            throw new RuntimeException(jsonException);
        }
    }
}