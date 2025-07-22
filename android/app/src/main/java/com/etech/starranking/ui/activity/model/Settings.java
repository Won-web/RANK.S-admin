package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class Settings implements Serializable {

    @SerializedName("push_alert")
    private String push_alert;
    @SerializedName("push_sound")
    private String push_sound;
    @SerializedName("push_vibrate")
    private String push_vibrate;
    @SerializedName("user_id")
    private String user_id;

    public Settings(String push_alert, String push_sound, String push_vibrate, String user_id) {
        this.push_alert = push_alert;
        this.push_sound = push_sound;
        this.push_vibrate = push_vibrate;
        this.user_id = user_id;
    }

    public String getPush_alert() {
        return push_alert;
    }

    public void setPush_alert(String push_alert) {
        this.push_alert = push_alert;
    }

    public String getPush_sound() {
        return push_sound;
    }

    public void setPush_sound(String push_sound) {
        this.push_sound = push_sound;
    }

    public String getPush_vibrate() {
        return push_vibrate;
    }

    public void setPush_vibrate(String push_vibrate) {
        this.push_vibrate = push_vibrate;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }
}
