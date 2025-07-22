package com.etech.starranking.ui.activity.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class TransactionDetails implements Serializable {
    @SerializedName("transaction_id")
    private String transaction_id;

    public String getTransaction_id() {
        return transaction_id;
    }

    public void setTransaction_id(String transaction_id) {
        this.transaction_id = transaction_id;
    }
}
