package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class NoticeList implements Serializable {
    @SerializedName("notice_id")
    private String apns_master_id;
    @SerializedName("notice_title")
    private String message_title;
    @SerializedName("notice_description")
    private String message;
    @SerializedName("message_type")
    private String message_type;
    @SerializedName("sender_id")
    private String sender_id;
    @SerializedName("notice_date")
    private String created_date;
    @SerializedName("web_view_url")
    private String web_view_url;

    public String getWeb_view_url() {
        return web_view_url;
    }

    public void setWeb_view_url(String web_view_url) {
        this.web_view_url = web_view_url;
    }

    public NoticeList(String apns_master_id, String message_title, String message, String message_type, String sender_id, String created_date) {
        this.apns_master_id = apns_master_id;
        this.message_title = message_title;
        this.message = message;
        this.message_type = message_type;
        this.sender_id = sender_id;
        this.created_date = created_date;
    }

    public String getApns_master_id() {
        return apns_master_id;
    }

    public void setApns_master_id(String apns_master_id) {
        this.apns_master_id = apns_master_id;
    }

    public String getMessage_title() {
        return message_title;
    }

    public void setMessage_title(String message_title) {
        this.message_title = message_title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getMessage_type() {
        return message_type;
    }

    public void setMessage_type(String message_type) {
        this.message_type = message_type;
    }

    public String getSender_id() {
        return sender_id;
    }

    public void setSender_id(String sender_id) {
        this.sender_id = sender_id;
    }

    public String getCreated_date() {
        return created_date;
    }

    public void setCreated_date(String created_date) {
        this.created_date = created_date;
    }
}
