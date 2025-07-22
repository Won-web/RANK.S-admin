package com.etech.starranking.ui.activity.ui.contestantDetails.contestantVoteHistory;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.ContestantVoteHistoryList;
import com.etech.starranking.ui.activity.model.StarHistory;
import com.etech.starranking.ui.activity.model.VoteListModel;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.util.ArrayList;


public class ListContestantVoteHistoryPresenter<V extends ListContestantVoteContact.View>
        extends BasePresenter<V>
        implements ListContestantVoteContact.Presenter<V> {


    @Override
    public void onAttach(V baseview) {

        super.onAttach(baseview);
    }

    private String contestId, contestantId;

    @Override
    public void initView(String contest_id, String contesnat_id) {
        this.contestId = contest_id;
        this.contestantId = contesnat_id;
        getView().setupView(false);
        moreData(contest_id, contesnat_id);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

    @Override
    public void resetData() {
        getView().setupView(true);
        moreData(contestId, contestantId);
    }

    boolean isMoreDataPending = false;

    @Override
    public void moreData(String contest_id, String contestant_id) {
        startLoading();
        isMoreDataPending = true;
        getView().setNoRecordsAvailable(false);
        StarRankingApp.getDataManager().getContestantVoteList(AppUtils.LANGUAGE_DEFAULT_VALUE, contest_id, contestant_id,
                new DataManager.Callback<VoteListModel>() {
                    @Override
                    public void onSuccess(VoteListModel baseRes) {
                        isMoreDataPending=false;
                        if (getView() == null)
                            return;
                        stopLoading();
                        getView().loadData(baseRes);
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        if(code!=Constants.FAIL_INTERNET_CODE){
                            isMoreDataPending=false;
                        }
                        if (getView() == null)
                            return;
                        if (code == Constants.FAIL_CODE) {
                            getView().setNoRecordsAvailable(true);
                        }
                        onFailedWithConnectionLostView(code, msg);
                    }
                });
    }

    @Override
    public void retry() {
        super.retry();
        if(isMoreDataPending){
            moreData(contestId, contestantId);
        }
    }
}
