package com.etech.starranking.ui.activity.ui.dashboard.starShop;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityPaidChargingBinding;
import com.etech.starranking.ui.activity.ui.dashboard.Settings.FragmentSettingsActivity;
import com.etech.starranking.ui.activity.ui.dashboard.Settings.SettingsFragment;
import com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs.PaidChargeTab;
import com.etech.starranking.utils.AppUtils;

public class PaidChargingActivity extends BaseActivity {
    public static final String ARG_CONTEST_ID="arg_PaidChargingActivity_contestId";
    ActivityPaidChargingBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_paid_charging);

        AppUtils.gradientStatusbar(PaidChargingActivity.this);
        Bundle bundle = new Bundle();

        bundle.putString(PaidChargeTab.ARG_CONTEST_ID,getIntent().getStringExtra(ARG_CONTEST_ID));
        addFragment(PaidChargeTab.newInstance(bundle), false, false);
        setupView(binding.extraViews);
        binding.toolbar.ibCharge.setVisibility(View.GONE);
        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
    }

    public void goKakaoplus(View v){
//        http://pf.kakao.com/_lMxexexb
//        http://pf.kakao.com/_lMxexexb/chat
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://pf.kakao.com/_lMxexexb"));
        startActivity(intent);
    }
}
