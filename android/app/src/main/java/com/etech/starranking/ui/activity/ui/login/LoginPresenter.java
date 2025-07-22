package com.etech.starranking.ui.activity.ui.login;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.LoginDataModel;

import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.utils.Constants;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.zxing.client.result.ISBNParsedResult;

public class LoginPresenter<V extends LoginContract.View>
        extends BasePresenter<V>
        implements LoginContract.Presenter<V> {
    private static final String TAG = "LoginPresenter";
    private boolean isLoginPending=false;
    String language;
    String email;
    String pwd;
    String autoLogin;
    String loginType;
    @Override
    public void doLogin(String langugae, String email, String pwd, String auto_loin, String login_typr) {
        startLoading();
        this.language=langugae;
        this.email=email;
        this.pwd=pwd;
        this.autoLogin=auto_loin;
        this.loginType=login_typr;
        isLoginPending=true;
        StarRankingApp.getDataManager().getLoginProfile(langugae, email, pwd, auto_loin, login_typr, new DataManager.Callback<LoginDataModel>() {
            @Override
            public void onSuccess(LoginDataModel baseRes) {
                isLoginPending=false;
                stopLoading();
                StarRankingApp.getDataManager().saveUserToPref(baseRes.getLogin());
                FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(instanceIdResult -> {
                    doRegisterDevice(langugae, baseRes.getLogin().getUser_id(), instanceIdResult.getToken());
                });
                getView().onSuccessLogin(baseRes.getLogin());
            }

            @Override
            public void onFailed(int code, String msg) {
                if(code!= Constants.FAIL_INTERNET_CODE){
                    isLoginPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
//                getView().onfail(msg);
                Log.e("login pres", "on fail " + msg);
            }
        });
    }
    boolean isSocialLoginPending=false;
    LoginProfile loginProfile;
    @Override
    public void doSocialLogin(LoginProfile loginProfile) {
        startLoading();
        isSocialLoginPending=true;
        this.loginProfile=loginProfile;
        DataManager dataManager = StarRankingApp.getDataManager();
        dataManager.getVerifySocialMedia(dataManager.getLanguage(), loginProfile.getSocial_id(), loginProfile.getLogin_type(), new DataManager.Callback<LoginDataModel>() {
            @Override
            public void onSuccess(LoginDataModel baseRes) {
                isSocialLoginPending=false;
                stopLoading();
                dataManager.saveUserToPref(baseRes.getLogin());
                FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(instanceIdResult -> {
                    doRegisterDevice(dataManager.getLanguage(), baseRes.getLogin().getUser_id(), instanceIdResult.getToken());
                });
                getView().socialLoginSuccess(baseRes.getLogin());

            }

            @Override
            public void onFailed(int code, String msg) {
                if(code!=Constants.FAIL_INTERNET_CODE){
                    isSocialLoginPending=false;
                }
                stopLoading();
                Log.d(TAG, "onFailed: code" + code + " msg" + msg);
                if (code == 2) {
                    getView().gotoSignUp(loginProfile);
                }
                else {
                    onFailedWithConnectionLostView(code, msg);
                    Log.e("login pres", "on fail " + msg);
                }
            }
        });
    }

    @Override
    public void doRegisterDevice(String langugae, String userid, String token) {
        StarRankingApp.getDataManager().doRegisterDevice(langugae, userid, token, new DataManager.Callback<String>() {
            @Override
            public void onSuccess(String baseRes) {
            }

            @Override
            public void onFailed(int code, String msg) {
            }
        });
    }

    @Override
    public void retry() {
        super.retry();
        if(isSocialLoginPending){
            doSocialLogin(loginProfile);
        }else if(isLoginPending){
            doLogin(language, email,pwd,autoLogin,loginType);
        }
    }
}
