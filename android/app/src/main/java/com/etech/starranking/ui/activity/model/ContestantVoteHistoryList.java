package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class ContestantVoteHistoryList implements Serializable {
    @SerializedName("voter_id")
    private String voter_id;
    @SerializedName("vote")
    private String vote;
    @SerializedName("user_type")
    private String user_type;
    @SerializedName("name")
    private String name;
    @SerializedName("main_image")
    private String main_image;
    @SerializedName("ranking")
    private String ranking;
    @SerializedName("nick_name")
    private String nick_name;

    public ContestantVoteHistoryList(String voter_id, String vote, String user_type, String name, String main_image, String ranking) {
        this.voter_id = voter_id;
        this.vote = vote;
        this.user_type = user_type;
        this.name = name;
        this.main_image = main_image;
        this.ranking = ranking;
    }

    public String getVoter_id() {
        return voter_id;
    }

    public void setVoter_id(String voter_id) {
        this.voter_id = voter_id;
    }

    public String getVote() {
        return vote;
    }

    public void setVote(String vote) {
        this.vote = vote;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMain_image() {
        return main_image;
    }

    public void setMain_image(String main_image) {
        this.main_image = main_image;
    }

    public String getRanking() {
        return ranking;
    }

    public void setRanking(String ranking) {
        this.ranking = ranking;
    }

    public String getNick_name() {
        return nick_name;
    }

    public void setNick_name(String nick_name) {
        this.nick_name = nick_name;
    }
}
