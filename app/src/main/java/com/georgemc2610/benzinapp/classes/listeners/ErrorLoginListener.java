package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.cardview.widget.CardView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.georgemc2610.benzinapp.R;

public class ErrorLoginListener implements Response.ErrorListener
{
    private final Activity activity;
    private final ProgressBar progressBar;
    private final Button button;
    private final EditText username, password;

    public ErrorLoginListener(Activity activity, ProgressBar progressBar, Button button, EditText username, EditText password)
    {
        this.activity = activity;
        this.progressBar = progressBar;
        this.button = button;
        this.username = username;
        this.password = password;
    }

    @Override
    public void onErrorResponse(VolleyError error)
    {
        // if anything goes wrong, remove the progress bar and re-enable the views.
        username.setEnabled(true);
        password.setEnabled(true);
        button.setEnabled(true);
        progressBar.setVisibility(View.GONE);

        if (error.networkResponse == null)
            return;

        // and test for different failures.
        if (error.networkResponse.statusCode == 401)
        {
            Toast.makeText(activity, activity.getString(R.string.toast_invalid_credentials), Toast.LENGTH_LONG).show();
        }
        else if (error.networkResponse.statusCode == 422)
        {
            Toast.makeText(activity, activity.getString(R.string.toast_session_ended), Toast.LENGTH_LONG).show();
        }
        else
        {
            Toast.makeText(activity, "Something else went wrong. Please check the logs.", Toast.LENGTH_LONG).show();
        }
    }
}
