package com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.used;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.StarHistory;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class UsedStarPresenter<V extends UsedStarContract.View>
        extends BasePresenter<V>
        implements UsedStarContract.Presenter<V> {
    private String userId = null;

    @Override
    public void initView(String user_id) {
        this.userId = user_id;
        getView().setupView(false);
        moreData(user_id);
    }

    @Override
    public void resetData() {
        getView().setupView(true);
        moreData(userId);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

   private boolean isMoreDataPending = false;

    @Override
    public void moreData(String user_id) {
        startLoading();
        isMoreDataPending = true;
        this.userId = user_id;
        getView().setNoRecordsAvailable(false);
        StarRankingApp.getDataManager().getUsedStars(AppUtils.LANGUAGE_DEFAULT_VALUE, user_id, new DataManager.Callback<StarHistory>() {
            @Override
            public void onSuccess(StarHistory baseRes) {
                isMoreDataPending = false;

                if (getView() == null) {
                    return;
                }

                if (baseRes.getUsage_history().size() == 0) {
                    getView().setNoRecordsAvailable(true);
                }
                stopLoading();
                getView().loadData(baseRes.getUsage_history());

            }


            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isMoreDataPending = false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }

    @Override
    public void retry() {
        super.retry();
        if (isMoreDataPending) {
            moreData(userId);
        }
    }
}
