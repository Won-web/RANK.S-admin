package com.etech.starranking.ui.activity.ui.dashboard.notification;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.NavFragmentNotificationsBinding;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.NotificationsList;
import com.etech.starranking.ui.adapter.NotificationListAdapter;

import java.util.ArrayList;

@SuppressWarnings("Convert2Lambda")
public class NotificationFragment extends BaseFragment implements NotificationContract.View {


    private   NotificationContract.Presenter<NotificationContract.View> presenter;
    private NavFragmentNotificationsBinding binding;
    private NotificationListAdapter adapter;

    public NotificationFragment() {


    }


    public static NotificationFragment newInstance(Bundle bundle) {
        NotificationFragment fragment = new NotificationFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.nav_fragment_notifications, container, false);

        presenter = new NotificationPresenter<>();
        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();
        presenter.onAttach(this);
        presenter.initView(user.getUser_id());
        initUi();

        return binding.getRoot();
    }

    private void initUi() {
        binding.rvNotifications.setSwipeRefreshLayout(binding.swipeRefreshLayout);
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
    }

    @Override
    public void loadData(ArrayList<NotificationsList> homes) {

        adapter.addData(homes);
    }

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;


        }
        if (adapter == null) {
            adapter = new NotificationListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<NotificationsList>() {
                        @Override
                        public void onClick(NotificationsList model, View view, int position, ViewType viewType) {
//                            FragmentManager manager = getFragmentManager();
//                            FragmentTransaction transaction = manager.beginTransaction();
//                            transaction.replace(R.id.llframemain, new ContestantDetailsModel()).addToBackStack(null);
//                            transaction.commit();
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvNotifications.setAdapter(adapter);
            binding.rvNotifications.addItemDecoration(new DividerItemDecoration(binding.rvNotifications.getContext(), DividerItemDecoration.VERTICAL));
        } else {
            binding.rvNotifications.setAdapter(adapter);
            binding.rvNotifications.addItemDecoration(new DividerItemDecoration(binding.rvNotifications.getContext(), DividerItemDecoration.VERTICAL));
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
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }
}