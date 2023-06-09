package com.georgemc2610.benzinapp.classes;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Debug;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.georgemc2610.benzinapp.ActivityDisplayData;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.SQLOutput;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class RequestHandler
{
    private static RequestHandler instance;
    private static final String _URL = "https://benzin-app.fly.dev";


    private String token;
    private RequestQueue requestQueue;

    private RequestHandler()
    {
        token = "";
    }

    public static RequestHandler getInstance() { return instance; }

    public static void Create()
    {
        instance = new RequestHandler();
    }

    /**
     * Authenticates the user. If the user inputs correctly the Username and Password fields,
     * <b> a bearer token is then saved and used for authentication for all the other actions.</b>
     * If the user fails to login, the user can try again.
     *
     * @param activity Context required in order to display Toast Messages.
     * @param Username Provided Username.
     * @param Password Provided Password.
     * @param progressBar A Progress Bar for decoration.
     */
    public void Login(Activity activity, String Username, String Password, ProgressBar progressBar)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // Login url.
        String url = _URL + "/auth/login";

        // the request. In the login Activity, we don't need listeners inside the of the Activity.
        StringRequest request = new StringRequest(Request.Method.POST, url, response ->
        {
            // in case of successful response.
            try
            {
                // get the token and save it.
                JSONObject jsonObject = new JSONObject(response);
                token = jsonObject.getString("auth_token");

                // then start the other activity.
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
            // if anything goes wrong, disable the progress bar
            progressBar.setVisibility(View.GONE);

            if (error.networkResponse == null)
                return;

            // and test for different failures.
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
            // put the parameters as they are provided.
           @Override
           protected Map<String, String> getParams()
           {
               Map<String, String> params = new HashMap<>();

               params.put("username", Username);
               params.put("password", Password);

               return params;
           }
        };

        // push the request.
        requestQueue.add(request);
    }


    public void Signup(Activity activity, String username, String password, String passwordConfirmation, String carManufacturer, String model, int year, ProgressBar progressBar)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // Login url.
        String url = _URL + "/signup";

        // the request. In the login Activity, we don't need listeners inside the of the Activity.
        StringRequest request = new StringRequest(Request.Method.POST, url, response ->
        {
            // in case of successful response.
            try
            {
                // get the token and save it.
                JSONObject jsonObject = new JSONObject(response);
                token = jsonObject.getString("auth_token");

                // then start the other activity.
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
            // if anything goes wrong, disable the progress bar
            progressBar.setVisibility(View.GONE);

            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, "Username has already been taken.", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(activity, "Something else went wrong.", Toast.LENGTH_LONG).show();
            }
        })
        {
            // put the parameters as they are provided.
            @Override
            protected Map<String, String> getParams()
            {
                Map<String, String> params = new HashMap<>();

                params.put("username", username);
                params.put("password", password);
                params.put("password_confirmation", passwordConfirmation);
                params.put("manufacturer", carManufacturer);
                params.put("model", model);
                params.put("year", String.valueOf(year));

                return params;
            }
        };

        // push the request.
        requestQueue.add(request);
    }


    public void GetCarInfo(Activity activity, Response.Listener<String> listener)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // fuel fill records url. This will return all fuel_fill_records of the User.
        String url = _URL + "/car";

        StringRequest request = new StringRequest(Request.Method.GET, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, "Something went wrong.", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(activity, "Something else went wrong.", Toast.LENGTH_LONG).show();
            }
        })
        {
            // this authenticates the user using his token.
            @Override
            public Map<String, String> getHeaders()
            {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", "Bearer " + token);
                return headers;
            }
        };

        requestQueue.add(request);
    }


    public void GetFuelFillRecords(Activity activity, Response.Listener<String> listener)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // fuel fill records url. This will return all fuel_fill_records of the User.
        String url = _URL + "/fuel_fill_record";

        StringRequest request = new StringRequest(Request.Method.GET, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, "An unexpected error occurred", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(activity, "Something else went wrong.", Toast.LENGTH_LONG).show();
            }
        })
        {
            // this authenticates the user using his token.
            @Override
            public Map<String, String> getHeaders()
            {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", "Bearer " + token);
                return headers;
            }
        };

        requestQueue.add(request);
    }

    public void AddFuelFillRecord(Activity activity, Response.Listener<String> listener, float km, float lt, float cost_eur, String fuelType, String station, LocalDate filledAt, String notes)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/fuel_fill_record";

        // POST request to add fuel fill record
        StringRequest request = new StringRequest(Request.Method.POST, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
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
            // this authenticates the user using his token.
            @Override
            public Map<String, String> getHeaders()
            {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", "Bearer " + token);
                return headers;
            }

            // put the parameters as they are provided.
            @Override
            protected Map<String, String> getParams()
            {
                Map<String, String> params = new HashMap<>();

                params.put("km", String.valueOf(km));
                params.put("lt", String.valueOf(lt));
                params.put("cost_eur", String.valueOf(cost_eur));
                params.put("fuel_type", fuelType);
                params.put("station", station);
                params.put("filled_at", filledAt.toString());
                params.put("notes", notes);

                return params;
            }
        };

        // execute the request.
        requestQueue.add(request);
    }


    public void DeleteFuelFillRecord(Activity activity, int id)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/fuel_fill_record/" + id;

        StringRequest request = new StringRequest(Request.Method.DELETE, url, response ->
        {
            Toast.makeText(activity, activity.getString(R.string.toast_record_deleted), Toast.LENGTH_LONG).show();

        }, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
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
            // this authenticates the user using his token.
            @Override
            public Map<String, String> getHeaders()
            {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", "Bearer " + token);
                return headers;
            }
        };

        requestQueue.add(request);
    }
}
