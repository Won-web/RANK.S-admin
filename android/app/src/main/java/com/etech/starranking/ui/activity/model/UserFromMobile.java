package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class UserFromMobile implements Serializable {
    @SerializedName("user_details")
    UserDetailsFromMobile user_details;

    public UserFromMobile(UserDetailsFromMobile user_details) {
        this.user_details = user_details;
    }

    public UserDetailsFromMobile getUser_details() {
        return user_details;
    }

    public void setUser_details(UserDetailsFromMobile user_details) {
        this.user_details = user_details;
    }
}