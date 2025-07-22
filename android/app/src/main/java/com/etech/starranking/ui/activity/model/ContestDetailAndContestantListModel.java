package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;

public class ContestDetailAndContestantListModel implements Serializable {
    @SerializedName("contest_details")
    ArrayList<ContestDetails> contestDetails;
    @SerializedName("contestant_details")
    ArrayList<ContestantList> contestantLists;
    @SerializedName("categoryItems")
    ArrayList<CategoryList> categories;


    public ContestDetailAndContestantListModel(ArrayList<ContestDetails> contestDetails, ArrayList<ContestantList> contestantLists) {
        this.contestDetails = contestDetails;
        this.contestantLists = contestantLists;
    }

    public ArrayList<ContestDetails> getContestDetails() {
        return contestDetails;
    }

    public void setContestDetails(ArrayList<ContestDetails> contestDetails) {
        this.contestDetails = contestDetails;
    }

    public ArrayList<ContestantList> getContestantLists() {
        return contestantLists;
    }

    public void setContestantLists(ArrayList<ContestantList> contestantLists) {
        this.contestantLists = contestantLists;
    }

    public ArrayList<CategoryList> getCategories() {
        return categories;
    }

    public void setCategories(ArrayList<CategoryList> categories) {
        this.categories = categories;
    }
}
