package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class ContestSliderContents implements Serializable {
    @SerializedName("contest_id")
    private String id;
    @SerializedName("contest_name")
    private String contestName;
    @SerializedName("main_banner")
    private String bannerImage;
//    private int bannerImage;

    public ContestSliderContents(String id, String contestName, String bannerImage) {
        this.id = id;
        this.contestName = contestName;
        this.bannerImage = bannerImage;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContestName() {
        return contestName;
    }

    public void setContestName(String contestName) {
        this.contestName = contestName;
    }

    public String getBannerImage() {
        return bannerImage;
    }

    public void setBannerImage(String bannerImage) {
        this.bannerImage = bannerImage;
    }

//
//    public int getBannerImage() {
//        return bannerImage;
//    }
//
//    public void setBannerImage(int bannerImage) {
//        this.bannerImage = bannerImage;
//    }
}
