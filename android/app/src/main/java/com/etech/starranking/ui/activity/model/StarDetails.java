package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class StarDetails implements Serializable {
    @SerializedName("remaining_star")
    String remaining_star;

    public StarDetails(String remaining_star) {
        this.remaining_star = remaining_star;
    }

    public String getRemaining_star() {
        return remaining_star;
    }

    public void setRemaining_star(String remaining_star) {
        this.remaining_star = remaining_star;
    }
}
