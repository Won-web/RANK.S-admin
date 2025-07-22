package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class SubContestList implements Serializable {
    @SerializedName("status")
    private String subListVotiongStatus;
    @SerializedName("contest_name")
    private String subContestName;
    @SerializedName("sub_banner")
    private String imageUrl;
    @SerializedName("contest_id")
    private String contest_id;
    @SerializedName("status_label")
    private String status_label;
    @SerializedName("vote_open_date")
    private String voteOpenDate;
    @SerializedName("vote_close_date")
    private String voteCloseDate;



    public SubContestList(String subListVotiongStatus, String subContestName, String imageUrl, String contest_id) {
        this.subListVotiongStatus = subListVotiongStatus;
        this.subContestName = subContestName;
        this.imageUrl = imageUrl;
        this.contest_id = contest_id;
    }

    public String getSubListVotiongStatus() {
        return subListVotiongStatus;
    }

    public void setSubListVotiongStatus(String subListVotiongStatus) {
        this.subListVotiongStatus = subListVotiongStatus;
    }

    public String getSubContestName() {
        return subContestName;
    }

    public void setSubContestName(String subContestName) {
        this.subContestName = subContestName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getContest_id() {
        return contest_id;
    }

    public void setContest_id(String contest_id) {
        this.contest_id = contest_id;
    }

    public String getStatus_label() {
        return status_label;
    }

    public void setStatus_label(String status_label) {
        this.status_label = status_label;
    }

    public String getVoteOpenDate() {
        return voteOpenDate;
    }

    public void setVoteOpenDate(String voteOpenDate) {
        this.voteOpenDate = voteOpenDate;
    }

    public String getVoteCloseDate() {
        return voteCloseDate;
    }

    public void setVoteCloseDate(String voteCloseDate) {
        this.voteCloseDate = voteCloseDate;
    }
}
