package com.etech.starranking.ui.activity.ui.dashboard.home;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.SubContestList;

import java.util.ArrayList;

public class HomeContract {
    interface View extends BaseContractView {
        void loadData(ArrayList<ContestSliderContents> homes);

        void loadSubData(ArrayList<SubContestList> subContestLists);

        void showBottomProgressBar();

        void hideBottomProgressCompletely();

        void setupView(boolean isreset);

        void setNoRecordsAvailable();

        void bannerLoadingFailed();
    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void init();

        void resetData();

        //        void moreData();
        void loadMoreData();

    }
}
