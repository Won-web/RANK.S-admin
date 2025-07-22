package com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.earning;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.EarningStar;

import java.util.ArrayList;

public class EarningStarContract {
    interface View extends BaseContractView {

        void loadData(ArrayList<EarningStar> stars);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);

    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView(String USER_ID);

        void resetData();

        void moreData(String userid);

    }
}
