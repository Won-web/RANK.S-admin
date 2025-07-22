package com.etech.starranking.ui.activity.ui.dashboard;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.GiftDetails;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.StarDetails;
import com.etech.starranking.ui.activity.model.UserDetailsFromMobile;

public interface DashboardContract {
    interface View extends BaseContractView {
        void getSuccessdetailsfromMobile(UserDetailsFromMobile model);
        void failfromMobile();

        void getSuccessGiftSent(GiftDetails response,String receiverName,String stars);

        void getSuccessUserProfileAlways(LoginProfile response);

        void onfail(String message);
    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {
        void init();

        void getdetails(String mobile);

        void sendgift(String reciverid,String receiverName, String senderid,String sendername, String stars);

        void getUserProfileAlways(String user_id, String user_type);

    }
}
