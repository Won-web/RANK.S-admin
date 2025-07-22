package com.etech.starranking.ui.activity.ui.emailOtpVerificationForForgotPwd;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.ui.emailOtpVerification.EmailOtpVerificationContract;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.google.firebase.iid.FirebaseInstanceId;

public class EmailOtpVerificationForgotPwdPresenter <V extends EmailOtpVerificationForgotPwdContract.View>
        extends BasePresenter<V>
        implements EmailOtpVerificationForgotPwdContract.Presenter<V> {

    boolean isOtpVerifyPending = false;
    boolean isResendOtpPending = false;
    String email,otp,emailForResendOtp;

    @Override
    public void emailOtpVerify(String email, String otp) {
        this.email=email;
        this.otp=otp;
        isOtpVerifyPending = true;
        startLoading();
        StarRankingApp.getDataManager().doVerifyEmailOtp(email, otp,"forgotpassword", new DataManager.Callback<LoginDataModel>() {
            @Override
            public void onSuccess(LoginDataModel baseRes) {
                isOtpVerifyPending = false;
                stopLoading();
                getView().onSuccessEmailVerification(baseRes.getLogin());

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
    public void resendOtp(String email) {
        this.emailForResendOtp=email;
        isResendOtpPending = true;
        startLoading();
        StarRankingApp.getDataManager().doResendOtp(email,"forgotpassword" ,new DataManager.Callback<EmailOtpVerify>() {

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
