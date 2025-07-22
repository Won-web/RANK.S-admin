package com.etech.starranking.ui.activity.ui.dashboard.Settings;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.Settings;
import com.etech.starranking.ui.activity.model.SettingsModel;

public interface SettingsContract {
    interface View extends BaseContractView {
        void onGetingSettings(Settings model);
        void onsuccessSentSetings(String msg);

    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {
        void init();

        void sendSettings(String userid, String alert, String sound, String vibrate);

        void getSettings(String userid);
    }
}
