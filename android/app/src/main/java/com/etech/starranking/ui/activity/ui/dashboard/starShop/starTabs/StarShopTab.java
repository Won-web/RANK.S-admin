package com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;

import com.etech.starranking.R;
import com.etech.starranking.databinding.TabPaidChargeBinding;
import com.etech.starranking.databinding.TabStarShopBinding;

public class StarShopTab extends Fragment {

    TabStarShopBinding binding;


    public StarShopTab() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container,
                             Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.tab_star_shop, container, false);
        return binding.getRoot();
    }
}
