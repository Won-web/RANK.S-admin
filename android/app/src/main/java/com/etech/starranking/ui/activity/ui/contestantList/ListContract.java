package com.etech.starranking.ui.activity.ui.contestantList;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.CategoryList;
import com.etech.starranking.ui.activity.model.ContestDetailAndContestantListModel;
import com.etech.starranking.ui.activity.model.ContestDetails;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.StarDetails;
import com.etech.starranking.ui.activity.model.StarDetailsVm;
import com.etech.starranking.ui.adapter.ContestantCategoryListAdapter;

import java.util.ArrayList;

public class ListContract {
    public interface View extends BaseContractView {

        void loadData(ArrayList<ContestantList> homes, ArrayList<ContestDetails> homes1);

        void loadCat(ArrayList<CategoryList> cats);

        void successfulltVoted(ContestantList contestantList, String vote, StarDetails response);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);

    }

    public interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView(String contestid);

        void resetData();

        void moreData(String contestid);

        void addvotecall(String language, ContestantList contestantList, String contest_id, String contestantid, String voter_id, String vote, String votername);

        void moreCat();
    }
}
