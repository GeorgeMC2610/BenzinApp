package com.georgemc2610.benzinapp.classes;

import android.content.Context;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

public class RequestHandler
{
    private static RequestHandler instance;
    private static final String _URL = "http://192.168.1.86:3000";


    private String token;
    private RequestQueue requestQueue;

    private RequestHandler()
    {
    }

    public static RequestHandler getInstance() { return instance; }

    public static void Create()
    {
        instance = new RequestHandler();
    }

    public void Login(Context context, String Username, String Password)
    {
        requestQueue = Volley.newRequestQueue(context);

        String url = _URL + "/auth/login";

        StringRequest request = new StringRequest(Request.Method.POST, url, response -> {}, error -> {})
        {
          

        };
    }

}
