package com.georgemc2610.benzinapp.classes.activity_tools;

import android.content.Context;
import android.widget.EditText;
import android.widget.TextView;

import com.georgemc2610.benzinapp.R;

public final class ViewTools
{
    /**
     * Checks the trimmed content of any {@linkplain EditText} to see if it has any value in it.
     * @param editText The field to be checked.
     * @return True if it has no value, false otherwise.
     */
    public static boolean isEditTextEmpty(EditText editText)
    {
        return getFilteredViewSequence(editText).isEmpty();
    }

    /**
     * Filters the text inside an {@linkplain EditText} using the trim method of the {@linkplain String} class.
     * @param editText The wanted field for its text retrieval.
     * @return The content of the {@linkplain  EditText} with no whitespaces.
     */
    public static String getFilteredViewSequence(EditText editText)
    {
        return editText.getText().toString().trim();
    }

    /**
     * Filters the text inside an {@linkplain TextView} using the trim method of the {@linkplain String} class.
     * @param textView The wanted field for its text retrieval.
     * @return The content of the {@linkplain TextView} with no whitespaces.
     */
    public static String getFilteredViewSequence(TextView textView)
    {
        return textView.getText().toString().trim();
    }

    /**
     * Typically used to see if all the fields are correctly filled with data before proceeding to send it to the cloud.
     * Sets the errors for any fields that have no data in them.
     * @param texts A list of fields to be checked.
     * @return True all the fields have data and it's okay to proceed, false otherwise.
     */
    public static boolean setErrors(Context context, EditText... texts)
    {
        boolean canContinue = true;

        for (EditText editText: texts)
        {
            if (isEditTextEmpty(editText))
            {
                editText.setError(context.getString(R.string.error_field_cannot_be_empty));
                canContinue = false;
            }
        }

        return canContinue;
    }

    /**
     * A special tool for dates, that checks if the date is successfully filled with data.
     * It doesn't check the format of the text. Instead, it relies on the fact that the
     * string of the text is not "Please select date...".
     * @param context Context is needed to get the correct string to test with the {@linkplain TextView}'s data.
     * @param textView The {@linkplain TextView} where the date is stored.
     * @return False if the text is equal with the "Please select date..." equivalent of the current language, true otherwise.
     */
    public static boolean dateFilled(Context context, TextView textView)
    {
        return !getFilteredViewSequence(textView).equals(context.getString(R.string.text_view_select_date));
    }
}
