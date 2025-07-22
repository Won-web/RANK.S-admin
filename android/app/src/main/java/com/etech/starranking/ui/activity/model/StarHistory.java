package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;

public class StarHistory implements Serializable {
    @SerializedName("usage_history")
    ArrayList<UsedStar> usage_history;
    @SerializedName("purchase_history")
    ArrayList<EarningStar> purchase_history;

    public StarHistory(ArrayList<UsedStar> usage_history, ArrayList<EarningStar> purchase_history) {
        this.usage_history = usage_history;
        this.purchase_history = purchase_history;
    }

    public ArrayList<UsedStar> getUsage_history() {
        return usage_history;
    }

    public void setUsage_history(ArrayList<UsedStar> usage_history) {
        this.usage_history = usage_history;
    }

    public ArrayList<EarningStar> getPurchase_history() {
        return purchase_history;
    }

    public void setPurchase_history(ArrayList<EarningStar> purchase_history) {
        this.purchase_history = purchase_history;
    }
}
