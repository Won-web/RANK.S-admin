package com.etech.starranking.ui.activity.ui.dashboard.notification;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.NotificationsList;

import java.util.ArrayList;

public class NotificationContract {
    interface View extends BaseContractView {

        void loadData(ArrayList<NotificationsList> homes);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);


    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView(String user_id);

        void resetData();

        void moreData(String user_id);


    }
}
