package com.etech.starranking.ui.activity.ui.dashboard.history;

import android.os.Bundle;
import android.view.View;

import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentHistoryBinding;
import com.etech.starranking.ui.activity.ui.dashboard.notice.NoticeDetailsActivity;
import com.etech.starranking.utils.AppUtils;

public class FragmentHistoryActivity extends BaseActivity {

    ActivityFragmentHistoryBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(FragmentHistoryActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragment_history);

        setupView(binding.extraViews);
        Bundle bundle = new Bundle();

        addFragment(HistoryFragment.newInstance(bundle), false, false);
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(FragmentHistoryActivity.this);

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
