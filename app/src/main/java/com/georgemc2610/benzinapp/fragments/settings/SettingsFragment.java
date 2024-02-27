package com.georgemc2610.benzinapp.fragments.settings;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.appcompat.widget.SwitchCompat;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.NightModeTool;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentSettingsBinding;

import java.util.Locale;

public class SettingsFragment extends Fragment implements View.OnClickListener, AdapterView.OnItemSelectedListener
{
    Spinner languageSpinner;
    Switch darkModeToggle, fastLoginToggle;
    Button LogoutButton;
    SharedPreferences preferences;
    private static int selectedLanguagePosition = -1;
    private boolean autoLogin, nightMode;

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

        // get the toggles and set their listeners
        darkModeToggle = root.findViewById(R.id.settings_DarkModeSwitch);
        fastLoginToggle = root.findViewById(R.id.settings_FastLoginSwitch);

        // be able to change it.
        fastLoginToggle.setOnCheckedChangeListener(this::onFastLoginStateChange);
        darkModeToggle.setOnCheckedChangeListener(this::onDarkThemeStateChange);

        // shared preferences for settings
        preferences = getContext().getSharedPreferences("settings", Context.MODE_PRIVATE);
        autoLogin = preferences.getBoolean("auto_login", true);
        nightMode = preferences.getBoolean("night_mode", false);

        // set the settings.
        fastLoginToggle.setChecked(autoLogin);
        darkModeToggle.setChecked(nightMode);

        return root;
    }

    private void onFastLoginStateChange(CompoundButton buttonView, boolean isChecked)
    {
        SharedPreferences.Editor editor = preferences.edit();

        editor.putBoolean("auto_login", isChecked);
        editor.apply();
    }

    private void onDarkThemeStateChange(CompoundButton buttonView, boolean isChecked)
    {
        SharedPreferences.Editor editor = preferences.edit();

        editor.putBoolean("night_mode", isChecked);
        editor.apply();

        AppCompatDelegate.setDefaultNightMode(isChecked? AppCompatDelegate.MODE_NIGHT_YES : AppCompatDelegate.MODE_NIGHT_NO);
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
        Locale locale;
        if (position != selectedLanguagePosition)
        {
            switch (position)
            {
                case 1:
                    locale = new Locale("en");
                    ChangeLanguage(locale);
                    break;
                case 2:
                    locale = new Locale("el");
                    ChangeLanguage(locale);
                    break;
                default:
                    locale = Locale.getDefault();
                    break;
            }
        }

        // Update the selected language position
        selectedLanguagePosition = position;
    }

    private void ChangeLanguage(Locale locale)
    {
        Locale.setDefault(locale);

        Resources resources = getResources();
        Configuration configuration = resources.getConfiguration();

        configuration.setLocale(locale);
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());

        getActivity().recreate();
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent)
    {

    }
}