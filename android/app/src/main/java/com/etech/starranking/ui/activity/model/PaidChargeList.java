package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class PaidChargeList implements Serializable {
    @SerializedName("plan_id")
    private String plan_id;
    @SerializedName("plan_name")
    private String plan_name;
    @SerializedName("description")
    private String description;
    @SerializedName("star")
    private String star;
    @SerializedName("price")
    private String price;
    @SerializedName("extra_star")
    private String extra_star;
    @SerializedName("status")
    private String status;
    @SerializedName("created_date")
    private String created_date;
    @SerializedName("updated_date")
    private String updated_date;
    @SerializedName("product_id")
    private String product_id;

    public PaidChargeList(String plan_id, String plan_name, String description, String star, String price, String extra_star, String status, String created_date, String updated_date) {
        this.plan_id = plan_id;
        this.plan_name = plan_name;
        this.description = description;
        this.star = star;
        this.price = price;
        this.extra_star = extra_star;
        this.status = status;
        this.created_date = created_date;
        this.updated_date = updated_date;
    }

    public String getPlan_id() {
        return plan_id;
    }

    public void setPlan_id(String plan_id) {
        this.plan_id = plan_id;
    }

    public String getPlan_name() {
        return plan_name;
    }

    public void setPlan_name(String plan_name) {
        this.plan_name = plan_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStar() {
        return star;
    }

    public void setStar(String star) {
        this.star = star;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getExtra_star() {
        return extra_star;
    }

    public void setExtra_star(String extra_star) {
        this.extra_star = extra_star;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getProduct_id() {
        return product_id;
    }

    public void setProduct_id(String product_id) {
        this.product_id = product_id;
    }
}
