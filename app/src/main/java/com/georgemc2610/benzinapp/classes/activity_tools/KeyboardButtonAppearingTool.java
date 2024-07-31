package com.georgemc2610.benzinapp.classes.activity_tools;

import android.graphics.Rect;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;

/**
 * This class makes any set of {@link View}s disappear whenever the keyboard is shown.
 * In order for this to work, you have to make an anonymous object of this class, and pass
 * the Activity's/Fragment's main content view (a Linear Layout in this case), and all the views
 * that you want to disappear whenever the keyboard is shown.
 */
public class KeyboardButtonAppearingTool implements ViewTreeObserver.OnGlobalLayoutListener
{
    private boolean isShown;
    private final LinearLayout layout;
    private final View[] views;

    public KeyboardButtonAppearingTool(LinearLayout linearLayout, View... views)
    {
        this.layout = linearLayout;
        this.views = views;
        this.layout.getViewTreeObserver().addOnGlobalLayoutListener(this);
    }

    @Override
    public void onGlobalLayout()
    {
        Rect r = new Rect();
        this.layout.getWindowVisibleDisplayFrame(r);
        int screenHeight = this.layout.getRootView().getHeight();

        // r.bottom is the position above soft keypad or device button.
        // if keypad is shown, the r.bottom is smaller than that before.
        int keypadHeight = screenHeight - r.bottom;

        Log.d("KEYBOARD", "keypadHeight = " + keypadHeight);

        // 0.15 ratio is perhaps enough to determine keypad height.
        if (keypadHeight > screenHeight * 0.10)
        {
            // keyboard is opened
            if (!this.isShown)
            {
                this.isShown = true;
                changeVisibility(true);
            }
        }
        else
        {
            // keyboard is closed
            if (this.isShown)
            {
                this.isShown = false;
                changeVisibility(false);
            }
        }
    }

    private void changeVisibility(boolean visibility)
    {
        this.isShown = visibility;

        for (View v : this.views)
            v.setVisibility(this.isShown ? View.GONE : View.VISIBLE);
    }

}
