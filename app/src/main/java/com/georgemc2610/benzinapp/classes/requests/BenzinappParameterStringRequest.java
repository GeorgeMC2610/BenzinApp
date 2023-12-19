package com.georgemc2610.benzinapp.classes.requests;

import androidx.annotation.Nullable;

import com.android.volley.Response;
import com.android.volley.toolbox.StringRequest;

import java.util.HashMap;
import java.util.Map;

public class BenzinappParameterStringRequest extends StringRequest
{
    private final String token;
    private final Map<String, String> params;

    public BenzinappParameterStringRequest(int method, String url, Response.Listener<String> listener, @Nullable Response.ErrorListener errorListener, String token, Map<String, String> params)
    {
        super(method, url, listener, errorListener);
        this.token = token;
        this.params = params;
    }

    @Override
    public Map<String, String> getHeaders()
    {
        Map<String, String> headers = new HashMap<>();
        headers.put("Authorization", "Bearer " + token);
        return headers;
    }

    @Override
    protected Map<String, String> getParams()
    {
        return params;
    }
}
