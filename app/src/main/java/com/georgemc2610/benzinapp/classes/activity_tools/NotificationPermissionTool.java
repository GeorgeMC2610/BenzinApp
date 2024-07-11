package com.georgemc2610.benzinapp.classes.activity_tools;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.core.app.ActivityCompat;

public class NotificationPermissionTool
{
    public static void requestPermission(Activity activity)
    {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            ActivityCompat.requestPermissions(activity, new String[]{ Manifest.permission.POST_NOTIFICATIONS }, 3019);
        else
            ActivityCompat.requestPermissions(activity, new String[]{ Manifest.permission.RECEIVE_BOOT_COMPLETED }, 3017);

    }

    public static boolean isNotificationPermissionGranted(Context context)
    {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            return ActivityCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED;

        return ActivityCompat.checkSelfPermission(context, Manifest.permission.RECEIVE_BOOT_COMPLETED) == PackageManager.PERMISSION_GRANTED;
    }
}
