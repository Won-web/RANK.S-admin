package com.etech.starranking.ui.activity.ui.editUserProfile;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class EditUserProfilePresenter<V extends EditUserprofileContract.View>
        extends BasePresenter<V>
        implements EditUserprofileContract.Presenter<V> {


    @Override
    public void init() {

    }

    private boolean isUpdateProfilePending = false;
    private boolean isDeleteUserAccountPending = false;
    private String userId, userType, email, mobile, name, nickName, currnetPassword, password,userIdDeleteAccount;

    @Override
    public void updateProfile(String user_id, String userType, String email, String mobile, String name, String nick_name, String current_password, String password) {
        startLoading();
        isUpdateProfilePending = true;
        this.userId = user_id;
        this.userType = userType;
        this.email = email;
        this.mobile = mobile;
        this.name = name;
        this.nickName = nick_name;
        this.currnetPassword = current_password;
        this.password = password;
        StarRankingApp.getDataManager().getUpdateUserProfile(AppUtils.LANGUAGE_DEFAULT_VALUE, user_id, userType, email, mobile, name, nick_name, current_password, password, new DataManager.Callback<String>() {
            @Override
            public void onSuccess(String baseRes) {
                isUpdateProfilePending = false;
                if (getView() == null)
                    return;

                stopLoading();
                getView().onSuccessfullyUpdated();
            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isUpdateProfilePending = false;
                }
                onFailedWithConnectionLostView(code, msg);


            }
        });
    }

    @Override
    public void deleteUserProfile(String userid) {
        startLoading();
        isDeleteUserAccountPending = true;
        this.userIdDeleteAccount = userid;
        StarRankingApp.getDataManager().deleteUserAccount(userid, new DataManager.Callback<Object>() {
            @Override
            public void onSuccess(Object baseRes) {
                isDeleteUserAccountPending = false;
                getView().onSuccessFullyDeleteAccount();
            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isDeleteUserAccountPending = false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });

    }

    @Override
    public void retry() {
        super.retry();
        if (isUpdateProfilePending) {
            updateProfile(userId, userType, email, mobile, name, nickName, currnetPassword, password);


        } else if (isDeleteUserAccountPending) {
            deleteUserProfile(userIdDeleteAccount);
        }
    }
    }
