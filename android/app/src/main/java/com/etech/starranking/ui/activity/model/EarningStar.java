package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class EarningStar implements Serializable {
    @SerializedName("purchase_id")
    private String purchase_id;
    @SerializedName("user_id")
    private String user_id;
    @SerializedName("contest_id")
    private String contest_id;
    @SerializedName("star")
    private String star;
    @SerializedName("amount")
    private String amount;
    @SerializedName("refund")
    private String refund;
    @SerializedName("description")
    private String description;
    @SerializedName("type")
    private String type;
    @SerializedName("purchase_date")
    private String purchase_date;
    @SerializedName("created_date")
    private String created_date;
    @SerializedName("updated_date")
    private String updated_date;
    @SerializedName("contest_name")
    private String contest_name;
    @SerializedName("Sender_name")
    private String Sender_name;

    public EarningStar(String purchase_id, String user_id, String contest_id, String star, String amount, String refund, String description, String type, String purchase_date, String created_date, String updated_date, String contest_name) {
        this.purchase_id = purchase_id;
        this.user_id = user_id;
        this.contest_id = contest_id;
        this.star = star;
        this.amount = amount;
        this.refund = refund;
        this.description = description;
        this.type = type;
        this.purchase_date = purchase_date;
        this.created_date = created_date;
        this.updated_date = updated_date;
        this.contest_name = contest_name;
    }

    public String getPurchase_id() {
        return purchase_id;
    }

    public void setPurchase_id(String purchase_id) {
        this.purchase_id = purchase_id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getContest_id() {
        return contest_id;
    }

    public void setContest_id(String contest_id) {
        this.contest_id = contest_id;
    }

    public String getStar() {
        return star;
    }

    public void setStar(String star) {
        this.star = star;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getRefund() {
        return refund;
    }

    public void setRefund(String refund) {
        this.refund = refund;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getPurchase_date() {
        return purchase_date;
    }

    public void setPurchase_date(String purchase_date) {
        this.purchase_date = purchase_date;
    }

    public String getCreated_date() {
        return created_date;
    }

    public void setCreated_date(String created_date) {
        this.created_date = created_date;
    }

    public String getUpdated_date() {
        return updated_date;
    }

    public void setUpdated_date(String updated_date) {
        this.updated_date = updated_date;
    }

    public String getContest_name() {
        return contest_name;
    }

    public void setContest_name(String contest_name) {
        this.contest_name = contest_name;
    }

    public String getSender_name() {
        return Sender_name;
    }

    public void setSender_name(String sender_name) {
        Sender_name = sender_name;
    }
}
