package com.georgemc2610.benzinapp.fragments.settings;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentSettingsBinding;

public class SettingsFragment extends Fragment implements View.OnClickListener
{
    Spinner languageSpinner;
    Button LogoutButton;

    private FragmentSettingsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {

        binding = FragmentSettingsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        languageSpinner = root.findViewById(R.id.settings_LanguageSpinner);

        String[] options = new String[] { "English", "Ελληνικά" };

        LogoutButton = root.findViewById(R.id.settings_LogoutButton);
        LogoutButton.setOnClickListener(this);


        ArrayAdapter<String> adapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, options);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        languageSpinner.setAdapter(adapter);

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
}