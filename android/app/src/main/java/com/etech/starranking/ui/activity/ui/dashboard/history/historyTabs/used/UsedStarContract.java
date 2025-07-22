package com.etech.starranking.ui.activity.ui.dashboard.history.historyTabs.used;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.EarningStar;
import com.etech.starranking.ui.activity.model.UsedStar;

import java.util.ArrayList;

public class UsedStarContract {
    interface View extends BaseContractView {

        void loadData(ArrayList<UsedStar> stars);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);

    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView(String user_id);

        void resetData();

        void moreData(String user_id);

    }
}
