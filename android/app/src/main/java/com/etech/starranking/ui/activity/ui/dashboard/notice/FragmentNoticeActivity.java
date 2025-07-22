package com.etech.starranking.ui.activity.ui.dashboard.notice;

import android.os.Bundle;
import android.view.View;

import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentHistoryBinding;
import com.etech.starranking.databinding.ActivityFragmentNoticeBinding;
import com.etech.starranking.ui.activity.ui.dashboard.history.HistoryFragment;
import com.etech.starranking.utils.AppUtils;

public class FragmentNoticeActivity extends BaseActivity {

    ActivityFragmentNoticeBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragment_notice);
        Bundle bundle = new Bundle();
        setupView(binding.extraViews);
        AppUtils.gradientStatusbar(FragmentNoticeActivity.this);
        addFragment(NoticeFragment.newInstance(bundle), false, false);
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(FragmentNoticeActivity.this);

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
