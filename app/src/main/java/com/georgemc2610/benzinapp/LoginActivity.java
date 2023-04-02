package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class LoginActivity extends AppCompatActivity
{

    EditText username, password;
    Button login;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        username = findViewById(R.id.editText_Username);
        password = findViewById(R.id.editText_Password);

        login = findViewById(R.id.buttonLogin);
    }

    public void OnButtonLoginPressed(View v)
    {
        boolean canMoveOn = true;

        // check for empty edit texts and
        if (username.getText().toString().trim().length() == 0)
        {
            username.setError(getString(R.string.error_field_cannot_be_empty));
            canMoveOn = false;
        }

        if (password.getText().toString().trim().length() == 0)
        {
            password.setError(getString(R.string.error_field_cannot_be_empty));
            canMoveOn = false;
        }

        if (!canMoveOn) return;
    }
}