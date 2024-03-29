package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import com.georgemc2610.benzinapp.classes.activity_tools.ViewTools;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

public class RegisterActivity extends AppCompatActivity
{
    EditText username, password, passwordConfirmation, manufacturer, model, year;
    Button button;
    ProgressBar progressBar;

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

        progressBar = findViewById(R.id.progressBar_register);
        button = findViewById(R.id.buttonRegister);
    }

    public void OnTextViewLoginClicked(View v)
    {
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
        finish();
    }

    public void OnButtonRegisterPressed(View v)
    {
        boolean canContinue = true;

        // --- FIELDS EMPTY --- //
        if (username.getText().toString().trim().length() == 0)
        {
            canContinue = false;
            username.setError(getString(R.string.error_field_cannot_be_empty));
        }

        if (password.getText().toString().length() == 0)
        {
            canContinue = false;
            password.setError(getString(R.string.error_field_cannot_be_empty));
        }

        if (passwordConfirmation.getText().toString().length() == 0)
        {
            canContinue = false;
            passwordConfirmation.setError(getString(R.string.error_field_cannot_be_empty));
        }

        if (manufacturer.getText().toString().trim().length() == 0)
        {
            canContinue = false;
            manufacturer.setError(getString(R.string.error_field_cannot_be_empty));
        }

        if (model.getText().toString().trim().length() == 0)
        {
            canContinue = false;
            model.setError(getString(R.string.error_field_cannot_be_empty));
        }

        if (year.getText().toString().trim().length() == 0)
        {
            canContinue = false;
            year.setError(getString(R.string.error_field_cannot_be_empty));
        }

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
        String carManufacturer = manufacturer.getText().toString().trim();
        String carModel = model.getText().toString().trim();
        int carYear = Integer.parseInt(year.getText().toString());
        String Username = username.getText().toString().trim();
        String Password = password.getText().toString().trim();
        String PasswordConfirmation = passwordConfirmation.getText().toString().trim();

        // signup
        RequestHandler.getInstance().Signup(this, Username, Password, PasswordConfirmation, carManufacturer, carModel, carYear, progressBar, button);
    }
}