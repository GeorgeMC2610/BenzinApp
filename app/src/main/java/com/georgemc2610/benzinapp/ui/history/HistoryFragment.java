package com.georgemc2610.benzinapp.ui.history;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.georgemc2610.benzinapp.R;
import com.georgemc2610.benzinapp.databinding.FragmentHistoryBinding;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class HistoryFragment extends Fragment
{

    private FragmentHistoryBinding binding;

    FloatingActionButton ButtonAdd;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState)
    {
        binding = FragmentHistoryBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        ButtonAdd = root.findViewById(R.id.button_add);
        ButtonAdd.setOnClickListener(new ButtonAddListener());

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
    @Override
    public void onClick(View v)
    {
        System.out.println("Hello!");
    }
}