package com.georgemc2610.benzinapp.classes.activity_tools;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.res.Configuration;
import android.content.res.Resources;

import androidx.annotation.Nullable;

import java.util.Locale;

public final class LanguageTool
{
    public static final int SYSTEM_DEFAULT = 0;
    public static final int ENGLISH = 1;
    public static final int GREEK = 2;

    private static Locale selectedLocale;

    public static Locale getSelectedLocale()
    {
        return selectedLocale == null? Locale.getDefault() : selectedLocale;
    }

    public static void setSelectedLocale(Locale locale)
    {
        selectedLocale = locale;
    }

    public static ContextWrapper changeLanguage(Context context, @Nullable Locale locale)
    {
        Resources resources = context.getResources();
        Configuration configuration = resources.getConfiguration();

        Locale systemLocale = configuration.getLocales().get(0);

        Locale.setDefault(locale == null? systemLocale : locale);
        configuration.setLocale(locale);
        context = context.createConfigurationContext(configuration);

        return new ContextWrapper(context);
    }
}
