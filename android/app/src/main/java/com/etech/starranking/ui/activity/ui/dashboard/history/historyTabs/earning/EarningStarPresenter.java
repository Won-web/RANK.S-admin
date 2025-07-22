package com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.earning;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.StarHistory;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class EarningStarPresenter<V extends EarningStarContract.View>
        extends BasePresenter<V>
        implements EarningStarContract.Presenter<V> {

   private String userId = null;

    @Override
    public void initView(String USER_ID) {
        this.userId = USER_ID;
        getView().setupView(false);
        moreData(USER_ID);
    }

    @Override
    public void resetData() {
        getView().setupView(true);
        moreData(userId);
    }
    private boolean isMoreDataPending=false;
    @Override
    public void moreData(String user_id) {
        startLoading();
        this.userId=user_id;
        isMoreDataPending=true;
        getView().setNoRecordsAvailable(false);
        StarRankingApp.getDataManager().getEarningStars(AppUtils.LANGUAGE_DEFAULT_VALUE, user_id, new DataManager.Callback<StarHistory>() {
            @Override
            public void onSuccess(StarHistory baseRes) {
                isMoreDataPending=false;
                if (getView() == null)
                    return;

                if (baseRes.getPurchase_history().size() == 0) {
                    getView().setNoRecordsAvailable(true);
                }
                stopLoading();
                getView().loadData(baseRes.getPurchase_history());

            }


            @Override
            public void onFailed(int code, String msg) {
//                if (getView() == null)
//                    return;
//                if (code == Constants.FAIL_CODE) {
//                    getView().setNoRecordsAvailable(true);
//                }
                if(code!=Constants.FAIL_INTERNET_CODE){
                    isMoreDataPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }

    @Override
    public void retry() {
        super.retry();
        if(isMoreDataPending){
            moreData(userId);
        }
    }
}
