package com.etech.starranking.ui.activity.ui.dashboard.history;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.FragmentTransaction;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.databinding.NavFragmentHistoryBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.earning.EarningStarHistoryTab;
import com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.used.UsedStarHistoryTab;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.google.android.material.tabs.TabLayout;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_USER_STARS;


public class HistoryFragment extends BaseFragment {

    private NavFragmentHistoryBinding binding;
    private BaseFragment baseFragment;


    public HistoryFragment() {


    }


    public static HistoryFragment newInstance(Bundle bundle) {
        HistoryFragment fragment = new HistoryFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = DataBindingUtil.inflate(inflater, R.layout.nav_fragment_history, container, false);


        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();
        binding.tvStars.setText(AppUtils.getFormatedString(user.getRemaining_star()));
        binding.tabHistory.setTabGravity(TabLayout.GRAVITY_FILL);

//        final HistoryTabAdapter adapter = new HistoryTabAdapter(getActivity(), getChildFragmentManager());
//        binding.vpHistoryTabs.setAdapter(adapter);

//        binding.vpHistoryTabs.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(binding.tabHistory));
        TabLayout.Tab earningHistoryTab = binding.tabHistory.newTab().setText(getString(R.string.str_lbl_earning_history));
        TabLayout.Tab useageHistoryTab = binding.tabHistory.newTab().setText(getString(R.string.str_lbl_useage_history));
        binding.tabHistory.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
//                binding.vpHistoryTabs.setCurrentItem(tab.getPosition());
//                tab.getCustomView().setBackgroundColor(Color.parseColor("#EF2D81"));
                if (tab == earningHistoryTab) {
                addFragment(new EarningStarHistoryTab());
                } else if (tab == useageHistoryTab) {
                addFragment(new UsedStarHistoryTab());
                }
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
//                tab.getCustomView().setBackgroundColor(Color.parseColor("#365AF5"));
            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        binding.tabHistory.addTab(earningHistoryTab);
        binding.tabHistory.addTab(useageHistoryTab);
        earningHistoryTab.select();
        return binding.getRoot();
    }

    private void addFragment(BaseFragment baseFragment){
        this.baseFragment=baseFragment;
        FragmentTransaction transaction = getChildFragmentManager()
                .beginTransaction();
        transaction.replace(R.id.frm_container, baseFragment, null);
        transaction.commit();
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        if(baseFragment!=null){
            baseFragment.onRetryClicked();
        }
    }

    @Override
    public void onReceiverNotification(Context context, String type, Intent intent) {
        super.onReceiverNotification(context, type, intent);
        if (Constants.LB_TYPE_STAR_UPDATED.equals(type)) {
            if (binding != null) {
                binding.tvStars.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(PREF_USER_STARS, "")));
            }
        }
    }
}