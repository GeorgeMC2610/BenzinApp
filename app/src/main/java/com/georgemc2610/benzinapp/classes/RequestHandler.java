package com.georgemc2610.benzinapp.classes;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.georgemc2610.benzinapp.MainActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.SQLOutput;
import java.util.HashMap;
import java.util.Map;

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

    public void Login(Activity activity, String Username, String Password)
    {
        requestQueue = Volley.newRequestQueue(activity);

        String url = _URL + "/auth/login";

        StringRequest request = new StringRequest(Request.Method.POST, url, response ->
        {
            try
            {
                JSONObject jsonObject = new JSONObject(response);
                token = jsonObject.getString("auth_token");

                Intent intent = new Intent(activity, MainActivity.class);
                activity.startActivity(intent);
                activity.finish();
            }
            catch (JSONException e)
            {
                throw new RuntimeException(e);
            }
        }, error ->
        {
            if (error.networkResponse.statusCode == 401)
            {
                Toast.makeText(activity, "Invalid Username/Password.", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(activity, "Something else went wrong.", Toast.LENGTH_LONG).show();
            }
        })
        {

           @Override
           protected Map<String, String> getParams()
           {
               Map<String, String> params = new HashMap<>();

               params.put("username", Username);
               params.put("password", Password);

               return params;
           }

        };

        requestQueue.add(request);
    }

}
