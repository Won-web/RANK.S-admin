package com.etech.starranking.ui.activity.ui.emailOtpVerificationForForgotPwd;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.emailOtpVerification.EmailOtpVerificationContract;

public class EmailOtpVerificationForgotPwdContract {
    interface View extends BaseContractView {
        void onSuccessEmailVerification(LoginProfile model);

        void onfail(String message);
        void onSuccessOtpResend(EmailOtpVerify model);

    }

    interface Presenter<V extends EmailOtpVerificationForgotPwdContract.View> extends BaseContractPresenter<V> {

        void emailOtpVerify(String email, String otp);

        void resendOtp(String email);

    }
}


