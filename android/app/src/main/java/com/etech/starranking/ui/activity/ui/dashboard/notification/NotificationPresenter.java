package com.etech.starranking.ui.activity.ui.dashboard.notification;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.NotificationsList;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

@SuppressWarnings("unused")
public class NotificationPresenter<V extends NotificationContract.View>
        extends BasePresenter<V>
        implements NotificationContract.Presenter<V> {

    private Pagging<NotificationsList> pagging = new Pagging<>();


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

    private static final String TAG = "NotificationPresenter";
    private boolean isMoreDataPending = false;

    @Override
    public void moreData(String userid) {
        startLoading();
        this.userId = userid;
        isMoreDataPending = true;
        getView().setNoRecordsAvailable(false);
        StarRankingApp.getDataManager().getNotificationLists(
                pagging, AppUtils.LANGUAGE_DEFAULT_VALUE, userid, new DataManager.Callback<Pagging<NotificationsList>>() {
                    @Override
                    public void onSuccess(Pagging<NotificationsList> baseRes) {
                        isMoreDataPending = false;
                        if (getView() == null)
                            return;
                        pagging = baseRes;
                        getView().loadData(baseRes.getArrayList());
                        stopLoading();
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if (code != Constants.FAIL_INTERNET_CODE) {
                            isMoreDataPending = false;
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
        if (isMoreDataPending) {
            moreData(userId);
        }
    }
}
