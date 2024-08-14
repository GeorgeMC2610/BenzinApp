package com.georgemc2610.benzinapp.classes.activity_tools;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.util.TypedValue;
import android.widget.Button;

import androidx.annotation.ColorInt;

import com.georgemc2610.benzinapp.R;

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

    public static int getRedColor(Activity activity)
    {
        return isNightMode(activity)? activity.getColor(R.color.red) : activity.getColor(R.color.dark_red);
    }

    public static int getGreenColor(Activity activity)
    {
        return isNightMode(activity)? activity.getColor(R.color.green) : activity.getColor(R.color.dark_green);
    }

    public static int getPrimaryColor(Activity activity)
    {
        return isNightMode(activity)? activity.getColor(R.color.main_dark) : activity.getColor(R.color.main);
    }

    public static int getSecondaryColor(Activity activity)
    {
        return isNightMode(activity)? activity.getColor(R.color.car_manufacturer_dark) : activity.getColor(R.color.car_manufacturer_light);
    }

    public static int getTetriaryColor(Activity activity)
    {
        return isNightMode(activity)? activity.getColor(R.color.car_model_dark) : activity.getColor(R.color.car_model_light);
    }


    public static void setButtonEnabled(Button button, Context context)
    {
        TypedValue typedValue = new TypedValue();
        Resources.Theme theme = context.getTheme();
        theme.resolveAttribute(androidx.appcompat.R.attr.colorPrimary, typedValue, true);
        @ColorInt int color = typedValue.data;
        button.setBackgroundColor(color);
    }
}
