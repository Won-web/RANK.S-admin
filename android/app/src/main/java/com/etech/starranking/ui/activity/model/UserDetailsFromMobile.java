package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class UserDetailsFromMobile implements Serializable {
    @SerializedName("user_id")
    String user_id;
    @SerializedName("mobile")
    String mobile;
    @SerializedName("user_type")
    String user_type;
    @SerializedName("name")
    String name;
    @SerializedName("main_image")
    String main_image;

    public UserDetailsFromMobile(String user_id, String mobile, String user_type, String name, String main_image) {
        this.user_id = user_id;
        this.mobile = mobile;
        this.user_type = user_type;
        this.name = name;
        this.main_image = main_image;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMain_image() {
        return main_image;
    }

    public void setMain_image(String main_image) {
        this.main_image = main_image;
    }
}