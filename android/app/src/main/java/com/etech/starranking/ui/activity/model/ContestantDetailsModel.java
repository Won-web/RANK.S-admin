package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

public class ContestantDetailsModel implements Serializable {
    @SerializedName("contestant_id")
    String contestant_id;
    @SerializedName("user_id")
    String user_id;
    @SerializedName("name")
    String name;
    @SerializedName("nick_name")
    String nick_name;
    @SerializedName("main_image")
    String main_image;
    @SerializedName("age")
    String age;
    @SerializedName("height")
    String height;
    @SerializedName("weight")
    String weight;
    @SerializedName("profile_2")
    LinkedHashMap<String, String> profile2;
    @SerializedName("introduction")
    String introduction;
    @SerializedName("status")
    String status;
    @SerializedName("updated_date")
    String updated_date;
    @SerializedName("created_date")
    String created_date;
    @SerializedName("total_vote")
    String total_vote;
    @SerializedName("current_ranking")
    String current_ranking;
    @SerializedName("previous_ranking")
    String previous_ranking;
    @SerializedName("contest_id")
    String contest_id;
    @SerializedName("contest_name")
    String contest_name;
    @SerializedName("contest_status")
    String contest_status;

    public String getContest_name() {
        return contest_name;
    }

    public void setContest_name(String contest_name) {
        this.contest_name = contest_name;
    }

    public String getContestant_id() {
        return contestant_id;
    }

    public void setContestant_id(String contestant_id) {
        this.contestant_id = contestant_id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNick_name() {
        return nick_name;
    }

    public void setNick_name(String nick_name) {
        this.nick_name = nick_name;
    }

    public String getMain_image() {
        return main_image;
    }

    public void setMain_image(String main_image) {
        this.main_image = main_image;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getHeight() {
        return height;
    }

    public void setHeight(String height) {
        this.height = height;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public LinkedHashMap<String, String> getProfile2() {
        return profile2;
    }

    public void setProfile2(LinkedHashMap<String, String> profile2) {
        this.profile2 = profile2;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUpdated_date() {
        return updated_date;
    }

    public void setUpdated_date(String updated_date) {
        this.updated_date = updated_date;
    }

    public String getCreated_date() {
        return created_date;
    }

    public void setCreated_date(String created_date) {
        this.created_date = created_date;
    }

    public String getTotal_vote() {
        return total_vote;
    }

    public void setTotal_vote(String total_vote) {
        this.total_vote = total_vote;
    }

    public String getCurrent_ranking() {
        return current_ranking;
    }

    public void setCurrent_ranking(String current_ranking) {
        this.current_ranking = current_ranking;
    }

    public String getPrevious_ranking() {
        return previous_ranking;
    }

    public void setPrevious_ranking(String previous_ranking) {
        this.previous_ranking = previous_ranking;
    }

    public String getContest_id() {
        return contest_id;
    }

    public void setContest_id(String contest_id) {
        this.contest_id = contest_id;
    }

    public String getContest_status() {
        return contest_status;
    }

    public void setContest_status(String contest_status) {
        this.contest_status = contest_status;


    }
}
