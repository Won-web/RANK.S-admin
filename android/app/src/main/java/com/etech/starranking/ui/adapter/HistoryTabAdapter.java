package com.etech.starranking.ui.adapter;

import android.content.Context;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.earning.EarningStarHistoryTab;
import com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.used.UsedStarHistoryTab;

public class HistoryTabAdapter extends FragmentPagerAdapter {

    private Context myContext;
//    int totalTabs;

    public HistoryTabAdapter(Context context, FragmentManager fm /*int totalTabs*/) {
        super(fm, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT);
        myContext = context;
//        this.totalTabs = totalTabs;
    }


    @Override
    public Fragment getItem(int position) {
        switch (position) {
            case 0:
                EarningStarHistoryTab tabFragment = new EarningStarHistoryTab();
                return tabFragment;
            case 1:
                UsedStarHistoryTab tabFragment2 = new UsedStarHistoryTab();
                return tabFragment2;
            default:
                return null;
        }
    }

    @Override
    public int getCount() {
        return 2;
    }
}
