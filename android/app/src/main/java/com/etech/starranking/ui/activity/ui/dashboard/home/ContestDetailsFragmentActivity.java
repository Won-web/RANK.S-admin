package com.etech.starranking.ui.activity.ui.dashboard.home;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentsBinding;
import com.etech.starranking.utils.AppUtils;

public class ContestDetailsFragmentActivity extends BaseActivity {

    ActivityFragmentsBinding binding;
    String contestId;
    String voteOpenDate,voteCloseDate;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragments);

        AppUtils.gradientStatusbar(ContestDetailsFragmentActivity.this);
        Bundle bundle = new Bundle();

        Bundle extras = getIntent().getExtras();
        contestId = extras.getString("contest_id", "");
        voteOpenDate= extras.getString("vote_open_date","");
        voteCloseDate = extras.getString("vote_close_date","");
        bundle.putString("contest_id", contestId);
        bundle.putString("vote_open_date",voteOpenDate);
        bundle.putString("vote_close_date",voteCloseDate);

        ContestDetailFragment fragobj = new ContestDetailFragment();
        fragobj.setArguments(bundle);
        setupView(binding.extraViews);
        addFragment(fragobj, false, false);
        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(ContestDetailsFragmentActivity.this,contestId);
            }
        });
    }

}
