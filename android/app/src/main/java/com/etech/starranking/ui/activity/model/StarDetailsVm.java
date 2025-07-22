package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class StarDetailsVm implements Serializable {
    @SerializedName("star_details")
    StarDetails stars;

    public StarDetailsVm(StarDetails stars) {
        this.stars = stars;
    }

    public StarDetails getStars() {
        return stars;
    }

    public void setStars(StarDetails stars) {
        this.stars = stars;
    }
}
