package com.etech.starranking.ui.activity.ui.contestantDetails;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestantDetailsModel;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.activity.model.GiftDetails;
import com.etech.starranking.ui.activity.model.OtherContestantDetails;
import com.etech.starranking.ui.activity.model.StarDetails;
import com.etech.starranking.ui.activity.model.UserDetailsFromMobile;

import java.util.ArrayList;

public interface ContestantContract {
    interface View extends BaseContractView {
        void failfromMobile();

        void loadOtherData(ArrayList<OtherContestantDetails> homes);

        void loadDetails(ArrayList<ContestantDetailsModel> baseresponse);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);

        void sucessfullyVotes(String vote, StarDetails response);

        void loadGallaryData(ArrayList<ContestantMedia> videos);

        void getSuccessdetailsfromMobile(UserDetailsFromMobile model);

        void getSuccessGiftSent(GiftDetails response,String receiverName,String stars);

        void noMediaFound();

    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView(String contestantid, String contestid);

        void loadContestantDetails(String cid, String cid2);

        void resetData();


        void moreGallaryData(String contestantid);

        void moreOtherData();

        void addvotecall(String contest_id, String contestantid, String voter_id, String vote, String votername);

        //        void moreCommentData();
        void getdetails(String mobile);

        void sendgift(String reciverid,String receiverName, String senderid,String sendername, String stars);

    }
}
