package com.etech.starranking.ui.activity.ui.searchResult;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.SearchList;
import com.etech.starranking.utils.Constants;

public class SearchResultPresenter<V extends SearchResultContract.View>
        extends BasePresenter<V> implements SearchResultContract.Presenter<V> {
    private String searchText;
    private Pagging<SearchList> pagging;
    private static final String TAG = "SearchResultPresenter";
    @Override
    public void search(String searchText) {
        this.searchText = searchText;
        Log.d(TAG, "search: ");
        clearPagging();
        getView().setUpView(true);
        loadMoreData();
    }

    private void clearPagging() {
        pagging = new Pagging<>();
    }

    boolean isLoadMorePending = false;

    @Override
    public void loadMoreData() {
        Log.d(TAG, "loadMoreData: ");
        if (getView() == null)
            return;
        if (pagging.hasMore()) {
            isLoadMorePending = true;
            getView().hideConnectionLost();
            getView().setNoDataFound(false);
            if (pagging.getPageNumber() == 1) {
                getView().showLoader();
            } else {
                getView().showBottomProgress();
            }
            StarRankingApp.getDataManager().getSearchResult(searchText, pagging, new DataManager.Callback<Pagging<SearchList>>() {
                @Override
                public void onSuccess(Pagging<SearchList> baseRes) {
                    isLoadMorePending = false;
                    if (getView() == null)
                        return;
                    getView().hideLoader();
                    getView().hideBottomProgress();
                    pagging = baseRes;
                    if (baseRes.getPageNumber() == 2 && baseRes.getArrayList().size() == 0) {
                        getView().setNoDataFound(true);
                    } else {
                        getView().setNoDataFound(false);

                        getView().loadDataToView(baseRes.getArrayList());
                    }
                    if (!baseRes.hasMore()) {
                        getView().hidePermanentBottomProgress();
                    }
                }

                @Override
                public void onFailed(int code, String msg) {
                    if (pagging.getPageNumber() != 1 || code != Constants.FAIL_INTERNET_CODE) {
                        isLoadMorePending = false;
                    }
                    if (getView() == null)
                        return;
//                    if (pagging.getPageNumber() == 1) {
                        onFailedWithConnectionLostView(code, msg);
                    /*} else {
                        getView().hideBottomProgress();
                        onFail(code, msg, true, false);
                    }*/
                }
            });


        }
    }

    @Override
    public void retry() {
        if (getView() == null)
            return;
        getView().hideConnectionLost();
        if (isLoadMorePending) {
            loadMoreData();
        }
    }
}
