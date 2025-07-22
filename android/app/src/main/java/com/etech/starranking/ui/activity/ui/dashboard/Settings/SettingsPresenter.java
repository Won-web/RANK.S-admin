package com.etech.starranking.ui.activity.ui.dashboard.Settings;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.SettingsModel;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class SettingsPresenter<V extends SettingsContract.View>
        extends BasePresenter<V>
        implements SettingsContract.Presenter<V> {


    @Override
    public void init() {

    }

    private boolean isSendSettingsPending = false;
    private String userId, alert, sound, vibration;

    @Override
    public void sendSettings(String userid, String alert, String sound, String vibration) {
        startLoading();
        isSendSettingsPending = true;
        this.userId = userid;
        this.alert = alert;
        this.sound = sound;
        this.vibration = vibration;
        StarRankingApp.getDataManager().setSettings(AppUtils.LANGUAGE_DEFAULT_VALUE, userid, alert, sound, vibration, new DataManager.Callback<String>() {
            @Override
            public void onSuccess(String msg) {
                isSendSettingsPending = false;
                stopLoading();
                getView().onsuccessSentSetings(msg);


            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isSendSettingsPending = false;
                }
                onFailedWithConnectionLostView(code, msg);


            }
        });
    }

    private boolean isGetSettingsPending = false;

    @Override
    public void getSettings(String userid) {
        startLoading();
        this.userId = userid;
        isGetSettingsPending = true;
        StarRankingApp.getDataManager().getSettings(AppUtils.LANGUAGE_DEFAULT_VALUE, userid, new DataManager.Callback<SettingsModel>() {
            @Override
            public void onSuccess(SettingsModel baseRes) {
                isGetSettingsPending = false;

                getView().onGetingSettings(baseRes.getPush_setting());
                stopLoading();

            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isGetSettingsPending = false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }

    @Override
    public void retry() {
        super.retry();
        if (isGetSettingsPending) {
            getSettings(userId);
        } else if (isSendSettingsPending) {
            sendSettings(userId, alert, sound, vibration);
        }
    }
}
