package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class GiftDetailsVm implements Serializable {
    @SerializedName("star_details")
    GiftDetails stars;

    public GiftDetailsVm(GiftDetails stars) {
        this.stars = stars;
    }

    public GiftDetails getStars() {
        return stars;
    }

    public void setStars(GiftDetails stars) {
        this.stars = stars;
    }
}
