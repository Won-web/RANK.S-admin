package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class ContestantList implements Serializable {
    @SerializedName("contestant_id")
    private String contestant_id;
    @SerializedName("name")
    private String Conetstantname;
    @SerializedName("total_vote")
    private String contestantVotes;
    @SerializedName("main_image")
    private String contestantimg;
    @SerializedName("contest_id")
    private String contestid;
    @SerializedName("previous_ranking")
    private String prevRank;
    @SerializedName("current_ranking")
    private String rank;
    @SerializedName("contest_category_id")
    private String categoryId;
    @SerializedName("thumb_image")
    private String thumb_image;


    public ContestantList(String contestant_id, String conetstantname, String contestantVotes, String contestantimg, String contestid, String rank) {
        this.contestant_id = contestant_id;
        Conetstantname = conetstantname;
        this.contestantVotes = contestantVotes;
        this.contestantimg = contestantimg;
        this.contestid = contestid;
        this.rank = rank;
    }

    public String getContestant_id() {
        return contestant_id;
    }

    public void setContestant_id(String contestant_id) {
        this.contestant_id = contestant_id;
    }

    public String getConetstantname() {
        return Conetstantname;
    }

    public void setConetstantname(String conetstantname) {
        Conetstantname = conetstantname;
    }

    public String getContestantVotes() {
        return contestantVotes;
    }

    public void setContestantVotes(String contestantVotes) {
        this.contestantVotes = contestantVotes;
    }

    public String getContestantimg() {
        return contestantimg;
    }

    public void setContestantimg(String contestantimg) {
        this.contestantimg = contestantimg;
    }

    public String getContestid() {
        return contestid;
    }

    public void setContestid(String contestid) {
        this.contestid = contestid;
    }

    public String getRank() {
        return rank;
    }

    public void setRank(String rank) {
        this.rank = rank;
    }

    public String getPrevRank() {
        return prevRank;
    }

    public void setPrevRank(String prevRank) {
        this.prevRank = prevRank;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getThumb_image() {
        return thumb_image;
    }

    public void setThumb_image(String thumb_image) {
        this.thumb_image = thumb_image;
    }
}
