package com.etech.starranking.ui.activity.ui.dashboard.notice;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.NavFragmentNoticeBinding;
import com.etech.starranking.ui.activity.SampleWebViewActivity;
import com.etech.starranking.ui.activity.model.NoticeList;
import com.etech.starranking.ui.adapter.NoticeListAdapter;

import java.util.ArrayList;

@SuppressWarnings("Convert2Lambda")
public class NoticeFragment extends BaseFragment implements NoticeContract.View {

    private NoticeContract.Presenter<NoticeContract.View> presenter;
    private NavFragmentNoticeBinding binding;
    private NoticeListAdapter adapter;

    public NoticeFragment() {


    }


    public static NoticeFragment newInstance(Bundle bundle) {
        NoticeFragment fragment = new NoticeFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = DataBindingUtil.inflate(inflater, R.layout.nav_fragment_notice, container, false);

        presenter = new NoticePresenter<>();
        presenter.onAttach(this);
        presenter.initView();
        initUi();

        return binding.getRoot();
    }

    private void initUi() {
        binding.rvNotice.setSwipeRefreshLayout(binding.swipeRefreshLayout);
        binding.swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                binding.swipeRefreshLayout.setRefreshing(true);
                presenter.resetData();
            }
        });
    }

    @Override
    public void loadData(ArrayList<NoticeList> homes) {
        adapter.addData(homes);
    }

    @Override
    public void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;


        }
        if (adapter == null) {
            adapter = new NoticeListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<NoticeList>() {


                        @Override
                        public void onClick(NoticeList model, View view, int position, ViewType viewType) {
                            if (viewType == ViewType.View) {
                                Intent i = new Intent(getContext(), NoticeDetailsActivity.class);
                                i.putExtra("noticeTitle", model.getMessage_title());
                                i.putExtra("noticeDate", model.getCreated_date());
                                i.putExtra("noticeContent", model.getMessage());
                                i.putExtra("noticeUrl", model.getWeb_view_url());
                                startActivity(i);
//                                Intent sampleWebViewIntent = new Intent(getContext(), SampleWebViewActivity.class);
//                                sampleWebViewIntent.putExtra(SampleWebViewActivity.ARG_URL, model.getWeb_view_url());
//                                sampleWebViewIntent.putExtra(SampleWebViewActivity.ARG_FROM, "notice");
//                                startActivity(sampleWebViewIntent);

                            }

                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvNotice.setAdapter(adapter);
            binding.rvNotice.addItemDecoration(new DividerItemDecoration(binding.rvNotice.getContext(), DividerItemDecoration.VERTICAL));
        } else {
            binding.rvNotice.setAdapter(adapter);
            binding.rvNotice.addItemDecoration(new DividerItemDecoration(binding.rvNotice.getContext(), DividerItemDecoration.VERTICAL));
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