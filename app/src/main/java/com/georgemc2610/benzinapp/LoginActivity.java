package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.cardview.widget.CardView;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

import java.util.InputMismatchException;

public class LoginActivity extends AppCompatActivity
{

    EditText username, password;
    CardView login;
    View register;
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
        login.setOnClickListener(this::OnButtonLoginPressed);

        // register text view
        register = findViewById(R.id.textView_RegisterIfNoAccount);
        register.setOnClickListener(this::OnTextViewRegisterClicked);

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
        editorRepeatedTrip.putFloat("origin_latitude", -1f);
        editorRepeatedTrip.putFloat("origin_longitude", -1f);
        editorRepeatedTrip.putFloat("destination_latitude", -1f);
        editorRepeatedTrip.putFloat("destination_longitude", -1f);
        editorRepeatedTrip.putFloat("tripDistance", -1f);
        editorRepeatedTrip.putString("polyline", null);
        editorRepeatedTrip.apply();

        // get settings preferences
        SharedPreferences preferences = getSharedPreferences("settings", MODE_PRIVATE);

        // get the other settings.
        boolean autoLogin = preferences.getBoolean("auto_login", true);
        //int language = preferences.getInt("language", Language.SYSTEM_DEFAULT);
        boolean darkMode = preferences.getBoolean("night_mode", false);

        // otherwise seek for every setting.
        if (autoLogin)
        {
            progressBar.setVisibility(View.VISIBLE);
            RequestHandler.getInstance().AttemptLogin(this, username, password, login, progressBar);
        }

        // night mode set.
        AppCompatDelegate.setDefaultNightMode(darkMode? AppCompatDelegate.MODE_NIGHT_YES : AppCompatDelegate.MODE_NIGHT_NO);

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