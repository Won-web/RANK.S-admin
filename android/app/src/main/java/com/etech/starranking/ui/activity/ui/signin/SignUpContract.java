package com.etech.starranking.ui.activity.ui.signin;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;


public interface SignUpContract {
    interface View extends BaseContractView {
       // void onSuccessSignUp(LoginProfile model);
        void onSuccessSignUp(EmailOtpVerify model);

        void Successdoublechecked(String msg);

        void onSuccessRegisterd();

        void successSocialSignup(LoginProfile model);

        void onfail(String message);

        void onfailEmailCheck(String message);

        void setUserDataToInput(String email, String pwd, String mob, String nickname, Boolean terms, Boolean privacy, Boolean news);
        void socialLoginSuccess(LoginProfile model);
        void onfailVerifySocialMedia();
    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {
        void doSignup(String email, String pwd, String name, String mob, String nickname, int terms, int privacy, int news);

        void doublecheck(String email);

        void doRegisterDevice(String langugae, String userid, String token);

        void getUserData();
        void doSocialLogin(LoginProfile loginProfile);

        void socialSignup(String social_id, String name, String nick_name, String email, String login_type, String mobile);
    }
}
