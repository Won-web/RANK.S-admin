package com.etech.starranking.ui.activity.ui.contestantList;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.CategoryList;
import com.etech.starranking.ui.activity.model.ContestDetailAndContestantListModel;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.StarDetailsVm;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.util.ArrayList;

public class ListPresenter<V extends ListContract.View>
        extends BasePresenter<V>
        implements ListContract.Presenter<V> {

    private ArrayList<ContestantList> categories;
    Pagging<CategoryList> pagging;

    @Override
    public void onAttach(V baseview) {

        super.onAttach(baseview);
        categories = new ArrayList<>();
        pagging = new Pagging<>();
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

    private String contestId = null;

    @Override
    public void initView(String contestid) {
        this.contestId = contestid;
        if (getView() == null)
            return;
        getView().setupView(false);
        moreData(contestid);

    }

    @Override
    public void resetData() {
        if (getView() == null)
            return;
        getView().setupView(true);
        moreData(contestId);


    }
    boolean isMoreDataPending =false;
    @Override
    public void moreData(String contestid) {
        startLoading();
        this.contestId=contestid;
        isMoreDataPending =true;
        getView().setNoRecordsAvailable(false);
        StarRankingApp.getDataManager().getContestContestantList(
                AppUtils.LANGUAGE_DEFAULT_VALUE, contestid, new DataManager.Callback<ContestDetailAndContestantListModel>() {
                    @Override
                    public void onSuccess(ContestDetailAndContestantListModel baseRes) {
                        isMoreDataPending=false;
                        if (getView() == null)
                            return;

                        if (baseRes.getContestantLists().size() == 0) {
                            getView().setNoRecordsAvailable(true);
                        }
                        getView().loadData(baseRes.getContestantLists(), baseRes.getContestDetails());
                        getView().loadCat(baseRes.getCategories());

                        stopLoading();
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if(code!= Constants.FAIL_INTERNET_CODE){
                            isMoreDataPending=false;
                        }
                        onFailedWithConnectionLostView(code, msg);
                    }
                });
//        StarRankingApp.getDataManager().getContestantList(
//                pagging, new DataManager.Callback<Pagging>() {
//
//
//                    @Override
//                    public void onSuccess(Pagging baseRes) {
//                        if (getView() == null)
//                            return;
//                        pagging = baseRes;
//
//                        if (pagging.getPagenumber() == 1) {
//                            if (pagging.getArrayList().size() > 0) {
//
//                            } else {
//                                getView().setNoRecordsAvailable(true);
//                            }
//
//                        }
//                        if (pagging.getArrayList().size() > 0) {
//                            getView().loadData(pagging.getArrayList());
//                        }
//                    }
//
//                    @Override
//                    public void onFailed(int code, String msg) {
//                        Log.e("Homepresenter", "on fail " + msg);
//                        //handle this
//                    }
//
//                });
    }

    @Override
    public void addvotecall(String language, ContestantList contestantList, String contest_id, String contestantid,
                            String voter_id, String vote, String votername) {
        startLoading();
        StarRankingApp.getDataManager().getAddVoteApi(
                AppUtils.LANGUAGE_DEFAULT_VALUE, contest_id, contestantid, voter_id, vote,
                votername, new DataManager.Callback<StarDetailsVm>() {
                    @Override
                    public void onSuccess(StarDetailsVm baseRes) {
                        if (getView() == null)
                            return;
                        try {
                            int votes = Integer.parseInt(contestantList.getContestantVotes());
                            votes = votes + Integer.parseInt(vote);
                            contestantList.setContestantVotes(String.valueOf(votes));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        getView().successfulltVoted(contestantList, vote, baseRes.getStars());
                        stopLoading();
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        onFail(code, msg);
                    }
                });
    }

    @Override
    public void moreCat() {
        startLoading();
        StarRankingApp.getDataManager().getContestCategory(
                pagging, new DataManager.Callback<Pagging>() {
                    @Override
                    public void onSuccess(Pagging baseRes) {
                        if (getView() == null)
                            return;
                        pagging = baseRes;

                        if (pagging.getPageNumber() == 1) {
                            if (pagging.getArrayList().size() > 0) {
                                getView().loadCat(pagging.getArrayList());
                            } else {
                                getView().setNoRecordsAvailable(true);
                            }

                        }
                        if (pagging.getArrayList().size() > 0) {
                            getView().loadCat(pagging.getArrayList());
                        }
                        stopLoading();
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        onFail(code, msg);
                        //handle this
                    }

                });
    }

//    @Override
//    public void contestData() {
//        StarRankingApp.getDataManager().getContestDetails(
//                "english", "2", new DataManager.Callback<ArrayList<ContestDetails>>() {
//                    @Override
//                    public void onSuccess(ArrayList<ContestDetails> baseRes) {
//                        getView().loadContestData(baseRes);
//                    }
//
//                    @Override
//                    public void onFailed(int code, String msg) {
//                        Log.e("Homepresenter", "on fail " + msg);
//                    }
//                });
//    }


    @Override
    public void retry() {
        super.retry();
        if(isMoreDataPending){
            moreData(contestId);
        }
    }
}
