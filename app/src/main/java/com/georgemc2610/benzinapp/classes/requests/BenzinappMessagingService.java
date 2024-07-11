package com.georgemc2610.benzinapp.classes.requests;

import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.georgemc2610.benzinapp.LoginActivity;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.R;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class BenzinappMessagingService extends FirebaseMessagingService
{
    public static void HandleAlreadyExistingToken(Context context)
    {
        FirebaseMessaging.getInstance().getToken().addOnCompleteListener(task ->
        {
            // log the errors if there are any.
            if (!task.isSuccessful())
            {
                Log.e("FIREBASE MESSAGING", "Did not get FCM token.");

                if (task.getResult() != null)
                    Log.e("FIREBASE MESSAGING", "Result: " + task.getResult());

                if (task.getException() != null)
                    Log.e("FIREBASE MESSAGING", "Exception: " + task.getException().getMessage());

                return;
            }

            // if the token is successfully retrieved log it
            Log.d("MESSAGING", "Got token: " + task.getResult());
            SharedPreferences preferences = context.getSharedPreferences("settings", MODE_PRIVATE);

            if (!preferences.getBoolean("notifications", false))
                return;

            String token = task.getResult();
            String oldValue = preferences.getString("fcm token", "");

            if (oldValue.equals(token))
            {
                // request handler will check the validity of the token.
                Log.d("MESSAGING", "There is already an FCM token locally.");
            }
            else if (oldValue.equals(""))
            {
                // request handler will replace this.
                Log.d("MESSAGING", "There is no FCM token saved yet. Saving the one that got earlier.");

                // saving the token locally.
                SharedPreferences.Editor editor = preferences.edit();
                editor.putString("fcm token", token);
                editor.apply();

                // if there is no token saved remotely, then save it.
            }
            else
            {
                // request handler will replace this.
                Log.d("MESSAGING", "There is another FCM token saved, that doesn't match this one.");

                // save the new token.
                SharedPreferences.Editor editor = preferences.edit();
                editor.putString("fcm token", token);
                editor.apply();

                // send request that deletes the old token and saves the new one.
            }

        });
    }


    @Override
    public void onMessageReceived(@NonNull RemoteMessage message)
    {
        Log.d("MESSAGING", "Got notification from: " + message.getFrom());
        sendNotification(message.getNotification().getTitle(), message.getNotification().getBody());
    }

    private void sendNotification(String messageTitle, String messageBody)
    {
        // i have absolutely no idea what this code does, it was auto-generated.
        Intent intent = new Intent(this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE);

        String channelId = "alerts";
        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder =
                new NotificationCompat.Builder(this, channelId)
                        .setContentTitle(messageTitle)
                        .setContentText(messageBody)
                        .setAutoCancel(true)
                        .setSound(defaultSoundUri)
                        .setContentIntent(pendingIntent);

        notificationBuilder.setSmallIcon(R.drawable.benzinapp_logo_round);

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        // Since android Oreo notification channel is needed.
        NotificationChannel channel = new NotificationChannel(channelId, "Channel human readable title", NotificationManager.IMPORTANCE_DEFAULT);
        notificationManager.createNotificationChannel(channel);

        notificationManager.notify(0 , notificationBuilder.build());
    }

    @Override
    public void onNewToken(@NonNull String token)
    {
        super.onNewToken(token);

        Log.e("MESSAGING", token);
    }
}
