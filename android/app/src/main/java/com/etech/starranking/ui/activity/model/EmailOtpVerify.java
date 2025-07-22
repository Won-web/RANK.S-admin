package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class EmailOtpVerify implements Serializable {
    @SerializedName("status")
    private String status;
    @SerializedName("user_id")
    private String user_id;
    @SerializedName("otp")
    private String otp;

    public EmailOtpVerify(String status, String user_id, String otp) {
        this.status = status;
        this.user_id = user_id;
        this.otp = otp;
    }

    public EmailOtpVerify(String status, String user_id) {
        this.status = status;
        this.user_id = user_id;
    }

    public EmailOtpVerify() {

    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }
}
