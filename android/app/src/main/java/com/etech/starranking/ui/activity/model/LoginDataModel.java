package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;

public class LoginDataModel implements Serializable {
    @SerializedName("profile_details")
    LoginProfile login;

    @SerializedName("token_data")
    TokenDetails tokenDetails;

    public LoginDataModel(LoginProfile login) {
        this.login = login;
    }

    public LoginProfile getLogin() {
        return login;
    }

    public void setLogin(LoginProfile login) {
        this.login = login;
    }

    public TokenDetails getTokenDetails() {
        return tokenDetails;
    }

    public void setLogin(TokenDetails tokenDetail) {
        this.tokenDetails = tokenDetail;
    }
}
