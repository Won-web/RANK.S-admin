package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class EndTransactionModel implements Serializable {
    @SerializedName("star_details")
    StarDetails starDetails;

    public StarDetails getStarDetails() {
        return starDetails;
    }

    public void setStarDetails(StarDetails starDetails) {
        this.starDetails = starDetails;
    }
}
