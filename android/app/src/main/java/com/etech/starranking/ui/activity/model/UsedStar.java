package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class UsedStar implements Serializable {
    @SerializedName("vote_id")
    private String vote_id;
    @SerializedName("contest_id")
    private String contest_id;
    @SerializedName("contestant_id")
    private String contestant_id;
    @SerializedName("voter_id")
    private String voter_id;
    @SerializedName("star")
    private String star;
    @SerializedName("description")
    private String description;
    @SerializedName("date")
    private String vote_date;
    @SerializedName("name")
    private String name;
    @SerializedName("contest_name")
    private String contest_name;
    @SerializedName("receiver_name")
    private String receiver_name;
    @SerializedName("type")
    private String type;

    public String getVote_id() {
        return vote_id;
    }

    public void setVote_id(String vote_id) {
        this.vote_id = vote_id;
    }

    public String getContest_id() {
        return contest_id;
    }

    public void setContest_id(String contest_id) {
        this.contest_id = contest_id;
    }

    public String getContestant_id() {
        return contestant_id;
    }

    public void setContestant_id(String contestant_id) {
        this.contestant_id = contestant_id;
    }

    public String getVoter_id() {
        return voter_id;
    }

    public void setVoter_id(String voter_id) {
        this.voter_id = voter_id;
    }

    public String getStar() {
        return star;
    }

    public void setStar(String star) {
        this.star = star;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVote_date() {
        return vote_date;
    }

    public void setVote_date(String vote_date) {
        this.vote_date = vote_date;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContest_name() {
        return contest_name;
    }

    public void setContest_name(String contest_name) {
        this.contest_name = contest_name;
    }

    public String getReceiver_name() {
        return receiver_name;
    }

    public void setReceiver_name(String receiver_name) {
        this.receiver_name = receiver_name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
