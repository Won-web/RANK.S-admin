package com.etech.starranking.ui.activity.ui.dashboard.starShop;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class StarShopViewModel extends ViewModel {

    private MutableLiveData<String> mText;

    public StarShopViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("This is tools fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}