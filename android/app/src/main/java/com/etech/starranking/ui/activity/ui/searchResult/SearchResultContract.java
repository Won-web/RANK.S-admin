package com.etech.starranking.ui.activity.ui.searchResult;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.SearchList;

import java.util.ArrayList;

public interface SearchResultContract {
    interface View extends BaseContractView {

        void setNoDataFound(boolean isActive);

        void setUpView(boolean isReset);

        void loadDataToView(ArrayList<SearchList> data);

        void showBottomProgress();

        void hideBottomProgress();

        void hidePermanentBottomProgress();


    }

    interface Presenter<V extends View> extends BaseContractPresenter<V> {
        void search(String searchText);

        void loadMoreData();

    }
}
