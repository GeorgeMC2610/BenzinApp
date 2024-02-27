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
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Switch;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentSettingsBinding;

import java.util.Locale;

public class SettingsFragment extends Fragment
{
    Switch darkModeToggle, fastLoginToggle;
    Button logoutButton, languageButton;
    SharedPreferences preferences;
    private boolean autoLogin, nightMode;

    private FragmentSettingsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // initialize fragment.
        binding = FragmentSettingsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get language spinner and add options
        languageButton = root.findViewById(R.id.settings_LanguageButton);

        // set listener for the logout button.
        logoutButton = root.findViewById(R.id.settings_LogoutButton);
        logoutButton.setOnClickListener(this::onButtonLogoutClicked);

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

    /**
     * Sets the user's ability to login without entering their credentials. This is setting is then saved
     * using shared preferences.
     * @param buttonView The Switch.
     * @param isChecked True if the switch is on, false otherwise.
     */
    private void onFastLoginStateChange(CompoundButton buttonView, boolean isChecked)
    {
        SharedPreferences.Editor editor = preferences.edit();

        editor.putBoolean("auto_login", isChecked);
        editor.apply();
    }

    /**
     * Changes the entire application's theme and saves it in the shared preferences.
     * @param buttonView The Switch.
     * @param isChecked True if the switch is on, false otherwise.
     */
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

    private void onButtonLogoutClicked(View v)
    {
        RequestHandler.getInstance().Logout(getActivity());
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
}