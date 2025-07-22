package com.etech.starranking.ui.activity.ui.dashboard.starShop.starTabs;

import android.app.Activity;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestDetails;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.PaidChargeList;

import java.util.ArrayList;

public class PaidChargingContract {
    public interface View extends BaseContractView {

        void loadData(ArrayList<PaidChargeList> data);

        void setupView(boolean isreset);

        void setNoRecordsAvailable(boolean noRecords);

        void buyFailed(String message);

        void purchaseSuccess(String baseRes);
    }

    public interface Presenter<V extends View> extends BaseContractPresenter<V> {

        void initView();

        void resetData();

        void moreData();

        void buy(PaidChargeList model, Activity activity,String contestId);
    }
}
