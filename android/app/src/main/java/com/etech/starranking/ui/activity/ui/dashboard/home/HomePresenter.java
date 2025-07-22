package com.etech.starranking.ui.activity.ui.dashboard.home;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.SubContestList;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.util.ArrayList;

public class HomePresenter<V extends HomeContract.View>
        extends BasePresenter<V>
        implements HomeContract.Presenter<V> {
    private Pagging<ContestSliderContents> mainSliderPagging;
    private Pagging<SubContestList> pagging;


    @Override
    public void onAttach(V baseview) {
        super.onAttach(baseview);
        mainSliderPagging = new Pagging<>();
        pagging = new Pagging<>();
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }


    @Override
    public void init() {
        if (getView() == null)
            return;
        getView().setupView(false);
        loadMoreData();
    }

    @Override
    public void resetData() {
        if (getView() == null)
            return;
        pagging = new Pagging<>();
        mainSliderPagging = new Pagging<>();
        getView().setupView(true);
        loadMoreData();
    }

    boolean isMoreDataPending = false;

    private void moreData() {
        startLoading();
        isMoreDataPending = true;
        StarRankingApp.getDataManager().getHomeSliderList(
                mainSliderPagging, AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<Pagging<ContestSliderContents>>() {
                    @Override
                    public void onSuccess(Pagging<ContestSliderContents> baseRes) {
                        isMoreDataPending = false;
                        if (getView() == null)
                            return;
                        mainSliderPagging = baseRes;

                       /* if (mainSliderPagging.getPagenumber() == 1) {
                            if (mainSliderPagging.getArrayList().size() > 0) {
                                getView().loadData(mainSliderPagging.getArrayList());
                            } else {
                                getView().setNoRecordsAvailable(true);
                            }
                        }*/
                        if (mainSliderPagging.getArrayList().size() > 0) {
                            getView().loadData(mainSliderPagging.getArrayList());
                        }
                        stopLoading();
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if (code != Constants.FAIL_INTERNET_CODE) {
                            isMoreDataPending = false;
                        }
                        if (getView() == null)
                            return;
                        getView().bannerLoadingFailed();
                        bannerLoadingFail(code,msg);
//                        HomePresenter.super.onFail(code, msg);
                    }

                });

    }

    private void bannerLoadingFail(int code, String msg) {
        if (getView() == null) return;

        getView().hideLoader();

        getView().hideConnectionLost();

        if (code == Constants.FAIL_INTERNET_CODE ) {
                getView().showConnectionLost();
        }
    }

    boolean isLoadMoreDataPending = false;

    @Override
    public void loadMoreData() {

        if (getView() == null)
            return;
        if (pagging.hasMore()) {
            pagging.setHasMore(false);
            if (pagging.getPageNumber() == 1) {
                startLoading();
            } else {
                getView().showBottomProgressBar();
            }
            isLoadMoreDataPending = true;
            StarRankingApp.getDataManager().getHomeSubContestList(pagging, AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<Pagging<SubContestList>>() {

                @Override
                public void onSuccess(Pagging<SubContestList> baseRes) {
                    isLoadMoreDataPending = false;
                    if (getView() == null)
                        return;
                    pagging = baseRes;
                    sortItems(pagging);
                    if (pagging.getPageNumber() == 2) {
                        moreData();
                        if (pagging.getArrayList().size() > 0) {
                            getView().loadSubData(pagging.getArrayList());
                        } /*else {
                            getView().setNoRecordsAvailable(true);
                        }*/
                    } else if (pagging.getArrayList().size() > 0) {
                        stopLoading();
                        getView().loadSubData(pagging.getArrayList());
                    }
                    if (!pagging.hasMore()) {
                        getView().hideBottomProgressCompletely();
                    }
                }

                @Override
                public void onFailed(int code, String msg) {
                    if (code != Constants.FAIL_INTERNET_CODE) {
                        isLoadMoreDataPending = false;
                    }
                    if (code != Constants.FAIL_INTERNET_CODE && pagging.getPageNumber() == 1) {
                        moreData();
                    }
                    if (code == Constants.FAIL_INTERNET_CODE)
                        pagging.setHasMore(true);

                    onFailedWithConnectionLostView(code, msg);
                }

            });
        }
    }

    //todo buggy implemetation of pagging
    private static final String TAG = "HomePresenter";

    private void sortItems(Pagging<SubContestList> pagging) {
        ArrayList<SubContestList> res = pagging.getArrayList();
        ArrayList<SubContestList> open = new ArrayList<>();
        ArrayList<SubContestList> preparing = new ArrayList<>();
        ArrayList<SubContestList> closed = new ArrayList<>();
        for (SubContestList contest : res) {
            Log.d(TAG, "sortItems: " + contest.getSubContestName() + contest.getSubListVotiongStatus());
            if (Constants.CONTEST_STATUS_OPEN.equals(contest.getSubListVotiongStatus())) {
                open.add(contest);
            } else if (Constants.CONTEST_STATUS_CLOSE.equals(contest.getSubListVotiongStatus())) {
                closed.add(contest);
            } else if (Constants.CONTEST_STATUS_PREPARING.equals(contest.getSubListVotiongStatus())) {
                preparing.add(contest);
            }
        }
        pagging.getArrayList().clear();
        pagging.getArrayList().addAll(open);
        pagging.getArrayList().addAll(preparing);
        pagging.getArrayList().addAll(closed);

    }

    @Override
    public void retry() {
        super.retry();
        if (isLoadMoreDataPending) {
            loadMoreData();
        }
        if (isMoreDataPending) {
            moreData();
        }
    }
}
