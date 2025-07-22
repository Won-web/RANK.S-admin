package com.etech.starranking.ui.adapter;

import android.content.Context;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs.FreeChargeTab;
import com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs.PaidChargeTab;
import com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs.StarShopTab;


public class TabStarShopAdapter extends FragmentPagerAdapter {

    private Context myContext;
    int totalTabs;

    public TabStarShopAdapter(Context context, FragmentManager fm, int totalTabs) {
        super(fm);
        myContext = context;
        this.totalTabs = totalTabs;
    }


    @Override
    public Fragment getItem(int position) {
        switch (position) {
            case 0:
                PaidChargeTab tabFragment = new PaidChargeTab();
                return tabFragment;
            case 1:
                FreeChargeTab tabFragment2 = new FreeChargeTab();
                return tabFragment2;
            case 2:
                StarShopTab tabFragment3 = new StarShopTab();
                return tabFragment3;

            default:
                return null;
        }
    }


    @Override
    public int getCount() {
        return totalTabs;
    }


}
