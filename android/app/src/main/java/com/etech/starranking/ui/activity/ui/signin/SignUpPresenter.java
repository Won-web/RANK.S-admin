package com.etech.starranking.ui.activity.ui.signin;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.google.firebase.iid.FirebaseInstanceId;

public class SignUpPresenter<V extends SignUpContract.View>
        extends BasePresenter<V>
        implements SignUpContract.Presenter<V> {

    private static final String TAG = "SignUpPresenter";
    boolean isSignUpPending=false;
    boolean isSocialLoginPending=false;
    String email,pwd,name,mob,nickname;
    int terms,privacy,news;
    public LoginProfile loginProfile;
    @Override
    public void doSignup(String email, String pwd, String name, String mob, String nickname, int terms, int privacy, int news) {
        startLoading();
        isSignUpPending=true;
        this.email=email;
        this.pwd=pwd;
        this.name=name;
        this.mob=mob;
        this.nickname=nickname;
        this.terms=terms;
        this.privacy=privacy;
        this.news=news;
        StarRankingApp.getDataManager().doSignup(AppUtils.LANGUAGE_DEFAULT_VALUE, email, pwd, nickname, mob, name, terms, privacy, news, new DataManager.Callback<EmailOtpVerify>() {
            @Override
            public void onSuccess(EmailOtpVerify baseRes) {
                isSignUpPending=false;
                stopLoading();
                getView().onSuccessSignUp(baseRes);
              //  StarRankingApp.getDataManager().setBoolean(AppPreferencesHelper.PREF_IsAutoLogin,true);
               /* FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(instanceIdResult -> {
                    doRegisterDevice(AppUtils.LANGUAGE_DEFAULT_VALUE, baseRes.getLogin().getUser_id(), instanceIdResult.getToken());
                });*/
            }

            @Override
            public void onFailed(int code, String msg) {
                Log.d(TAG, "onFailed: "+msg);
                if(code!= Constants.FAIL_INTERNET_CODE){
                    isSignUpPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
//                getView().onfail(msg);
            }
        });
    }

    @Override
    public void doublecheck(String email) {
        startLoading();
        StarRankingApp.getDataManager().doubleCheckemail(AppUtils.LANGUAGE_DEFAULT_VALUE, email, new DataManager.Callback<String>() {
            @Override
            public void onSuccess(String baseRes) {
                stopLoading();
                getView().Successdoublechecked(baseRes);
            }

            @Override
            public void onFailed(int code, String msg) {
                stopLoading();
                getView().onfailEmailCheck(msg);
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
    public void getUserData() {

    }
    String socialId,loginType;
    boolean isSocialSignUpPending=false;
    @Override
    public void socialSignup(String social_id, String name, String nick_name, String email, String login_type, String mobile) {
        Log.d(TAG, "socialSignup: ");
        startLoading();
        isSocialSignUpPending=true;
        this.socialId=social_id;
        this.name=name;
        this.nickname=nick_name;
        this.email=email;
        this.loginType=login_type;
        this.mob=mobile;
        StarRankingApp.getDataManager().socialLogin(AppUtils.LANGUAGE_DEFAULT_VALUE, social_id, name, nick_name, email, login_type, mobile, new DataManager.Callback<LoginDataModel>() {
            @Override
            public void onSuccess(LoginDataModel baseRes) {
                isSocialSignUpPending=false;
                stopLoading();
                StarRankingApp.getDataManager().saveUserToPref(baseRes.getLogin());
                StarRankingApp.getDataManager().setBoolean(AppPreferencesHelper.PREF_IsAutoLogin,true);
                if (getView() == null)
                    return;
                FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(instanceIdResult -> {
                    doRegisterDevice(AppUtils.LANGUAGE_DEFAULT_VALUE, baseRes.getLogin().getUser_id(), instanceIdResult.getToken());
                });
                getView().successSocialSignup(baseRes.getLogin());
            }

            @Override
            public void onFailed(int code, String msg) {
                if(code!=Constants.FAIL_INTERNET_CODE){
                    isSocialSignUpPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }

    @Override
    public void retry() {
        super.retry();
        if(isSignUpPending){
            doSignup(email, pwd, name, mob, nickname, terms, privacy, news);
        }else if(isSocialSignUpPending){
            socialSignup(socialId,name,nickname,email,loginType,mob);
        }
    }

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
                onFailedWithConnectionLostView(code, msg);
                getView().onfailVerifySocialMedia();

            }
        });
    }

}
