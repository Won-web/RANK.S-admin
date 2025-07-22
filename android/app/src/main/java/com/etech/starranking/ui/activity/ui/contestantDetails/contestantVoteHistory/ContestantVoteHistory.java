package com.etech.starranking.ui.activity.ui.contestantDetails.contestantVoteHistory;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.ActivityContestantVoteHistoryBinding;
import com.etech.starranking.ui.activity.model.ContestantVoteHistoryList;
import com.etech.starranking.ui.activity.model.VoteListModel;
import com.etech.starranking.ui.adapter.ContestantVoteListAdapter;
import com.etech.starranking.utils.AppUtils;

import java.util.ArrayList;

public class ContestantVoteHistory extends BaseActivity implements ListContestantVoteContact.View {

    public static final String ARG_CONTEST_ID = "arg_ContestantVoteHistory_contestId";
    public static final String ARG_CONTESTANT_ID = "arg_ContestantVoteHistory_contestantId";
    private static final String TAG = "ContestantVoteHistory";
    public static final int BANNER_TAPPED_CODE=11;
    ActivityContestantVoteHistoryBinding binding;
    ContestantVoteListAdapter adapter;
    ListContestantVoteContact.Presenter<ListContestantVoteContact.View> presenter;
    String img, msg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(ContestantVoteHistory.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_contestant_vote_history);
        setupView(binding.extraViews);
        presenter = new ListContestantVoteHistoryPresenter<>();
        presenter.onAttach(this);
        presenter.initView(getIntent().getStringExtra(ARG_CONTEST_ID), getIntent().getStringExtra(ARG_CONTESTANT_ID));
        initUi();

    }

    private void initUi() {
        binding.rvforVoteToContestant.setSwipeRefreshLayout(binding.swipeRefreshLayout);
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
        binding.tool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.tool.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(ContestantVoteHistory.this);
            }
        });
        binding.banner.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                setResult(BANNER_TAPPED_CODE);
                finish();
            }
        });
    }

    @Override
    public void hideLoader() {
        super.hideLoader();
        if (binding != null) {
            binding.swipeRefreshLayout.setRefreshing(false);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        presenter.onDetach();
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }

    @Override
    public void loadData(VoteListModel homes) {
        AppUtils.setImageUrl(this, homes.getBanner(), binding.banner, true, R.drawable.home_samll_holder);
        adapter.addData(homes.getVoteHistoryLists());
    }

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;

        }
        if (adapter == null) {
            adapter = new ContestantVoteListAdapter(getApplicationContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<ContestantVoteHistoryList>() {

                        @Override
                        public void onClick(ContestantVoteHistoryList model, View view, int position, ViewType viewType) {

                        }

                        @Override
                        public void onLastItemReached() {

                        }


                    });
            binding.rvforVoteToContestant.setAdapter(adapter);
            binding.rvforVoteToContestant.addItemDecoration(new DividerItemDecoration(binding.rvforVoteToContestant.getContext(), DividerItemDecoration.VERTICAL));
        } else {
            binding.rvforVoteToContestant.setAdapter(adapter);
            binding.rvforVoteToContestant.addItemDecoration(new DividerItemDecoration(binding.rvforVoteToContestant.getContext(), DividerItemDecoration.VERTICAL));
        }
    }

    @Override
    public void setNoRecordsAvailable(boolean noRecords) {
        Log.d(TAG, "setNoRecordsAvailable: " + noRecords);
        if (noRecords) {
            binding.noDataFound.getRoot().setVisibility(View.VISIBLE);
        } else {
            binding.noDataFound.getRoot().setVisibility(View.GONE);
        }
    }
}
