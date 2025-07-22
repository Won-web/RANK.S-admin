package com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.databinding.TabPaidChargeBinding;
import com.etech.starranking.ui.activity.model.PaidChargeList;
import com.etech.starranking.ui.adapter.PaidChargeListAdapter;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.util.ArrayList;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_USER_STARS;

@SuppressWarnings({"Convert2Lambda", "ConstantConditions"})
public class PaidChargeTab extends BaseFragment implements PaidChargingContract.View {
    public static final String ARG_CONTEST_ID = "arg_PaidChargeTab_ContestId";

    private TabPaidChargeBinding binding;
    private PaidChargeListAdapter adapter;
    private PaidChargingContract.Presenter<PaidChargingContract.View> presenter;
    private static final String TAG = "PaidChargeTab";

    public PaidChargeTab() {
        // Required empty public constructor
    }

    public static PaidChargeTab newInstance(Bundle bundle) {
        PaidChargeTab fragment = new PaidChargeTab();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container,
                             Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.tab_paid_charge, container, false);

        presenter = new PaidChargingPresenter<>();
        presenter.onAttach(this);
        presenter.initView();
        initUi();

        return binding.getRoot();
    }


    private void initUi() {
        binding.rvpurchaseoptions.setSwipeRefreshLayout(binding.swipeRefreshLayout);
        binding.tvstarsSmt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(AppPreferencesHelper.PREF_USER_STARS,"0")));
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
    }

    @Override
    public void loadData(ArrayList<PaidChargeList> data) {
        adapter.addData(data);
    }

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;

        }
        if (adapter == null) {
            adapter = new PaidChargeListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<PaidChargeList>() {
                        @Override
                        public void onClick(PaidChargeList model, View view, int position, ViewType viewType) {
                            if (viewType == ViewType.View) {
                                String contestId = null;
                                if (getArguments() != null)
                                    contestId = getArguments().getString(ARG_CONTEST_ID);
                                if (AppUtils.isConnectingToInternet()) {
                                    presenter.buy(model, getActivity(), contestId);
                                } else {
                                    PaidChargeTab.this.buyFailed(getString(R.string.str_msg_no_network_connection));

                                }
                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvpurchaseoptions.setAdapter(adapter);
            binding.rvpurchaseoptions.addItemDecoration(new DividerItemDecoration(binding.rvpurchaseoptions.getContext(), DividerItemDecoration.VERTICAL));
        } else {
            binding.rvpurchaseoptions.setAdapter(adapter);
            binding.rvpurchaseoptions.addItemDecoration(new DividerItemDecoration(binding.rvpurchaseoptions.getContext(), DividerItemDecoration.VERTICAL));
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
    public void onDestroy() {
        presenter.onDetach();
        super.onDestroy();
    }

    @Override
    public void buyFailed(String message) {
        Log.d(TAG, "buyFailed: ");
        AppUtils.setToast(getContext(), message);
    }

    @Override
    public void purchaseSuccess(String baseRes) {
        AppUtils.setToast(getContext(), baseRes);
        getActivity().setResult(Activity.RESULT_OK);
        if(binding!=null){
            binding.tvstarsSmt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(AppPreferencesHelper.PREF_USER_STARS,"0")));
        }

    }
    @Override
    public void onReceiverNotification(Context context, String type, Intent intent) {
        super.onReceiverNotification(context, type, intent);
        if (Constants.LB_TYPE_STAR_UPDATED.equals(type)) {
            if (binding != null) {
                binding.tvstarsSmt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(PREF_USER_STARS, "0")));
            }
        }
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }

}
