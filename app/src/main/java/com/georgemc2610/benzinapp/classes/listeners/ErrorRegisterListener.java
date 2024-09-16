package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.cardview.widget.CardView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.georgemc2610.benzinapp.R;

public class ErrorRegisterListener implements Response.ErrorListener
{
    private final Activity activity;
    private final ProgressBar progressBar;
    private final Button button;

    public ErrorRegisterListener(Activity activity, ProgressBar progressBar, Button button)
    {
        this.activity = activity;
        this.progressBar = progressBar;
        this.button = button;
    }

    @Override
    public void onErrorResponse(VolleyError error)
    {
        progressBar.setVisibility(View.GONE);
        button.setEnabled(true);

        if (error.networkResponse == null)
            return;

        // and test for different failures.
        if (error.networkResponse.statusCode == 422)
        {
            Toast.makeText(activity, activity.getString(R.string.toast_username_already_taken), Toast.LENGTH_LONG).show();
        }
        else
        {
            System.out.println(error.getMessage());
            Toast.makeText(activity, "Something else went wrong.", Toast.LENGTH_LONG).show();
        }
    }
}
