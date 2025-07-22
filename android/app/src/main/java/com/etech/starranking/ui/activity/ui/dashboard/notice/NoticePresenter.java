package com.etech.starranking.ui.activity.ui.dashboard.notice;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.NoticeList;
import com.etech.starranking.ui.activity.model.PaidChargeList;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class NoticePresenter<V extends NoticeContract.View>
        extends BasePresenter<V>
        implements NoticeContract.Presenter<V> {


    private Pagging<NoticeList> mainSliderPagging;

    @Override
    public void onAttach(V baseview) {
        super.onAttach(baseview);
        mainSliderPagging = new Pagging<>();

    }

    @Override
    public void onDetach() {
        super.onDetach();
    }


    @Override
    public void initView() {
        getView().setupView(false);
        moreData();

    }

    @Override
    public void resetData() {
        getView().setupView(true);

        moreData();

    }

    private static final String TAG = "NoticePresenter";
    boolean isMoreDataPending=false;
    @Override
    public void moreData() {
        startLoading();
        isMoreDataPending=true;
        getView().setNoRecordsAvailable(false);
        StarRankingApp.getDataManager().getNoticeLists(
                mainSliderPagging, AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<Pagging<NoticeList>>() {
                    @Override
                    public void onSuccess(Pagging<NoticeList> baseRes) {
                        isMoreDataPending=false;
                        if (getView() == null)
                            return;
                        mainSliderPagging = baseRes;

                        if (mainSliderPagging.getArrayList().size() > 0) {
                            getView().loadData(mainSliderPagging.getArrayList());
                        }
                        stopLoading();
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if(code!=Constants.FAIL_INTERNET_CODE){
                        isMoreDataPending=false;
                        }
                        if (getView() == null)
                            return;
                        if (code == Constants.FAIL_CODE) {
                            getView().setNoRecordsAvailable(true);
                        }
                        onFailedWithConnectionLostView(code, msg);

                    }

                });
    }

    @Override
    public void retry() {
        super.retry();
        if(isMoreDataPending){
            moreData();
        }

    }
}
