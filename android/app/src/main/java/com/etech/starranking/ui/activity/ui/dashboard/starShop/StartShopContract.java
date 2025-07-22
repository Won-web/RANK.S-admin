package com.etech.starranking.ui.activity.ui.dashboard.starShop;

import android.content.Context;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.GiftDetails;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.UserDetailsFromMobile;

public interface StartShopContract {
    interface View extends BaseContractView {

        void getSuccessdetailsfromMobile(UserDetailsFromMobile model);

        void getSuccessGiftSent(GiftDetails response,String receiverName,String stars);

        void successAtteanance(String msg);
        void failfromMobile();
        void onfail(String message);

        void getSuccessUserProfileAlways(LoginProfile response);

    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {
        void init();

        void attendanceCheckin(String langugae, String user_id);

        void getdetails(String mobile);

        void sendgift(String reciverid,String receiverName, String senderid,String sendername, String stars);

        void getUserProfileAlways(String user_id, String user_type);




    }
}
