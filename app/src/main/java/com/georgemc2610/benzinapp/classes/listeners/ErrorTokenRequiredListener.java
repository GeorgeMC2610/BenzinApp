package com.georgemc2610.benzinapp.classes.listeners;

import android.app.Activity;
import android.widget.Toast;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.georgemc2610.benzinapp.R;

public class ErrorTokenRequiredListener implements Response.ErrorListener
{
    private final Activity activity;

    public ErrorTokenRequiredListener(Activity activity)
    {
        this.activity = activity;
    }

    @Override
    public void onErrorResponse(VolleyError error)
    {
        if (error.networkResponse == null)
            return;

        // and test for different failures.
        if (error.networkResponse.statusCode == 422)
        {
            Toast.makeText(activity, activity.getString(R.string.toast_session_ended), Toast.LENGTH_LONG).show();
        }
        else
        {
            Toast.makeText(activity, "Something else went wrong.", Toast.LENGTH_LONG).show();
        }
    }
}
