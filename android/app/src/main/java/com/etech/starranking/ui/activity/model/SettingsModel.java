package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

public class SettingsModel {
    @SerializedName("push_setting")
    Settings push_setting;

    public SettingsModel(Settings push_setting) {
        this.push_setting = push_setting;
    }

    public Settings getPush_setting() {
        return push_setting;
    }

    public void setPush_setting(Settings push_setting) {
        this.push_setting = push_setting;
    }
}
