package com.etech.starranking.base;


import com.etech.starranking.utils.Constants;

public class BasePresenter<V extends BaseContractView>
        implements BaseContractPresenter<V> {
    V baseview;

    @Override
    public V getView() {
        return baseview;
    }


    @Override
    public void onAttach(V baseview) {
        this.baseview = baseview;
    }

    @Override
    public void onDetach() {
        baseview = null;
    }

    protected void startLoading() {
        if (getView() == null) return;
        getView().showLoader();
        getView().hideConnectionLost();

    }

    protected void stopLoading() {
        if (getView() == null) return;
        getView().hideLoader();
        getView().hideConnectionLost();
    }

    protected void onFail(int code, String msg) {
        onFail(code, msg, true, false);
    }

    protected void onFail(int code, String msg, boolean isDialogShown, boolean isConnectionview) {
        if (getView() == null) return;

        getView().hideLoader();

        getView().hideConnectionLost();

        if (code == Constants.FAIL_CODE) {
            getView().showError(code, msg);
        } else {
            if (code == Constants.FAIL_INTERNET_CODE && isConnectionview) {
                getView().showConnectionLost();
            }
            if (isDialogShown)
                getView().showError(code, msg);
        }
    }

    protected void onFailedWithConnectionLostView(int code,String msg){
        onFail(code, msg,false,true);
    }

    @Override
    public void retry() {

    }
}
