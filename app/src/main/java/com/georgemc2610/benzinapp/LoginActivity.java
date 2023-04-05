package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import com.android.volley.Response;
import com.android.volley.toolbox.StringRequest;
import com.georgemc2610.benzinapp.classes.RequestHandler;

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

        username = findViewById(R.id.editText_Username);
        password = findViewById(R.id.editText_Password);

        login = findViewById(R.id.buttonLogin);

        progressBar = findViewById(R.id.progressBar_Login);

        RequestHandler.Create();
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

        progressBar.setVisibility(View.VISIBLE);

        RequestHandler.getInstance().Login(this, username.getText().toString(), password.getText().toString(), progressBar);
    }

    public void OnTextViewRegisterClicked(View v)
    {
        Intent intent = new Intent(this, RegisterActivity.class);
        startActivity(intent);
        finish();
    }
}