package com.georgemc2610.benzinapp.classes.requests;

import androidx.annotation.Nullable;

import com.android.volley.AuthFailureError;
import com.android.volley.Response;
import com.android.volley.toolbox.StringRequest;

import java.util.HashMap;
import java.util.Map;

public class BenzinappStringRequest extends StringRequest
{
    private final String token;

    public BenzinappStringRequest(int method, String url, Response.Listener<String> listener, @Nullable Response.ErrorListener errorListener, String token)
    {
        super(method, url, listener, errorListener);
        this.token = token;
    }

    @Override
    public Map<String, String> getHeaders()
    {
        Map<String, String> headers = new HashMap<>();
        headers.put("Authorization", "Bearer " + token);
        return headers;
    }
}
