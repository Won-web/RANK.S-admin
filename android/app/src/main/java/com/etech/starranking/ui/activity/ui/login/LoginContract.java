package com.etech.starranking.ui.activity.ui.login;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.model.LoginProfile;

import java.util.ArrayList;

public interface LoginContract {
    interface View extends BaseContractView {
        void onSuccessLogin(LoginProfile model);

//        void onSuccessRegisterd();

        void onfail(String message);

        void gotoSignUp(LoginProfile loginProfile);

        void socialLoginSuccess(LoginProfile model);
    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void doLogin(String langugae, String email, String pwd, String auto_loin, String login_typr);

        void doSocialLogin(LoginProfile loginProfile);

        void doRegisterDevice(String langugae, String userid, String token);

    }
}
