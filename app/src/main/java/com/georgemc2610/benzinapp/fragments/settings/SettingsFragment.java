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
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.activity_tools.LanguageTool;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;
import com.georgemc2610.benzinapp.databinding.FragmentSettingsBinding;

import java.util.Arrays;
import java.util.Locale;

public class SettingsFragment extends Fragment
{
    private String[] languageOptions;
    private Locale[] languages;
    private int selectLanguagePosition;
    private Switch darkModeToggle, fastLoginToggle;
    private Button logoutButton, languageButton;
    private SharedPreferences preferences;
    private boolean autoLogin, nightMode;
    private FragmentSettingsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // initialize fragment.
        binding = FragmentSettingsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        // get language spinner and add options
        languageButton = root.findViewById(R.id.settings_LanguageButton);
        languageButton.setOnClickListener(this::onButtonSelectLanguageClicked);

        // language dialog settings.
        languageOptions = new String[] { getString(R.string.spinner_option_same_as_system), "English UK", "Ελληνικά GR" };
        languages = new Locale[] { null, new Locale("en"), new Locale("el") };
        selectLanguagePosition = Arrays.asList(languages).indexOf(Locale.getDefault());

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

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
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

    private void onButtonLogoutClicked(View v)
    {
        RequestHandler.getInstance().Logout(getActivity());
    }

    private void onButtonSelectLanguageClicked(View v)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getContext());

        if (selectLanguagePosition == -1)
            selectLanguagePosition = 0;

        // TODO: REPLACE WITH STRING VALUES.
        builder.setCancelable(true);
        builder.setTitle("Set Application Language");
        builder.setSingleChoiceItems(languageOptions, selectLanguagePosition, (dialog, which) ->
        {
            selectLanguagePosition = which;
        });
        builder.setNeutralButton("OK", (dialog, which) -> changeLanguage());
        builder.show();
    }

    private void changeLanguage()
    {
        LanguageTool.setSelectedLocale(selectLanguagePosition == -1? null : languages[selectLanguagePosition]);
        getActivity().recreate();
    }
}