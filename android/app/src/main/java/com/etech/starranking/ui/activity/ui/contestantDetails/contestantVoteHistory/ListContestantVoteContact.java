package com.etech.starranking.ui.activity.ui.contestantDetails.contestantVoteHistory;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.ContestantVoteHistoryList;
import com.etech.starranking.ui.activity.model.VoteListModel;

import java.util.ArrayList;

public class ListContestantVoteContact {
    public interface View extends BaseContractView {

        void loadData(VoteListModel model);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);

    }

    public interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView(String contest_id, String contesnat_id);

        void resetData();

        void moreData(String contest_id, String contesnat_id);

    }
}
