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
        
    }

}