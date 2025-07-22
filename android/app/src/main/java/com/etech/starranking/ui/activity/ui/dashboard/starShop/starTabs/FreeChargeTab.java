package com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;

import com.etech.starranking.R;
import com.etech.starranking.databinding.TabFreeChargeBinding;

public class FreeChargeTab extends Fragment {

    TabFreeChargeBinding binding;


    public FreeChargeTab() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container,
                             Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.tab_free_charge, container, false);
        return binding.getRoot();
    }
}
