package com.etech.starranking.ui.activity.ui.createPassword;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.ui.forgotPassword.ForgotPasswordContract;
import com.etech.starranking.utils.Constants;

public class CreatePasswordPresenter <V extends CreatePasswordContract.View>
        extends BasePresenter<V>
        implements CreatePasswordContract.Presenter<V>{

    boolean isCreateNewPasswordPending=false;
    String userId,password;
    @Override
    public void createNewPassword(String userId, String password) {
        this.userId=userId;
        this.password=password;
        isCreateNewPasswordPending=true;
        startLoading();;
        StarRankingApp.getDataManager().doCreateNewPassword(userId, password, new DataManager.Callback<Object>() {
            @Override
            public void onSuccess(Object baseRes) {
                stopLoading();
                isCreateNewPasswordPending=false;
                getView().onSuccessCreateNewPassword();
            }

            @Override
            public void onFailed(int code, String msg) {
                stopLoading();
                if(code!= Constants.FAIL_INTERNET_CODE){
                    isCreateNewPasswordPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }
    @Override
    public void retry() {
        super.retry();
        if (isCreateNewPasswordPending) {
            createNewPassword(userId,password);
        }
    }
}
