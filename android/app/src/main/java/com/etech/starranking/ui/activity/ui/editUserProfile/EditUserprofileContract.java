package com.etech.starranking.ui.activity.ui.editUserProfile;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.LoginProfile;

public interface EditUserprofileContract {
    interface View extends BaseContractView {
        void onSuccessfullyUpdated();

        void onfail(String message);

        void onSuccessFullyDeleteAccount();

        void onFailedToDeleteAccount();
    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {
        void init();

        void updateProfile(String user_id, String userType, String email, String mobile,
                           String name, String nick_name,
                           String current_password, String password);

        void deleteUserProfile(String userid);

    }
}
