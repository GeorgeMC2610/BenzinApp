package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

public class RegisterActivity extends AppCompatActivity
{
    EditText username, password, passwordConfirmation, manufacturer, model, year;

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
    }

    public void OnTextViewLoginClicked(View v)
    {
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
        finish();
    }
}