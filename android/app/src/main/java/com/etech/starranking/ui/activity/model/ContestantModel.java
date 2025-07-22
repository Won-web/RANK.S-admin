package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;

public class ContestantModel implements Serializable {
    @SerializedName("contestant_details")
    ArrayList<ContestantDetailsModel> models;

    public ContestantModel(ArrayList<ContestantDetailsModel> models) {
        this.models = models;
    }

    public ArrayList<ContestantDetailsModel> getModels() {
        return models;
    }

    public void setModels(ArrayList<ContestantDetailsModel> models) {
        this.models = models;
    }
}
