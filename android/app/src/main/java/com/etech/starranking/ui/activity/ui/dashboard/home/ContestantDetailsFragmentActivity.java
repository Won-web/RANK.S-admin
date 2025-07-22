package com.etech.starranking.ui.activity.ui.dashboard.home;

import android.os.Bundle;
import android.view.View;

import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityFragmentContestantdetailBinding;
import com.etech.starranking.ui.activity.ui.contestantDetails.ContestantDetails;
import com.etech.starranking.utils.AppUtils;

public class ContestantDetailsFragmentActivity extends BaseActivity {

    ActivityFragmentContestantdetailBinding binding;
    String contestantid;
    String contestid;
    String voteOpenDate,voteCloseDate;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(ContestantDetailsFragmentActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_fragment_contestantdetail);
        setupView(binding.extraViews);
        Bundle bundle = new Bundle();
        Bundle extras = getIntent().getExtras();
        contestantid = extras.getString("contestantid", "");
        contestid = extras.getString("contestid", "");
        voteCloseDate = extras.getString("vote_close_date","");
        voteOpenDate = extras.getString("vote_open_date","");
        bundle.putString("contestantid", contestantid);
        bundle.putString("contestid", contestid);
        bundle.putString("vote_open_date",voteOpenDate);
        bundle.putString("vote_close_date",voteCloseDate);
        ContestantDetails fragobj = new ContestantDetails();
        fragobj.setArguments(bundle);

        addFragment(fragobj, false, false);

//        addFragment(ContestantDetails.newInstance(bundle), false, false);
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(ContestantDetailsFragmentActivity.this,contestid);
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
