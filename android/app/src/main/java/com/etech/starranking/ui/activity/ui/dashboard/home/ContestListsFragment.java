package com.etech.starranking.ui.activity.ui.dashboard.home;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.NavFragmentHomeBinding;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.SubContestList;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.adapter.ContestSliderAdapter;
import com.etech.starranking.ui.adapter.SubContestListAdapter;
import com.etech.starranking.utils.OnRecyclerViewItemClickListener;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;


public class ContestListsFragment extends BaseFragment implements HomeContract.View {
    //dashboard
    int i = 0;
//    Timer timer;
//    final long DELAY_MS = 500;
//    final long PERIOD_MS = 5000;
//    boolean play_on_pauseoff = true;
//    Handler handler;
//    Runnable Update;

    private ArrayList<ContestSliderContents> topBanners = new ArrayList<>();
    private ArrayList<SubContestList> bottomContests = new ArrayList<>();


    public static ContestListsFragment newInstance() {
        return newInstance(null);
    }

    public static ContestListsFragment newInstance(Bundle bundle) {
        ContestListsFragment fragment = new ContestListsFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }


//    ContestSliderAdapter adapter;
    SubContestListAdapter subAdapter;
    NavFragmentHomeBinding binding;

    //    ArrayList<ContestSliderContents> contents = new ArrayList<ContestSliderContents>();
    HomeContract.Presenter<HomeContract.View> presenter;

    public ContestListsFragment() {

    }

    //arraylist.add data
    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {


        binding = DataBindingUtil.inflate(inflater, R.layout.nav_fragment_home, container, false);


        presenter = new HomePresenter<>();
        presenter.onAttach(this);
        presenter.init();
        binding.rvSubContestList.setNestedScrollingEnabled(false);

//        binding.rvSubContestList.addOnScrollListener(new RecyclerView.OnScrollListener() {
//            @Override
//            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
//                super.onScrollStateChanged(recyclerView, newState);
//                if (newState != RecyclerView.SCROLL_STATE_IDLE) {
//                    binding.swipeRefreshLayout.setEnabled(false);
//                } else {
//                    binding.swipeRefreshLayout.setEnabled(true);
//                }
//            }
//        });
//        addFragment(this, true,true);
        Activity activity = getActivity();
        if (activity instanceof DashboardActivity) {
            ((DashboardActivity) activity).binding.includedAppbar.searchview.setVisibility(View.VISIBLE);
        }

        binding.rlMainContestBanner.requestLayout();
        initUi();

        // String take = AppPreferencesHelper.get(AppPreferencesHelper.PREF_APP_VERNAME, "");
        return binding.getRoot();
    }

    private void initUi() {
        binding.rvSubContestList.setSwipeRefreshLayout(binding.swipeRefreshLayout);
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
    }

    @Override
    public void onDestroyView() {
        presenter.onDetach();
        super.onDestroyView();

    }

    //    public void addFragment(Fragment fragment, boolean isClearStack, boolean isAddToStack) {
//        Log.d("main", fragment.getClass().getName());
//        String tag = fragment.getClass().getName() + count;
//
//        if (isClearStack) {
//            clearFragmentStack();
//        }
//        FragmentTransaction transaction = getFragmentManager().beginTransaction();
////        transaction.setCustomAnimations(android.R.anim.fade_in, android.R.anim.fade_out);
//
//        if (isAddToStack)
//            transaction.addToBackStack(tag);
//        transaction.replace(R.id.llframemain, fragment, tag);
//        transaction.commit();
//        count = count + 1;
//    }
//
//    public void clearFragmentStack() {
//        for (int i = 0; i < getFragmentManager().getBackStackEntryCount(); i++) {
//            String name = getFragmentManager().getBackStackEntryAt(0).getName();
//            getFragmentManager().popBackStack(name, FragmentManager.POP_BACK_STACK_INCLUSIVE);
//            break;
//        }
//    }
    @Override
    public void loadData(ArrayList<ContestSliderContents> homes) {
        this.topBanners.addAll(homes);
//        adapter.addData(homes);
        subAdapter.addBanners(homes);
        if (topBanners.size() == 0) {
            binding.vpBannerSlider.setVisibility(View.GONE);
        } else {
            binding.vpBannerSlider.setVisibility(View.VISIBLE);
        }
        setNoRecordsAvailable();

    }

    @Override
    public void loadSubData(ArrayList<SubContestList> subContestLists) {
        this.bottomContests.addAll(subContestLists);
        subAdapter.addData(subContestLists);
    }

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
//            adapter = null;
            subAdapter = null;
            bottomContests.clear();
            topBanners.clear();

        }
        if (subAdapter == null) {
            subAdapter = new SubContestListAdapter(getContext(), new BaseMainAdpter.OnRecyclerviewClick<SubContestList>() {
                @Override
                public void onClick(SubContestList model, View view, int position, ViewType viewType) {
                    if (viewType == viewType.View) {
                        Intent i = new Intent(getContext(), ContestDetailsFragmentActivity.class);
//                        i.putExtra("img_url", model.getImageUrl());
                        i.putExtra("contest_id", model.getContest_id());
                        i.putExtra("vote_open_date",model.getVoteOpenDate());
                        i.putExtra("vote_close_date",model.getVoteCloseDate());
                        startActivity(i);
//                                utils.setToast("view clicked " + model.getName());
                    }
                }

                @Override
                public void onLastItemReached() {
                    Log.d(TAG, "onLastItemReached: ");
                    presenter.loadMoreData();
                }
            });

            binding.rvSubContestList.setAdapter(subAdapter);
        } else {
            binding.rvSubContestList.setAdapter(subAdapter);
        }


//        else {
//            pager.setAdapter(adapter);
//        }
    }

    @Override
    public void setNoRecordsAvailable() {
        boolean noRecords = false;
        if (topBanners.size() == 0 && bottomContests.size() == 0) {
            noRecords = true;
        }
        if (noRecords) {
            binding.noDataFound.getRoot().setVisibility(View.VISIBLE);
        } else {
            binding.noDataFound.getRoot().setVisibility(View.GONE);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        presenter.onDetach();
    }

    @Override
    public void hideLoader() {
        super.hideLoader();
        if (subAdapter != null) {
            subAdapter.updateBottomProgress(1);
        }
        if (binding != null)
            binding.swipeRefreshLayout.setRefreshing(false);
    }

    @Override
    public void showBottomProgressBar() {
        if (subAdapter != null) {
            subAdapter.setAddFooter(true);
            subAdapter.updateBottomProgress(0);
        }
    }

    private static final String TAG = "ContestListsFragment";

    @Override
    public void hideBottomProgressCompletely() {
        Log.d(TAG, "hideBottomProgressCompletely: ");
        if (subAdapter != null) {
            subAdapter.setAddFooter(false);
            subAdapter.updateBottomProgress(2);
        }
    }

    @Override
    public void bannerLoadingFailed() {
        setNoRecordsAvailable();
    }

    @Override
    public void onRetryClicked() {
        Log.d(TAG, "onRetryClicked() called");
        super.onRetryClicked();
        presenter.retry();
    }
}