package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import com.georgemc2610.benzinapp.classes.activity_tools.Language;
import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.util.InputMismatchException;

public class LoginActivity extends AppCompatActivity
{

    EditText username, password;
    Button login;
    ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        // get the username and password views
        username = findViewById(R.id.editText_Username);
        password = findViewById(R.id.editText_Password);

        // get the button
        login = findViewById(R.id.buttonRegister);

        // progress bar for pressing the login button.
        progressBar = findViewById(R.id.progressBar_Login);

        // request handler singleton instance creation.
        RequestHandler.Create();
        DataHolder.Create();

        // remove the location picked preferences.
        SharedPreferences preferencesLocation = getSharedPreferences("location", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferencesLocation.edit();
        editor.putString("picked_location", null);
        editor.putString("picked_address", null);
        editor.apply();

        // put null for the repeated trip values.
        SharedPreferences preferencesRepeatedTrip = getSharedPreferences("repeated_trip", MODE_PRIVATE);
        SharedPreferences.Editor editorRepeatedTrip = preferencesRepeatedTrip.edit();
        editorRepeatedTrip.putString("encodedTrip", null);
        editorRepeatedTrip.putString("jsonTrip", null);
        editorRepeatedTrip.putFloat("tripDistance", -1f);
        editorRepeatedTrip.apply();

        // get settings preferences
        SharedPreferences preferences = getSharedPreferences("settings", MODE_PRIVATE);

        // get if the settings are set to default.
        boolean defaultSettings = preferences.getBoolean("default_settings", true);

        // get the other settings.
        boolean autoLogin = preferences.getBoolean("auto_login", true);
        int language = preferences.getInt("language", Language.SYSTEM_DEFAULT);
        boolean darkMode = preferences.getBoolean("dark_mode", false);

        // in case the default settings are enabled.
        if (defaultSettings)
        {
            // auto login is enabled by default.
            progressBar.setVisibility(View.VISIBLE);
            RequestHandler.getInstance().AttemptLogin(this, username, password, login, progressBar);
        }
        // otherwise seek for every setting.
        else
        {
            if (darkMode)
            {
                setTheme(R.style.Theme_BenzinApp);
            }

            if (autoLogin)
            {
                progressBar.setVisibility(View.VISIBLE);
                RequestHandler.getInstance().AttemptLogin(this, username, password, login, progressBar);
            }

            switch (language)
            {
                case Language.SYSTEM_DEFAULT:
                    break;
                case Language.ENGLISH:
                    break;
                case Language.GREEK:
                    break;
                default:
                    throw new InputMismatchException();
            }
        }


    }

    public void OnButtonLoginPressed(View v)
    {
        boolean canMoveOn = true;

        String processedUsername = username.getText().toString().trim();
        String processedPassword = password.getText().toString().trim();

        // check for empty edit texts and don't proceed if there are any.
        if (processedUsername.length() == 0)
        {
            username.setError(getString(R.string.error_field_cannot_be_empty));
            canMoveOn = false;
        }

        if (processedPassword.length() == 0)
        {
            password.setError(getString(R.string.error_field_cannot_be_empty));
            canMoveOn = false;
        }

        if (!canMoveOn) return;

        RequestHandler.getInstance().Login(this, processedUsername, processedPassword, username, password, login, progressBar);
    }

    public void OnTextViewRegisterClicked(View v)
    {
        // redirect to register
        Intent intent = new Intent(this, RegisterActivity.class);
        startActivity(intent);
        finish();
    }
}