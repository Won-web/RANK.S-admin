package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class SearchList implements Serializable {
    @SerializedName("name")
    private String contestantname;
    @SerializedName("contest_name")
    private String contestName;
    @SerializedName("main_image")
    private String profileUrl;
    @SerializedName("contestant_id")
    private String contestantId;
    @SerializedName("contest_id")
    private String contestId;

    public String getContestantId() {
        return contestantId;
    }

    public void setContestantId(String contestantId) {
        this.contestantId = contestantId;
    }

    public String getContestId() {
        return contestId;
    }

    public void setContestId(String contestId) {
        this.contestId = contestId;
    }

    public String getContestantname() {
        return contestantname;
    }

    public void setContestantname(String contestantname) {
        this.contestantname = contestantname;
    }

    public String getContestName() {
        return contestName;
    }

    public void setContestName(String contestName) {
        this.contestName = contestName;
    }

    public String getProfileUrl() {
        return profileUrl;
    }

    public void setProfileUrl(String profileUrl) {
        this.profileUrl = profileUrl;
    }
}
