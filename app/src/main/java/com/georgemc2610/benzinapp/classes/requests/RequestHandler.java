package com.georgemc2610.benzinapp.classes.requests;

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
import com.georgemc2610.benzinapp.classes.listeners.ErrorLoginListener;
import com.georgemc2610.benzinapp.classes.listeners.ErrorRegisterListener;
import com.georgemc2610.benzinapp.classes.listeners.ErrorTokenRequiredListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetCarInfoListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetFuelFillRecordsListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetMalfunctionsListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetRepeatedTripsListener;
import com.georgemc2610.benzinapp.classes.listeners.ResponseGetServicesListener;
import com.georgemc2610.benzinapp.classes.original.FuelFillRecord;
import com.georgemc2610.benzinapp.classes.original.Malfunction;
import com.georgemc2610.benzinapp.classes.original.Service;

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

        // login parameters
        Map<String, String> params = new HashMap<>();
        params.put("username", Username);
        params.put("password", Password);

        // progress bar and buttons.
        UsernameEditText.setEnabled(false);
        PasswordEditText.setEnabled(false);
        LoginButton.setEnabled(false);
        progressBar.setVisibility(View.VISIBLE);

        // Login url.
        String url = _URL + "/auth/login";

        // the request. In the login Activity, we don't need listeners inside the of the Activity.
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.POST, url, response ->
        {
            // in case of successful response.
            try
            {
                // get the token and save it.
                JSONObject jsonObject = new JSONObject(response);
                token = jsonObject.getString("auth_token");
                SaveToken(activity);

                AssignData(activity, DataSelector.ALL);
            }
            catch (JSONException e)
            {
                throw new RuntimeException(e);
            }
        }, new ErrorLoginListener(activity, progressBar, LoginButton, UsernameEditText, PasswordEditText), GetToken(activity), params);

        // push the request.
        requestQueue.add(request);
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

        // attempt to get the car data.
        String url = _URL + "/car";

        // request that provides the previously stored jwt token.
        BenzinappStringRequest request = new BenzinappStringRequest(Request.Method.GET, url, response ->
        {
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
            AssignData(activity, DataSelector.ALL);
        }, new ErrorLoginListener(activity, progressBar, LoginButton, UsernameEditText, PasswordEditText), GetToken(activity));

        // push the request.
        requestQueue.add(request);
    }

    public void Signup(Activity activity, String username, String password, String passwordConfirmation, String carManufacturer, String model, int year, ProgressBar progressBar, Button button)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // set progress bar visibility to be visible.
        progressBar.setVisibility(View.VISIBLE);
        button.setEnabled(false);

        // parameters for a request
        Map<String, String> params = new HashMap<>();
        params.put("username", username);
        params.put("password", password);
        params.put("password_confirmation", passwordConfirmation);
        params.put("manufacturer", carManufacturer);
        params.put("model", model);
        params.put("year", String.valueOf(year));

        // Login url.
        String url = _URL + "/signup";

        // post request for the data.
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.POST, url, response ->
        {
            // in case of successful response.
            try
            {
                // get the token and save it.
                JSONObject jsonObject = new JSONObject(response);
                token = jsonObject.getString("auth_token");
                SaveToken(activity);

                AssignData(activity, DataSelector.ALL);
            }
            catch (JSONException e)
            {
                throw new RuntimeException(e);
            }
        }, new ErrorRegisterListener(activity, progressBar, button), GetToken(activity), params);

        // push the request.
        requestQueue.add(request);
    }

    private void AssignData(Activity activity, DataSelector selector)
    {
        // request Queue required to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // error listener for all urls.
        ErrorTokenRequiredListener errorTokenRequiredListener = new ErrorTokenRequiredListener(activity);

        // listeners for the requests.
        ResponseGetCarInfoListener         carInfoListener      = new ResponseGetCarInfoListener(activity);
        ResponseGetFuelFillRecordsListener recordsListener      = new ResponseGetFuelFillRecordsListener(activity);
        ResponseGetMalfunctionsListener    malfunctionsListener = new ResponseGetMalfunctionsListener(activity);
        ResponseGetServicesListener        servicesListener     = new ResponseGetServicesListener(activity);
        ResponseGetRepeatedTripsListener   tripsListener        = new ResponseGetRepeatedTripsListener(activity);

        // url and listeners for car.
        String car_url           = _URL + "/car";
        String record_url        = _URL + "/fuel_fill_record";
        String malfunction_url   = _URL + "/malfunction";
        String service_url       = _URL + "/service";
        String repeated_trip_url = _URL + "/repeated_trip";

        // the request. In the login Activity, we don't need listeners inside the of the Activity.
        BenzinappStringRequest requestCar = new BenzinappStringRequest(Request.Method.GET, car_url, carInfoListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestRecords = new BenzinappStringRequest(Request.Method.GET, record_url, recordsListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestMalfunctions = new BenzinappStringRequest(Request.Method.GET, malfunction_url, malfunctionsListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestServices = new BenzinappStringRequest(Request.Method.GET, service_url, servicesListener, errorTokenRequiredListener, GetToken(activity));
        BenzinappStringRequest requestRepeatedTrips = new BenzinappStringRequest(Request.Method.GET, repeated_trip_url, tripsListener, errorTokenRequiredListener, GetToken(activity));

        // push the requests.
        switch (selector)
        {
            case ALL:
                requestQueue.add(requestCar);
                requestQueue.add(requestRecords);
                requestQueue.add(requestMalfunctions);
                requestQueue.add(requestServices);
                requestQueue.add(requestRepeatedTrips);
                break;
            case FUEL_FILL_RECORDS:
                requestQueue.add(requestRecords);
                break;
            case MALFUNCTIONS:
                requestQueue.add(requestMalfunctions);
                break;
            case SERVICES:
                requestQueue.add(requestServices);
                break;
            case REPEATED_TRIPS:
                requestQueue.add(requestRepeatedTrips);
                break;
        }
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

        DataHolder.getInstance().car = null;
        DataHolder.getInstance().records = null;
        DataHolder.getInstance().malfunctions = null;
        DataHolder.getInstance().services = null;

        token = "";
        SaveToken(activity);
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


    public void AddFuelFillRecord(Activity activity, float km, float lt, float cost_eur, String fuelType, String station, LocalDate filledAt, String notes)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // parameters of a fuel fill record.
        Map<String, String> params = new HashMap<>();
        params.put("km", String.valueOf(km));
        params.put("lt", String.valueOf(lt));
        params.put("cost_eur", String.valueOf(cost_eur));
        params.put("fuel_type", fuelType);
        params.put("station", station);
        params.put("filled_at", filledAt.toString());
        params.put("notes", notes);

        // correct url
        String url = _URL + "/fuel_fill_record";

        // POST request to add fuel fill record
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.POST, url, listener ->
        {
            // listener for when the data have been posted successfully.
            // no need to close the activity, because `AssignData` will refresh the data and will close it whenever they are ready.
            AssignData(activity, DataSelector.FUEL_FILL_RECORDS);
            Toast.makeText(activity, activity.getString(R.string.toast_record_added), Toast.LENGTH_SHORT).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute the request.
        requestQueue.add(request);
    }

    public void EditFuelFillRecord(Activity activity, FuelFillRecord record)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/fuel_fill_record/" + record.getId();

        // create values map
        Map<String, String> params = new HashMap<>();
        params.put("km", String.valueOf(record.getKilometers()));
        params.put("lt", String.valueOf(record.getLiters()));
        params.put("cost_eur", String.valueOf(record.getCost_eur()));
        params.put("fuel_type", record.getFuelType());
        params.put("station", record.getStation());
        params.put("notes", record.getNotes());
        params.put("filled_at", record.getDate().toString());

        // PATCH request to edit fuel fill record
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.PATCH, url, listener ->
        {
            // listener for when the data have been posted successfully.
            // no need to close the activity, because `AssignData` will refresh the data and will close it whenever they are ready.
            AssignData(activity, DataSelector.FUEL_FILL_RECORDS);
            Toast.makeText(activity, activity.getString(R.string.toast_record_edited), Toast.LENGTH_SHORT).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute the request.
        requestQueue.add(request);
    }


    public void DeleteFuelFillRecord(Activity activity, int id)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/fuel_fill_record/" + id;

        BenzinappStringRequest request = new BenzinappStringRequest(Request.Method.DELETE, url, listener ->
        {
            AssignData(activity, DataSelector.FUEL_FILL_RECORDS);
        }, new ErrorTokenRequiredListener(activity), GetToken(activity));

        requestQueue.add(request);
    }

    public void AddService(Activity activity, String at_km, String cost_eur, String description, String location, String date_happened, String next_km)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // parameters for a service
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

        // services url.
        String url = _URL + "/service";

        // POST request to add service
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.POST, url, listener ->
        {
            // listener for when the data have been posted successfully.
            // no need to close the activity, because `AssignData` will refresh the data and will close it whenever they are ready.
            AssignData(activity, DataSelector.SERVICES);
            Toast.makeText(activity, activity.getString(R.string.toast_record_added), Toast.LENGTH_SHORT).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute request.
        requestQueue.add(request);
    }

    public void DeleteService(Activity activity, int id)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/service/" + id;

        // benzinapp delete request to the services
        BenzinappStringRequest request = new BenzinappStringRequest(Request.Method.DELETE, url, listener ->
        {
            AssignData(activity, DataSelector.SERVICES);
            Toast.makeText(activity, activity.getString(R.string.toast_record_deleted), Toast.LENGTH_LONG).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity));

        // add the request.
        requestQueue.add(request);
    }

    public void EditService(Activity activity, Service service)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // service parameters
        Map<String, String> params = new HashMap<>();

        // for every parameter, check for its integrity. If there is none, then don't add it to the parameters.
        params.put("at_km", String.valueOf(service.getAtKm()));
        params.put("description", service.getDescription());
        params.put("date_happened", service.getDateHappened().toString());
        params.put("next_km", String.valueOf(service.getNextKm()));
        params.put("cost_eur", String.valueOf(service.getCost()));

        // optional value requires integrity check
        if (service.getLocation() == null)
            params.put("location", "");
        else
            params.put("location", service.getLocation());

        // correct url
        String url = _URL + "/service/" + service.getId();

        // PATCH request to add fuel fill record
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.PATCH, url, listener ->
        {
            AssignData(activity, DataSelector.SERVICES);
            Toast.makeText(activity, activity.getString(R.string.toast_record_edited), Toast.LENGTH_LONG).show();

        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute the request.
        requestQueue.add(request);
    }

    public void AddMalfunction(Activity activity, String at_km, String title, String description, String started)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // parameters of a malfunction
        Map<String, String> params = new HashMap<>();
        params.put("at_km", at_km);
        params.put("title", title);
        params.put("description", description);
        params.put("started", started);

        // correct URL
        String url = _URL + "/malfunction";

        // POST request to add malfunctions
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.POST, url, listener ->
        {
            // listener for when the data have been posted successfully.
            // no need to close the activity, because `AssignData` will refresh the data and will close it whenever they are ready.
            AssignData(activity, DataSelector.MALFUNCTIONS);
            Toast.makeText(activity, activity.getString(R.string.toast_record_added), Toast.LENGTH_SHORT).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute the request.
        requestQueue.add(request);
    }

    public void DeleteMalfunction(Activity activity, int id)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // correct url
        String url = _URL + "/malfunction/" + id;

        BenzinappStringRequest request = new BenzinappStringRequest(Request.Method.DELETE, url, listener ->
        {
            AssignData(activity, DataSelector.MALFUNCTIONS);
            Toast.makeText(activity, activity.getString(R.string.toast_record_deleted), Toast.LENGTH_LONG).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity));

        requestQueue.add(request);
    }

    public void EditMalfunction(Activity activity, Malfunction malfunction)
    {
        // request queue to push the request
        requestQueue = Volley.newRequestQueue(activity);

        // required parameters of a malfunction.
        Map<String, String> params = new HashMap<>();
        params.put("title", malfunction.getTitle());
        params.put("description", malfunction.getDescription());
        params.put("started", malfunction.getStarted().toString());
        params.put("at_km", String.valueOf(malfunction.getAt_km()));

        // optional parameters require an integrity check.
        if (malfunction.getCost() == -1f)
            params.put("cost_eur", "");
        else
            params.put("cost_eur", String.valueOf(malfunction.getCost()));

        if (malfunction.getEnded() == null)
            params.put("ended", "");
        else
            params.put("ended", malfunction.getEnded().toString());

        if (malfunction.getLocation() == null || malfunction.getLocation().isEmpty())
            params.put("location", "");
        else
            params.put("location", malfunction.getLocation());

        // correct url
        String url = _URL + "/malfunction/" + malfunction.getId();

        // PATCH request to edit malfunction
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.PATCH, url, listener ->
        {
            AssignData(activity, DataSelector.MALFUNCTIONS);
            Toast.makeText(activity, activity.getString(R.string.toast_record_edited), Toast.LENGTH_LONG).show();
        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute the request.
        requestQueue.add(request);
    }

    public void AddRepeatedTrip(Activity activity, String title, String origin, String destination, int timesRepeating, float totalKm)
    {
        // request Queue required, to send the request.
        requestQueue = Volley.newRequestQueue(activity);

        // parameters of a repeated trip. All parameters are required.
        Map<String, String> params = new HashMap<>();
        params.put("title", title);
        params.put("origin", origin);
        params.put("destination", destination);
        params.put("times_repeating", String.valueOf(timesRepeating));
        params.put("total_km", String.valueOf(totalKm));

        // correct url
        String url = _URL + "/repeated_trip";

        // POST request to add repeated trip
        BenzinappParameterStringRequest request = new BenzinappParameterStringRequest(Request.Method.POST, url, listener ->
        {
            AssignData(activity, DataSelector.REPEATED_TRIPS);
            Toast.makeText(activity, "New Repeated Trip added successfully.", Toast.LENGTH_LONG).show(); // TODO: remove hardcoded string.
        }, new ErrorTokenRequiredListener(activity), GetToken(activity), params);

        // execute request.
        requestQueue.add(request);
    }
}
