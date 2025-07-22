package com.etech.starranking.ui.activity.model;

import com.etech.starranking.utils.Constants;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class RestResponseModel<T> implements Serializable {
    @SerializedName(Constants.RES_CODE_KEY)
    int code;
    @SerializedName(Constants.RES_MSG_KEY)
    String message;
    @SerializedName(Constants.RES_DATA_KEY)
    T restData;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getRestData() {
        return restData;
    }

    public void setRestData(T restData) {
        this.restData = restData;
    }
}
