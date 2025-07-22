package com.etech.starranking.ui.activity.ui.forgotPassword;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.login.LoginContract;

public class ForgotPasswordContract {
    interface View extends BaseContractView{
        void onSuccessEmailVerification(EmailOtpVerify model);
        void onfail(String message);
    }
    interface Presenter<V extends ForgotPasswordContract.View> extends BaseContractPresenter<V> {
        void init();
        void emailVerificationForForgotPassword(String email);
    }
}
