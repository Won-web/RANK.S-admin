package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class TokenDetails implements Serializable {
    @SerializedName("access_token")
    String access_token;
    @SerializedName("expires_in")
    String expires_in;
    @SerializedName("token_type")
    String token_type;
    @SerializedName("scope")
    String scope;
    @SerializedName("refresh_token")
    String refresh_token;

    public String getAccess_token() {
        return access_token;
    }

    public void setAccess_token(String access_token) {
        this.access_token = access_token;
    }

    public String getExpires_in() {
        return expires_in;
    }

    public void setExpires_in(String expires_in) {
        this.expires_in = expires_in;
    }

    public String getToken_type() {
        return token_type;
    }

    public void setToken_type(String token_type) {
        this.token_type = token_type;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public String getRefresh_token() {
        return refresh_token;
    }

    public void setRefresh_token(String refresh_token) {
        this.refresh_token = refresh_token;
    }

}
