package com.etech.starranking.ui.activity.ui.dashboard.home;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.databinding.FragmentLayoutBinding;


public class HomeMainFragment extends BaseFragment {
//        implements HomeContract.View {

    private int count = 0;
//    ContestSliderAdapter adapter;
//    SubContestListAdapter subAdapter;
    FragmentLayoutBinding binding;
    HomeContract.Presenter<HomeContract.View> presenter;

    public HomeMainFragment() {

    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_layout, container, false);
        addFragment(ContestListsFragment.newInstance(), true, true);

        return binding.getRoot();

    }


    public void addFragment(Fragment fragment, boolean isClearStack, boolean isAddToStack) {
        Log.d("main", fragment.getClass().getName());
        String tag = fragment.getClass().getName() + count;

        if (isClearStack) {
            clearFragmentStack();
        }
        FragmentTransaction transaction = getFragmentManager().beginTransaction();

        if (isAddToStack)
            transaction.addToBackStack(tag);
        transaction.replace(R.id.llframemain, fragment, tag);
        transaction.commit();
        count = count + 1;
    }

    public void clearFragmentStack() {
        for (int i = 0; i < getFragmentManager().getBackStackEntryCount(); i++) {
            String name = getFragmentManager().getBackStackEntryAt(0).getName();
            getFragmentManager().popBackStack(name, FragmentManager.POP_BACK_STACK_INCLUSIVE);
            break;
        }
    }

}