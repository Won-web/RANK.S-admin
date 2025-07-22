package com.etech.starranking.ui.activity.ui.dashboard.notification;

import android.os.Bundle;
import android.view.View;

import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentNoticeBinding;
import com.etech.starranking.databinding.ActivityFragmentNotificationBinding;
import com.etech.starranking.ui.activity.ui.dashboard.history.HistoryFragment;
import com.etech.starranking.utils.AppUtils;

public class FragmentNotificationActivity extends BaseActivity {

    ActivityFragmentNotificationBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragment_notification);
        Bundle bundle = new Bundle();
        setupView(binding.extraViews);
        AppUtils.gradientStatusbar(FragmentNotificationActivity.this);
        addFragment(NotificationFragment.newInstance(bundle), false, false);
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(FragmentNotificationActivity.this);

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
