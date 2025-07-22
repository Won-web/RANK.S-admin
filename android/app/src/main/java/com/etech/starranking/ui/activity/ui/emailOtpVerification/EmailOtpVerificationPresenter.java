package com.etech.starranking.ui.activity.ui.emailOtpVerification;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.ui.login.LoginContract;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.google.firebase.iid.FirebaseInstanceId;

public class EmailOtpVerificationPresenter<V extends EmailOtpVerificationContract.View>
        extends BasePresenter<V>
        implements EmailOtpVerificationContract.Presenter<V> {

    boolean isOtpVerifyPending = false;
    boolean isResendOtpPending = false;
    String email,otp,emailForResendOtp;

    @Override
    public void emailOtpVerify(String email, String otp) {
        this.email=email;
        this.otp=otp;
        isOtpVerifyPending = true;
        startLoading();
        StarRankingApp.getDataManager().doVerifyEmailOtp(email, otp,"register", new DataManager.Callback<LoginDataModel>() {
            @Override
            public void onSuccess(LoginDataModel baseRes) {
                isOtpVerifyPending = false;
                stopLoading();
                getView().onSuccessEmailVerification(baseRes.getLogin());
                StarRankingApp.getDataManager().setBoolean(AppPreferencesHelper.PREF_IsAutoLogin, true);
                FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(instanceIdResult -> {
                    doRegisterDevice(AppUtils.LANGUAGE_DEFAULT_VALUE, baseRes.getLogin().getUser_id(), instanceIdResult.getToken());
                });
            }

            @Override
            public void onFailed(int code, String msg) {
                stopLoading();
                if(code!= Constants.FAIL_INTERNET_CODE){
                    isOtpVerifyPending=false;
                }
                onFailedWithConnectionLostView(code, msg);



            }
        });
    }

    @Override
    public void doRegisterDevice(String langugae, String userid, String token) {

        StarRankingApp.getDataManager().doRegisterDevice(langugae, userid, token, new DataManager.Callback<String>() {

            @Override
            public void onSuccess(String baseRes) {

                getView().onSuccessRegisterd();
                //if want any id
            }

            @Override
            public void onFailed(int code, String msg) {


            }
        });
    }

    @Override
    public void resendOtp(String email) {
        this.emailForResendOtp=email;
        isResendOtpPending = true;
        startLoading();
        StarRankingApp.getDataManager().doResendOtp(email,"register", new DataManager.Callback<EmailOtpVerify>() {

            @Override
            public void onSuccess(EmailOtpVerify baseRes) {
                isResendOtpPending = false;
                stopLoading();
                getView().onSuccessOtpResend(baseRes);
            }

            @Override
            public void onFailed(int code, String msg) {
                stopLoading();
                if(code!= Constants.FAIL_INTERNET_CODE){
                    isResendOtpPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });

    }

    @Override
    public void retry() {
        super.retry();
        if (isOtpVerifyPending) {
            emailOtpVerify(email,otp);
        } else if (isResendOtpPending) {
            resendOtp(emailForResendOtp);
        }
    }
}
