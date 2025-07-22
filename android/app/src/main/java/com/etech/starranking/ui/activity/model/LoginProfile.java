package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class LoginProfile implements Serializable {
    @SerializedName("user_id")
    String user_id;
    @SerializedName("email")
    String email;
    @SerializedName("mobile")
    String mobile;
    @SerializedName("user_type")
    String user_type;
    @SerializedName("is_autologin")
    String is_autologin;
    @SerializedName("social_id")
    String social_id;
    @SerializedName("login_type")
    String login_type;
    @SerializedName("name")
    String name;
    @SerializedName("nick_name")
    String nick_name;
    @SerializedName("main_image")
    String main_image;
    @SerializedName("remaining_star")
    String remaining_star;
   @SerializedName("otp_for")
   String otpFor;

    public LoginProfile() {
    }

    public LoginProfile(String user_id, String email, String mobile, String user_type, String is_autologin, String social_id, String login_type, String name, String nick_name, String main_image, String remaining_star, String otpFor) {
        this.user_id = user_id;
        this.email = email;
        this.mobile = mobile;
        this.user_type = user_type;
        this.is_autologin = is_autologin;
        this.social_id = social_id;
        this.login_type = login_type;
        this.name = name;
        this.nick_name = nick_name;
        this.main_image = main_image;
        this.remaining_star = remaining_star;
        this.otpFor = otpFor;
    }

    /*public LoginProfile(String user_id, String email, String mobile, String user_type, String is_autologin, String social_id, String login_type, String name, String nick_name, String main_image, String remaining_star) {
        this.user_id = user_id;
        this.email = email;
        this.mobile = mobile;
        this.user_type = user_type;
        this.is_autologin = is_autologin;
        this.social_id = social_id;
        this.login_type = login_type;
        this.name = name;
        this.nick_name = nick_name;
        this.main_image = main_image;
        this.remaining_star = remaining_star;
    }*/

    public String getOtpFor() {
        return otpFor;
    }

    public void setOtpFor(String otpFor) {
        this.otpFor = otpFor;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public String getIs_autologin() {
        return is_autologin;
    }

    public void setIs_autologin(String is_autologin) {
        this.is_autologin = is_autologin;
    }

    public String getLogin_type() {
        return login_type;
    }

    public void setLogin_type(String login_type) {
        this.login_type = login_type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNick_name() {
        return nick_name;
    }

    public void setNick_name(String nick_name) {
        this.nick_name = nick_name;
    }

    public String getMain_image() {
        return main_image;
    }

    public void setMain_image(String main_image) {
        this.main_image = main_image;
    }

    public String getRemaining_star() {
        return remaining_star;
    }

    public void setRemaining_star(String remaining_star) {
        this.remaining_star = remaining_star;
    }

    public String getSocial_id() {
        return social_id;
    }

    public void setSocial_id(String social_id) {
        this.social_id = social_id;
    }
}
