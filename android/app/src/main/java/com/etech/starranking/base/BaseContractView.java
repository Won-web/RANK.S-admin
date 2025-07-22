package com.etech.starranking.base;

public interface BaseContractView {

    void showLoader();

    void hideLoader();

    void showConnectionLost();

    void hideConnectionLost();

    void showError(int code, String response);
}
