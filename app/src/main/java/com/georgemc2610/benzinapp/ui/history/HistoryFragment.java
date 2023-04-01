package com.georgemc2610.benzinapp.ui.history;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.ActivityAddRecord;
import com.georgemc2610.benzinapp.DatabaseManager;
import com.georgemc2610.benzinapp.MainActivity;
import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.databinding.FragmentHistoryBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class HistoryFragment extends Fragment
{

    private FragmentHistoryBinding binding;

    FloatingActionButton ButtonAdd;
    LinearLayout scrollViewRelativeLayout;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        binding = FragmentHistoryBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        ButtonAdd = root.findViewById(R.id.button_add);
        ButtonAdd.setOnClickListener(new ButtonAddListener(getContext()));

        TextView hint = root.findViewById(R.id.textViewClickCardsMsg);

        scrollViewRelativeLayout = root.findViewById(R.id.historyFragment_linearLayoutScrollView);
        DatabaseManager.getInstance().DisplayCards(scrollViewRelativeLayout, getLayoutInflater(), hint);

        return root;
    }

    @Override
    public void onDestroyView()
    {
        super.onDestroyView();
        binding = null;
    }
}


class ButtonAddListener implements View.OnClickListener
{
    private final Context context;

    ButtonAddListener(Context context)
    {
        this.context = context;
    }

    @Override
    public void onClick(View v)
    {
        Intent intent = new Intent(context, ActivityAddRecord.class);
        context.startActivity(intent);
    }
}