package com.etech.starranking.ui.activity.ui.emailOtpVerification;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.login.LoginContract;

public class EmailOtpVerificationContract {
    interface View extends BaseContractView {
        void onSuccessEmailVerification(LoginProfile model);
        void onfail(String message);
        void onSuccessRegisterd();
        void onSuccessOtpResend(EmailOtpVerify model);
        void onFailOtpResend(String message);

    }

    interface Presenter<V extends EmailOtpVerificationContract.View> extends BaseContractPresenter<V> {

        void emailOtpVerify(String email, String otp);
        void doRegisterDevice(String langugae, String userid, String token);
        void resendOtp(String email);

    }
}
