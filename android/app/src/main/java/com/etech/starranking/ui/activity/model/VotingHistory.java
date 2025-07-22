package com.etech.starranking.ui.activity.model;

public class VotingHistory {
    private String Sr_No;
    private String VoterName;
    private int VoterImage;
    private String VotesAmount;

    public VotingHistory(String Sr_No, String voterName, int voterImage, String votesAmount) {
        VoterName = voterName;
        VoterImage = voterImage;
        VotesAmount = votesAmount;
        Sr_No = Sr_No;
    }

    public String getSr_No() {
        return Sr_No;
    }

    public void setSr_No(String sr_No) {
        Sr_No = sr_No;
    }

    public String getVoterName() {
        return VoterName;
    }

    public void setVoterName(String voterName) {
        VoterName = voterName;
    }

    public int getVoterImage() {
        return VoterImage;
    }

    public void setVoterImage(int voterImage) {
        VoterImage = voterImage;
    }

    public String getVotesAmount() {
        return VotesAmount;
    }

    public void setVotesAmount(String votesAmount) {
        VotesAmount = votesAmount;
    }
}
