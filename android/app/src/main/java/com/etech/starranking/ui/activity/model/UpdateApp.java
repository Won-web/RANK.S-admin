package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class UpdateApp implements Serializable {
    @SerializedName("forceUpdateApp")
    private String forceUpdateApp;
    @SerializedName("isVersionDifferent")
    private String isVersionDifferent;
    @SerializedName("MessageType")
    private String MessageType;
    @SerializedName("URL")
    private String URL;
    @SerializedName("update_button_title")
    private String update_button_title;
    @SerializedName("skip_button_title")
    private String skip_button_title;

    public UpdateApp(String forceUpdateApp, String isVersionDifferent, String messageType, String URL, String update_button_title, String skip_button_title) {
        this.forceUpdateApp = forceUpdateApp;
        this.isVersionDifferent = isVersionDifferent;
        MessageType = messageType;
        this.URL = URL;
        this.update_button_title = update_button_title;
        this.skip_button_title = skip_button_title;
    }

    public String getForceUpdateApp() {
        return forceUpdateApp;
    }

    public void setForceUpdateApp(String forceUpdateApp) {
        this.forceUpdateApp = forceUpdateApp;
    }

    public String getIsVersionDifferent() {
        return isVersionDifferent;
    }

    public void setIsVersionDifferent(String isVersionDifferent) {
        this.isVersionDifferent = isVersionDifferent;
    }

    public String getMessageType() {
        return MessageType;
    }

    public void setMessageType(String messageType) {
        MessageType = messageType;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
    }

    public String getUpdate_button_title() {
        return update_button_title;
    }

    public void setUpdate_button_title(String update_button_title) {
        this.update_button_title = update_button_title;
    }

    public String getSkip_button_title() {
        return skip_button_title;
    }

    public void setSkip_button_title(String skip_button_title) {
        this.skip_button_title = skip_button_title;
    }
}
