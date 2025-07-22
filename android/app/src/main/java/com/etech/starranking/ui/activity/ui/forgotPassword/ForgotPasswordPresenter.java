package com.etech.starranking.ui.activity.ui.forgotPassword;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.ui.login.LoginContract;
import com.etech.starranking.utils.Constants;

public class ForgotPasswordPresenter <V extends ForgotPasswordContract.View>
        extends BasePresenter<V>
        implements ForgotPasswordContract.Presenter<V>{

    private static final String TAG = "ForgotPasswordPresenter";
    boolean isSendOtpPending=false;
    String email;
    @Override
    public void init() {

    }

    @Override
    public void emailVerificationForForgotPassword(String email) {
        this.email=email;
        isSendOtpPending=true;
        startLoading();
        StarRankingApp.getDataManager().doVerifyEmailForForgotPassword(email, new DataManager.Callback<EmailOtpVerify>() {
            @Override
            public void onSuccess(EmailOtpVerify baseRes) {
                isSendOtpPending=false;
                stopLoading();
                getView().onSuccessEmailVerification(baseRes);
            }

            @Override
            public void onFailed(int code, String msg) {
                stopLoading();
                if(code!= Constants.FAIL_INTERNET_CODE){
                    isSendOtpPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }
    @Override
    public void retry() {
        super.retry();
        Log.d(TAG, "retry: "+isSendOtpPending);
        if(isSendOtpPending) {
            emailVerificationForForgotPassword(email);
        }
    }
}
