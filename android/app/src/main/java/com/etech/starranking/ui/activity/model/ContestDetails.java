package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class ContestDetails implements Serializable {
    @SerializedName("contest_id")
    private String contest_id;
    @SerializedName("contest_name")
    private String contest_name;
    @SerializedName("main_banner")
    private String main_banner;
    @SerializedName("sub_banner")
    private String sub_banner;
    @SerializedName("web_page_url")
    private String web_view_url;
    @SerializedName("home_page")
    private String home_page;
    @SerializedName("status")
    private String status;

    public ContestDetails(String contest_id, String contest_name,
                          String main_banner, String sub_banner,
                          String web_view_url, String home_page) {
        this.contest_id = contest_id;
        this.contest_name = contest_name;
        this.main_banner = main_banner;
        this.sub_banner = sub_banner;
        this.web_view_url = web_view_url;
        this.home_page = home_page;
    }

    public String getContest_id() {
        return contest_id;
    }

    public void setContest_id(String contest_id) {
        this.contest_id = contest_id;
    }

    public String getContest_name() {
        return contest_name;
    }

    public void setContest_name(String contest_name) {
        this.contest_name = contest_name;
    }

    public String getMain_banner() {
        return main_banner;
    }

    public void setMain_banner(String main_banner) {
        this.main_banner = main_banner;
    }

    public String getSub_banner() {
        return sub_banner;
    }

    public void setSub_banner(String sub_banner) {
        this.sub_banner = sub_banner;
    }

    public String getWeb_view_url() {
        return web_view_url;
    }

    public void setWeb_view_url(String web_view_url) {
        this.web_view_url = web_view_url;
    }

    public String getHome_page() {
        return home_page;
    }

    public void setHome_page(String home_page) {
        this.home_page = home_page;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
