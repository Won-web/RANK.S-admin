package com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.used;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.TabLayoutUsedHistoryBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.UsedStar;
import com.etech.starranking.ui.adapter.UsedStarListAdapter;
import com.etech.starranking.utils.Constants;

import java.util.ArrayList;

@SuppressWarnings({"Convert2Lambda", "StatementWithEmptyBody"})
public class UsedStarHistoryTab extends BaseFragment implements UsedStarContract.View {

 private    TabLayoutUsedHistoryBinding binding;
    private    UsedStarListAdapter adapter;
    private UsedStarContract.Presenter<UsedStarContract.View> presenter;

    public UsedStarHistoryTab() {

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        binding = DataBindingUtil.inflate(inflater, R.layout.tab_layout_used_history, container, false);
//        binding.rvUsedStarHistory.setAdapter();
        presenter = new UsedStarPresenter<>();
        presenter.onAttach(this);
        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();
        presenter.initView(user.getUser_id());

        initUi();
        return binding.getRoot();
    }

    private void initUi() {
        binding.rvUsedStarHistory.setSwipeRefreshLayout(binding.swipeRefreshLayout);
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
    }

    @Override
    public void onDestroy() {
        presenter.onDetach();
        super.onDestroy();
    }

    @Override
    public void loadData(ArrayList<UsedStar> stars) {
        adapter.addData(stars);
    }

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;

        }
        if (adapter == null) {
            adapter = new UsedStarListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<UsedStar>() {
                        @Override
                        public void onClick(UsedStar model, View view, int position, ViewType viewType) {
                            if (viewType == ViewType.View) {

//                                utils.setToast("view clicked " + model.getName());
                            } else if (viewType == ViewType.Text) {
//                                utils.setToast("text clicked " + model.getName());
                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvUsedStarHistory.setAdapter(adapter);
            binding.rvUsedStarHistory.addItemDecoration(new DividerItemDecoration(binding.rvUsedStarHistory.getContext(), DividerItemDecoration.VERTICAL));
        } else {
            binding.rvUsedStarHistory.setAdapter(adapter);
            binding.rvUsedStarHistory.addItemDecoration(new DividerItemDecoration(binding.rvUsedStarHistory.getContext(), DividerItemDecoration.VERTICAL));
        }
    }


    @Override
    public void setNoRecordsAvailable(boolean noRecords) {
        if (noRecords) {
            binding.noDataFound.getRoot().setVisibility(View.VISIBLE);
        } else {
            binding.noDataFound.getRoot().setVisibility(View.GONE);
        }
    }

    @Override
    public void hideLoader() {
        super.hideLoader();
        if (binding != null)
            binding.swipeRefreshLayout.setRefreshing(false);
    }
    @Override
    public void onReceiverNotification(Context context, String type, Intent intent) {
        super.onReceiverNotification(context, type, intent);
        if(Constants.LB_TYPE_STAR_UPDATED.equals(type)){
            if(presenter!=null){
                presenter.resetData();
            }
        }
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}