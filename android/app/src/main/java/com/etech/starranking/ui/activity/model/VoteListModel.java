package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;

public class VoteListModel implements Serializable {
    @SerializedName("voting_history")
    ArrayList<ContestantVoteHistoryList> voteHistoryLists;
    String banner;

    public ArrayList<ContestantVoteHistoryList> getVoteHistoryLists() {
        return voteHistoryLists;
    }

    public void setVoteHistoryLists(ArrayList<ContestantVoteHistoryList> voteHistoryLists) {
        this.voteHistoryLists = voteHistoryLists;
    }

    public String getBanner() {
        return banner;
    }

    public void setBanner(String banner) {
        this.banner = banner;
    }
}
