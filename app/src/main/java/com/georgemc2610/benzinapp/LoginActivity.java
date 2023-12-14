package com.georgemc2610.benzinapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import com.georgemc2610.benzinapp.classes.requests.DataHolder;
import com.georgemc2610.benzinapp.classes.requests.RequestHandler;

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
        login = findViewById(R.id.buttonLogin);

        // progress bar for pressing the login button.
        progressBar = findViewById(R.id.progressBar_Login);

        // request handler singleton instance creation.
        RequestHandler.Create();
        DataHolder.Create();

        // attempt to auto-login.
        progressBar.setVisibility(View.VISIBLE);
        RequestHandler.getInstance().AttemptLogin(this, username, password, login, progressBar);
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