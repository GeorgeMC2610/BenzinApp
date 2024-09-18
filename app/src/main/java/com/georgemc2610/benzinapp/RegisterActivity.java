package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

public class RegisterActivity extends AppCompatActivity
{
    EditText username, password, passwordConfirmation, manufacturer, model, year;
    Button button;
    ProgressBar progressBar;
    TextView loginText;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        // initialize values
        username = findViewById(R.id.editText_Username);
        password = findViewById(R.id.editText_Password);
        passwordConfirmation = findViewById(R.id.editText_PasswordConfirmation);
        manufacturer = findViewById(R.id.editText_CarManufacturer);
        model = findViewById(R.id.editText_CarModel);
        year = findViewById(R.id.editText_Year);
        loginText = findViewById(R.id.textView_RegisterIfNoAccount);

        progressBar = findViewById(R.id.progressBar_Register);
        button = findViewById(R.id.buttonRegister);

        button.setOnClickListener(this::onButtonRegisterPressed);
        loginText.setOnClickListener(this::onTextViewLoginClicked);
    }

    public void onTextViewLoginClicked(View v)
    {
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
        finish();
    }

    public void onButtonRegisterPressed(View v)
    {
        if (!ViewTools.setErrors(this, username, password, passwordConfirmation, model, manufacturer, year))
        {
            return;
        }

        boolean canContinue = true;

        // -- CARS DIDN'T EXIST BACK THEN -- //
        if (!ViewTools.isEditTextEmpty(year) && Integer.parseInt(year.getText().toString().trim()) < 1886)
        {
            canContinue = false;
            year.setError(getString(R.string.error_cars_didnt_exist));
        }

        // -- PASSWORD CONFIRMATION WRONG -- //
        if (!passwordConfirmation.getText().toString().equals(password.getText().toString()))
        {
            canContinue = false;
            passwordConfirmation.setError(getString(R.string.error_password_confirmation_wrong));
        }

        if (!canContinue)
            return;

        // set progress bar on
        progressBar.setVisibility(View.VISIBLE);

        // values
        String carManufacturer = ViewTools.getFilteredViewSequence(manufacturer);
        String carModel = ViewTools.getFilteredViewSequence(model);
        int carYear = Integer.parseInt(ViewTools.getFilteredViewSequence(year));
        String Username = ViewTools.getFilteredViewSequence(username);
        String Password = ViewTools.getFilteredViewSequence(password);
        String PasswordConfirmation = ViewTools.getFilteredViewSequence(passwordConfirmation);

        // signup
        RequestHandler.getInstance().Signup(this, Username, Password, PasswordConfirmation, carManufacturer, carModel, carYear, progressBar, button);
    }
}