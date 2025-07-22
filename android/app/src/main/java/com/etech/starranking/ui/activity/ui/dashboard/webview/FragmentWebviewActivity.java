package com.etech.starranking.ui.activity.ui.dashboard.webview;

import android.os.Bundle;
import android.view.View;

import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentNoticeBinding;
import com.etech.starranking.databinding.ActivityFragmentWebviewBinding;
import com.etech.starranking.ui.activity.ui.dashboard.notice.NoticeFragment;
import com.etech.starranking.utils.AppUtils;

public class FragmentWebviewActivity extends BaseActivity {

    ActivityFragmentWebviewBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragment_webview);
        Bundle bundle = new Bundle();
        AppUtils.gradientStatusbar(FragmentWebviewActivity.this);
        addFragment(WebviewFragment.newInstance(bundle), false, false);
        setupView(binding.extraViews);
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(FragmentWebviewActivity.this);

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
