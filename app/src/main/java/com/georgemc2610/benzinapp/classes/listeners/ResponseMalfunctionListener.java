package com.georgemc2610.benzinapp.classes.listeners;

import android.view.LayoutInflater;
import android.widget.LinearLayout;

import com.android.volley.Response;

public class ResponseMalfunctionListener implements Response.Listener
{
    private final LinearLayout linearLayout;
    private final LayoutInflater inflater;

    public ResponseMalfunctionListener(LinearLayout linearLayout, LayoutInflater inflater)
    {
        this.linearLayout = linearLayout;
        this.inflater = inflater;
    }

    @Override
    public void onResponse(Object response)
    {

    }
}
