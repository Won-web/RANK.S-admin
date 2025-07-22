package com.etech.starranking.ui.activity.ui.createPassword;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.ui.forgotPassword.ForgotPasswordContract;

public class CreatePasswordContract {
    interface View extends BaseContractView {
        void onSuccessCreateNewPassword();
        void onfail(String message);
    }
    interface Presenter<V extends CreatePasswordContract.View> extends BaseContractPresenter<V> {
        void createNewPassword(String userId,String password);
    }
}
