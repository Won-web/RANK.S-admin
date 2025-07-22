package com.etech.starranking.base;

public interface BaseContractPresenter<V extends BaseContractView> {
    void onAttach(V baseview);

    void onDetach();

    void retry();

    V getView();
}
