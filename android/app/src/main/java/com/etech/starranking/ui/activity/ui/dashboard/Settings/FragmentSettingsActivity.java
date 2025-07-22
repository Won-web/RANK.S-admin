package com.etech.starranking.ui.activity.ui.dashboard.Settings;

import android.os.Bundle;
import android.view.View;

import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentNotificationBinding;
import com.etech.starranking.databinding.ActivityFragmentSettingBinding;
import com.etech.starranking.ui.activity.ui.dashboard.history.HistoryFragment;
import com.etech.starranking.utils.AppUtils;

public class FragmentSettingsActivity extends BaseActivity {

    ActivityFragmentSettingBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragment_setting);

        Bundle bundle = new Bundle();
       AppUtils.gradientStatusbar(FragmentSettingsActivity.this);
        addFragment(SettingsFragment.newInstance(bundle), false, false);
        setupView(binding.extraViews);
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(FragmentSettingsActivity.this);

            }

        });
        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
    }
}
