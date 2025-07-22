package com.etech.starranking.ui.activity.model;

import java.util.HashMap;

public class OtherContestantDetails {
    private HashMap<String, String> profile2;

    public OtherContestantDetails(HashMap<String, String> profile2) {
        this.profile2 = profile2;
    }

    public HashMap<String, String> getProfile2() {
        return profile2;
    }

    public void setProfile2(HashMap<String, String> profile2) {
        this.profile2 = profile2;
    }
}
