package com.georgemc2610.benzinapp.classes.activity_tools;

import android.app.Activity;
import android.content.res.Configuration;
import android.graphics.Color;

public final class NightModeTool
{
    public static boolean isNightMode(Activity activity)
    {
        return (activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES;
    }

    public static int getTextColor(Activity activity)
    {
        return isNightMode(activity)? Color.WHITE : Color.BLACK;
    }
}
