package com.etech.starranking.ui.activity.ui.dashboard.notice;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.NoticeList;
import com.etech.starranking.ui.activity.model.SubContestList;

import java.util.ArrayList;

public class NoticeContract {
    interface View extends BaseContractView {

        void loadData(ArrayList<NoticeList> homes);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);


    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView();

        void resetData();

        void moreData();


    }
}
