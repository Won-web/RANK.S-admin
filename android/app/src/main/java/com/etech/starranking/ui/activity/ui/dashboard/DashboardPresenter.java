package com.etech.starranking.ui.activity.ui.dashboard;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.GiftDetailsVm;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.model.StarDetailsVm;
import com.etech.starranking.ui.activity.model.UserFromMobile;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class DashboardPresenter<V extends DashboardContract.View>
        extends BasePresenter<V>
        implements DashboardContract.Presenter<V> {
    UserFromMobile model;

    @Override
    public void init() {

    }

    @Override
    public void getdetails(String mobile) {
        startLoading();
        StarRankingApp.getDataManager().getDetailsbyPhoneNumber(mobile,
                AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<UserFromMobile>() {

                    @Override
                    public void onSuccess(UserFromMobile baseRes) {
                        stopLoading();
                        getView().getSuccessdetailsfromMobile(baseRes.getUser_details());
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        getView().failfromMobile();
                        stopLoading();
//                        onFail(code, msg, true, false);
                    }

                });
    }

    @Override
    public void sendgift(String reciverid,String receiverName,  String senderid, String sendername, String stars) {
        startLoading();
        StarRankingApp.getDataManager().getGiftStarApi(reciverid, senderid, sendername, stars,
                AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<GiftDetailsVm>() {
                    @Override
                    public void onSuccess(GiftDetailsVm baseRes) {
                        stopLoading();
                        getView().getSuccessGiftSent(baseRes.getStars(),receiverName,stars);
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        Log.e("gift", "on fail " + msg);
                        onFail(code, msg);
                        stopLoading();
                    }
                });
    }
    boolean isGetProfilePending=false;
    String userId,userType;
    @Override
    public void getUserProfileAlways(String user_id, String user_type) {
        isGetProfilePending=true;
        this.userId=user_id;
        this.userType=user_type;
        StarRankingApp.getDataManager().getUserProfileAlwasys(AppUtils.LANGUAGE_DEFAULT_VALUE,
                user_id, user_type, new DataManager.Callback<LoginDataModel>() {
                    @Override
                    public void onSuccess(LoginDataModel baseRes) {
                        isGetProfilePending=false;
                        getView().getSuccessUserProfileAlways(baseRes.getLogin());
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if(code!= Constants.FAIL_INTERNET_CODE){
                            isGetProfilePending=false;
                        }
                        Log.e("profile", "on fail " + msg);
                    }
                });
    }

    @Override
    public void retry() {
        super.retry();
        if(isGetProfilePending){
            getUserProfileAlways(userId, userType);
        }
    }
}
