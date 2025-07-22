package com.etech.starranking.ui.activity.ui.dashboard.gift;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.databinding.NavFragmentSendStarBinding;
import com.etech.starranking.utils.AppUtils;


public class SendStarFragment extends BaseFragment {

    NavFragmentSendStarBinding binding;

    public SendStarFragment() {

    }

    public static SendStarFragment newInstance(Bundle bundle) {
        SendStarFragment fragment = new SendStarFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = DataBindingUtil.inflate(inflater, R.layout.nav_fragment_send_star, container, false);
        binding.mobileProfile.setBackground(getResources().getDrawable(R.drawable.profile));

        // binding.popup.giftMobileNo.setBackground(getResources().getDrawable(R.drawable.profile));
        return binding.getRoot();
    }

}