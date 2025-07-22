package com.etech.starranking.ui.activity.ui.contestantDetails;

import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.CommentsModel;
import com.etech.starranking.ui.activity.model.ContestantModel;
import com.etech.starranking.ui.activity.model.GiftDetailsVm;
import com.etech.starranking.ui.activity.model.OtherContestantDetails;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.activity.model.StarDetailsVm;
import com.etech.starranking.ui.activity.model.UserFromMobile;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

import java.util.ArrayList;


public class ContestantPresenter<V extends ContestantContract.View>
        extends BasePresenter<V>
        implements ContestantContract.Presenter<V> {

    Pagging<ContestantMedia> pagging;
    Pagging<OtherContestantDetails> pagging2;
    Pagging<CommentsModel> paggingComment;
    private static final String TAG = "ContestantPresenter";


    @Override
    public void onAttach(V baseview) {
        super.onAttach(baseview);
        Log.d(TAG, "onAttach() called with: baseview = [" + baseview + "]");
        pagging = new Pagging<>();
        pagging2 = new Pagging<>();
        paggingComment = new Pagging<>();
    }

    String contestantId, contestId;

    @Override
    public void initView(String contestantid, String contestid) {
        Log.d(TAG, "initView() called with: contestantid = [" + contestantid + "], contestid = [" + contestid + "]");
        this.contestantId = contestantid;
        this.contestId = contestid;
        getView().setupView(false);

        moreOtherData();
        moreGallaryData(contestantid);
        loadContestantDetails(contestantid, contestid);
    }
    boolean isLoadContestantDetailsPending=false;
    @Override
    public void loadContestantDetails(String contestantid, String contestid) {
        Log.d(TAG, "loadContestantDetails() called with: contestantid = [" + contestantid + "], contestid = [" + contestid + "]");
        startLoading();
        isLoadContestantDetailsPending=true;
        StarRankingApp.getDataManager().getContestantDetails(AppUtils.LANGUAGE_DEFAULT_VALUE, contestantid, contestid, new DataManager.Callback<ContestantModel>() {
            @Override
            public void onSuccess(ContestantModel baseRes) {
                isLoadContestantDetailsPending=false;
                if (getView() == null)
                    return;

                stopLoading();
                getView().loadDetails(baseRes.getModels());
            }

            @Override
            public void onFailed(int code, String msg) {
                if(code!=Constants.FAIL_INTERNET_CODE){
                    isLoadContestantDetailsPending=false;
                }
                onFailedWithConnectionLostView(code, msg);
            }

        });
    }

    @Override
    public void resetData() {
        Log.d(TAG, "resetData() called");
        getView().setupView(true);
        initView(contestantId, contestId);

//        moreOtherData();

//        moreCommentData();

    }

    boolean isMoreGallaryDataPending=false;
    @Override
    public void moreGallaryData(String contestantid) {
        Log.d(TAG, "moreGallaryData() called with: contestantid = [" + contestantid + "]");
        startLoading();
        isMoreGallaryDataPending=true;
        StarRankingApp.getDataManager().getContestantsImages(
                contestantid, new DataManager.Callback<ArrayList<ContestantMedia>>() {
                    @Override
                    public void onSuccess(ArrayList<ContestantMedia> baseRes) {
                        isMoreGallaryDataPending=false;
                        stopLoading();
                        if (getView() == null)
                            return;
                        getView().loadGallaryData(baseRes);

                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        Log.e("gallary", "on fail " + msg);
                        stopLoading();
                        if(code!= Constants.FAIL_INTERNET_CODE){
                            isMoreGallaryDataPending=false;
                        }
                        if (getView() == null)
                            return;
                        getView().noMediaFound();
                    }
                });
    }



    @Override
    public void moreOtherData() {
        Log.d(TAG, "moreOtherData() called");
        startLoading();
        StarRankingApp.getDataManager().getOtherContestantDetails(
                pagging2, new DataManager.Callback<Pagging>() {


                    @Override
                    public void onSuccess(Pagging baseRes) {
                        stopLoading();
                        if (getView() == null)
                            return;
                        pagging2 = baseRes;

                        if (pagging2.getPageNumber() == 1) {
                            if (pagging2.getArrayList().size() > 0) {
                                getView().loadOtherData(pagging2.getArrayList());
                            } else {
                                getView().setNoRecordsAvailable(true);
                                Log.e("no data2", "in contestantpresenter list");
                            }

                        }
                        if (pagging2.getArrayList().size() > 0) {
                            getView().loadOtherData(pagging2.getArrayList());
                        }


                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        onFail(code, msg);
                        Log.e("contestantpresenter2", "on fail " + msg);
                    }

                });


    }

    @Override
    public void addvotecall(String contest_id, String contestantid, String voter_id, String vote, String votername) {
        Log.d(TAG, "addvotecall() called with: contest_id = [" + contest_id + "], contestantid = [" + contestantid + "], voter_id = [" + voter_id + "], vote = [" + vote + "], votername = [" + votername + "]");
        startLoading();
        StarRankingApp.getDataManager().getAddVoteApi(
                AppUtils.LANGUAGE_DEFAULT_VALUE, contest_id, contestantid, voter_id, vote,
                votername, new DataManager.Callback<StarDetailsVm>() {
                    @Override
                    public void onSuccess(StarDetailsVm baseRes) {
                        if (getView() == null)
                            return;

                        stopLoading();
                        getView().sucessfullyVotes(vote, baseRes.getStars());
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        onFail(code, msg);
                    }
                });
    }

    @Override
    public void getdetails(String mobile) {
        Log.d(TAG, "getdetails() called with: mobile = [" + mobile + "]");
        startLoading();
        StarRankingApp.getDataManager().getDetailsbyPhoneNumber(mobile,
                AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<UserFromMobile>() {

                    @Override
                    public void onSuccess(UserFromMobile baseRes) {
                        if (getView() == null)
                            return;

                        stopLoading();
                        getView().getSuccessdetailsfromMobile(baseRes.getUser_details());
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        getView().failfromMobile();
                        stopLoading();
                    }
                });
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

    @Override
    public void sendgift(String reciverid, String receiverName, String senderid,String sendername, String stars) {
        Log.d(TAG, "sendgift() called with: reciverid = [" + reciverid + "], senderid = [" + senderid + "], sendername = [" + sendername + "], stars = [" + stars + "]");
        startLoading();
        StarRankingApp.getDataManager().getGiftStarApi(reciverid, senderid,sendername, stars,
                AppUtils.LANGUAGE_DEFAULT_VALUE, new DataManager.Callback<GiftDetailsVm>() {
                    @Override
                    public void onSuccess(GiftDetailsVm baseRes) {
                        if (getView() == null)
                            return;
                        stopLoading();
                        getView().getSuccessGiftSent(baseRes.getStars(),receiverName, stars);
                    }

                    @Override
                    public void onFailed(int code, String msg) {
                        Log.e("gift", "on fail " + msg);
                        onFail(code, msg);
                    }
                });
    }


    @Override
    public void retry() {
        super.retry();
        Log.d(TAG, "retry() called");
        if(isLoadContestantDetailsPending){
            loadContestantDetails(contestantId, contestId);
        }
        if(isMoreGallaryDataPending){
            moreGallaryData(contestantId);
        }
    }
}
