package com.georgemc2610.benzinapp.fragments.settings;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentSettingsBinding;

public class SettingsFragment extends Fragment implements View.OnClickListener, AdapterView.OnItemSelectedListener {
    Spinner languageSpinner;
    Button LogoutButton;

    private FragmentSettingsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // initialize fragment.
        binding = FragmentSettingsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get language spinner and add options
        languageSpinner = root.findViewById(R.id.settings_LanguageSpinner);
        String[] options = new String[] { getString(R.string.spinner_option_same_as_system), "English", "Ελληνικά" };

        // add the options to the spinner.
        ArrayAdapter<String> adapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, options);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        languageSpinner.setAdapter(adapter);

        // set changed item listener for the spinner
        languageSpinner.setOnItemSelectedListener(this);

        // set listener for the logout button.
        LogoutButton = root.findViewById(R.id.settings_LogoutButton);
        LogoutButton.setOnClickListener(this);

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }

    @Override
    public void onClick(View v)
    {
        RequestHandler.getInstance().Logout(getActivity());
    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
    {
        if (position == 0)
        {
            System.out.println("ENGLISH!!");
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent)
    {

    }
}