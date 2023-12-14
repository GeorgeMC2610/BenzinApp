package com.georgemc2610.benzinapp.classes;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.georgemc2610.benzinapp.LoginActivity;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.classes.listeners.ErrorTokenRequiredListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetCarInfoListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetFuelFillRecordsListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetMalfunctionsListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetServicesListener;

import org.json.JSONException;
import org.json.JSONObject;

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
    public void Login(Activity activity, String Username, String Password, EditText UsernameEditText, EditText PasswordEditText, Button LoginButton, ProgressBar progressBar)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // progress bar and buttons.
        UsernameEditText.setEnabled(false);
        PasswordEditText.setEnabled(false);
        LoginButton.setEnabled(false);
        progressBar.setVisibility(View.VISIBLE);

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
                SaveToken(activity);

                AssignData(activity);

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
            // if anything goes wrong, remove the progress bar and re-enable the views.
            UsernameEditText.setEnabled(true);
            PasswordEditText.setEnabled(true);
            LoginButton.setEnabled(true);
            progressBar.setVisibility(View.GONE);

            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 401)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_invalid_credentials), Toast.LENGTH_LONG).show();
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

    private void AssignData(Activity activity)
    {
        // request Queue required to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // error listener for all urls.
        ErrorTokenRequiredListener errorTokenRequiredListener = new ErrorTokenRequiredListener(activity);

        // listeners for the requests.
        ResponseGetCarInfoListener carInfoListener = new ResponseGetCarInfoListener(activity);
        ResponseGetFuelFillRecordsListener recordsListener = new ResponseGetFuelFillRecordsListener(activity);
        ResponseGetMalfunctionsListener malfunctionsListener = new ResponseGetMalfunctionsListener(activity);
        ResponseGetServicesListener servicesListener = new ResponseGetServicesListener(activity);

        // url and listeners for car.
        String car_url = _URL + "/car";
        String record_url = _URL + "/fuel_fill_record";
        String malfunction_url = _URL + "/malfunction";
        String service_url = _URL + "/service";

        // the request. In the login Activity, we don't need listeners inside the of the Activity.
        BenzinappStringRequest requestCar = new BenzinappStringRequest(Request.Method.GET, car_url, carInfoListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestRecords = new BenzinappStringRequest(Request.Method.GET, record_url, recordsListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestMalfunctions = new BenzinappStringRequest(Request.Method.GET, malfunction_url, malfunctionsListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestServices = new BenzinappStringRequest(Request.Method.GET, service_url, servicesListener, errorTokenRequiredListener, GetToken(activity));

        // push the requests.
        requestQueue.add(requestCar);
        requestQueue.add(requestRecords);
        requestQueue.add(requestMalfunctions);
        requestQueue.add(requestServices);
    }

    /**
     * Sends a request to <code>/car</code> with the previously used token (that is saved in Shared Preferences).
     * If the request succeeds, the user gets logged in and the Activity continues.
     * If the request fails, it lets the user provide their credentials.
     * @param activity Activity required to send a Volley request.
     * @param UsernameEditText View that gets disabled and re-enabled once the request is processed.
     * @param PasswordEditText View that gets disabled and re-enabled once the request is processed.
     * @param LoginButton View that gets disabled and re-enabled once the request is processed.
     * @param progressBar Progress Bar that keeps turning until the request is processed.
     */
    public void AttemptLogin(Activity activity, EditText UsernameEditText, EditText PasswordEditText, Button LoginButton, ProgressBar progressBar)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // progress bar and buttons.
        UsernameEditText.setEnabled(false);
        PasswordEditText.setEnabled(false);
        LoginButton.setEnabled(false);
        progressBar.setVisibility(View.VISIBLE);

        // Login url.
        String url = _URL + "/car";

        // the request. In the login Activity, we don't need listeners inside the of the Activity.
        StringRequest request = new StringRequest(Request.Method.GET, url, response ->
        {
            // FIRST TRY HEHE.
            // show the logged in username whenever auto-login works.
            String previousUser = "[as the previous user]";

            try
            {
                JSONObject jsonObject = new JSONObject(response);
                previousUser = jsonObject.getString("username");
            }
            catch (JSONException e)
            {
                System.out.println("Could not process response: \n" + e.getMessage());
            }

            // toast to let the user know that they were logged on.
            Toast.makeText(activity, activity.getString(R.string.toast_logged_in_as) + previousUser, Toast.LENGTH_LONG).show();

            // start the activity if the login was successful.
            Intent intent = new Intent(activity, MainActivity.class);
            activity.startActivity(intent);
            activity.finish();
        }, error ->
        {
            // if anything goes wrong, disable the progress bar
            UsernameEditText.setEnabled(true);
            PasswordEditText.setEnabled(true);
            LoginButton.setEnabled(true);
            progressBar.setVisibility(View.GONE);


            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 401 || error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_session_ended), Toast.LENGTH_LONG).show();
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
                headers.put("Authorization", "Bearer " + GetToken(activity));
                return headers;
            }
        };

        // push the request.
        requestQueue.add(request);
    }

    /**
     * Logs the user out and redirects them to the Login Activity.
     * @param activity Activity required to start the Login Activity.
     */
    public void Logout(Activity activity)
    {
        Intent intent = new Intent(activity, LoginActivity.class);
        activity.startActivity(intent);
        activity.finish();
        token = "";
        SaveToken(activity);
    }


    public void Signup(Activity activity, String username, String password, String passwordConfirmation, String carManufacturer, String model, int year, ProgressBar progressBar)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // set progress bar visibility to be visible.
        progressBar.setVisibility(View.VISIBLE);

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
                SaveToken(activity);

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
                Toast.makeText(activity, activity.getString(R.string.toast_username_already_taken), Toast.LENGTH_LONG).show();
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

    /**
     * Using shared preferences, saves the token with PRIVATE mode enabled.
     * @param context Context refers to the Shared Preferences object.
     */
    private void SaveToken(Context context)
    {
        SharedPreferences sharedPreferences = context.getSharedPreferences("token", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString("current", token);
        editor.apply();
    }

    /**
     * Using shared preferences, retrieves the token with PRIVATE mode enabled.
     * @param context Context refers to the Shared Preferences object.
     * @return The JWT Token that logs the user in.
     */
    private String GetToken(Context context)
    {
        SharedPreferences sharedPreferences = context.getSharedPreferences("token", Context.MODE_PRIVATE);
        token = sharedPreferences.getString("current", "");
        return token;
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
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

    public void EditFuelFillRecord(Activity activity, Response.Listener<String> listener, int id, Float km, Float lt, Float cost_eur, String fuelType, String station, LocalDate newDate, String notes)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/fuel_fill_record/" + id;

        // PATCH request to add fuel fill record
        StringRequest request = new StringRequest(Request.Method.PATCH, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 401)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_session_ended), Toast.LENGTH_LONG).show();
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

                // for every parameter, check for its integrity. If there is none, then don't add it to the parameters.
                if (km != null)
                    params.put("km", String.valueOf(km));

                if (lt != null)
                    params.put("lt", String.valueOf(lt));

                if (cost_eur != null)
                    params.put("cost_eur", String.valueOf(cost_eur));

                if (fuelType != null)
                    params.put("fuel_type", fuelType);

                if (station != null && !station.isEmpty())
                    params.put("station", station);

                if (newDate != null && !newDate.toString().isEmpty())
                    params.put("filled_at", newDate.toString());

                if (notes != null && !notes.isEmpty())
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
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

    public void GetServices(Activity activity, Response.Listener<String> listener)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // fuel fill records url. This will return all services of the User.
        String url = _URL + "/service";

        StringRequest request = new StringRequest(Request.Method.GET, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

    public void GetMalfunctions(Activity activity, Response.Listener<String> listener)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // fuel fill records url. This will return all services of the User.
        String url = _URL + "/malfunction";

        StringRequest request = new StringRequest(Request.Method.GET, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

    public void AddService(Activity activity, Response.Listener<String> listener, String at_km, String cost_eur, String description, String location, String date_happened, String next_km)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // services url.
        String url = _URL + "/service";

        StringRequest request = new StringRequest(Request.Method.POST, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

                // required data don't need integrity check
                params.put("at_km", at_km);
                params.put("description", description);
                params.put("date_happened", date_happened);

                // optional data need integrity check
                if (cost_eur != null && !cost_eur.isEmpty())
                    params.put("cost_eur", cost_eur);

                if (next_km != null && !next_km.isEmpty())
                    params.put("next_km", next_km);

                if (location != null && !location.isEmpty())
                    params.put("location", location);

                return params;
            }
        };

        requestQueue.add(request);
    }

    public void DeleteService(Activity activity, int id)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/service/" + id;

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
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

    public void AddMalfunction(Activity activity, Response.Listener<String> listener, String at_km, String title, String description, String date_happened)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // malfunctions url.
        String url = _URL + "/malfunction";

        StringRequest request = new StringRequest(Request.Method.POST, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 422)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

            // this adds parameters to the request.
            @Override
            protected Map<String, String> getParams()
            {
                Map<String, String> params = new HashMap<>();

                // required parameters don't need integrity check
                params.put("at_km", at_km);
                params.put("title", title);
                params.put("description", description);
                params.put("started", date_happened);

                return params;
            }
        };

        requestQueue.add(request);
    }

    public void DeleteMalfunction(Activity activity, int id)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/malfunction/" + id;

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
                Toast.makeText(activity, activity.getString(R.string.toast_unexpected_error), Toast.LENGTH_LONG).show();
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

    public void EditMalfunction(Activity activity, Response.Listener<String> listener, Malfunction malfunction)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/malfunction/" + malfunction.getId();

        // PATCH request to add fuel fill record
        StringRequest request = new StringRequest(Request.Method.PATCH, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 401)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_session_ended), Toast.LENGTH_LONG).show();
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

                // for every parameter, check for its integrity. If there is none, then don't add it to the parameters.
                if (malfunction.getTitle() != null)
                    params.put("title", malfunction.getTitle());

                if (malfunction.getDescription() != null)
                    params.put("description", malfunction.getDescription());

                if (malfunction.getStarted() != null)
                    params.put("started", malfunction.getStarted().toString());

                if (malfunction.getAt_km() != 0)
                    params.put("at_km", String.valueOf(malfunction.getAt_km()));

                if (malfunction.getCost() != 0f)
                    params.put("cost_eur", String.valueOf(malfunction.getCost()));
                else
                    params.put("cost_eur", "null");

                if (malfunction.getEnded() != null)
                    params.put("ended", malfunction.getEnded().toString());
                else
                    params.put("ended", "null");

                return params;
            }
        };

        // execute the request.
        requestQueue.add(request);
    }

    public void EditService(Activity activity, Response.Listener<String> listener, Service service)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/service/" + service.getId();

        // PATCH request to add fuel fill record
        StringRequest request = new StringRequest(Request.Method.PATCH, url, listener, error ->
        {
            if (error.networkResponse == null)
                return;

            // and test for different failures.
            if (error.networkResponse.statusCode == 401)
            {
                Toast.makeText(activity, activity.getString(R.string.toast_session_ended), Toast.LENGTH_LONG).show();
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

                // for every parameter, check for its integrity. If there is none, then don't add it to the parameters.
                if (service.getAtKm() != 0)
                    params.put("at_km", String.valueOf(service.getAtKm()));

                if (service.getDescription() != null)
                    params.put("description", service.getDescription());

                if (service.getDateHappened() != null)
                    params.put("date_happened", service.getDateHappened().toString());

                // nullify data if there aren't any.
                if (service.getNextKm() != 0)
                    params.put("next_km", String.valueOf(service.getNextKm()));
                else
                    params.put("next_km", "null");

                if (service.getCost() != 0f)
                    params.put("cost_eur", String.valueOf(service.getCost()));
                else
                    params.put("cost_eur", "null");

                return params;
            }
        };

        // execute the request.
        requestQueue.add(request);
    }
}
