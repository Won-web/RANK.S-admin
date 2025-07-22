package com.etech.starranking.data;


import android.net.Uri;

import com.etech.starranking.data.database.room.DbHelper;
import com.etech.starranking.data.network.ApiHelper;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.data.prefs.PreferencesHelper;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.activity.model.SearchList;
import com.etech.starranking.ui.activity.model.SubContestList;

import java.io.File;
import java.util.ArrayList;

public interface DataManager extends ApiHelper, DbHelper, PreferencesHelper {

    void getHomeSubContestList(Pagging<SubContestList> pagging, String language,
                               DataManager.Callback<Pagging<SubContestList>> homcallback);

    void getHomeSliderList(Pagging<ContestSliderContents> pagging, String language,
                           DataManager.Callback<Pagging<ContestSliderContents>> homcallback);
    //  void getContestantList(String langugae, String contest_id, Callback<ArrayList<ContestantList>> callback);

    interface Callback<V> {
        void onSuccess(V baseRes);

        void onFailed(int code, String msg);
    }

    void getSearchResult(String searchTerm, Pagging<SearchList> pagging, DataManager.Callback<Pagging<SearchList>> onCallback);

    void editContestantDetails(String contestantId, Uri imageUri, File profileImageFile, String introduction, ArrayList<ContestantMedia> youtubeMedia, Callback<String> callback);

    void getContestantsImagesForEdit(String contestantId,
                                     DataManager.Callback<ArrayList<ContestantMedia>> callback);

    void deleteContestantMedia(String mediaId, DataManager.Callback<String> callback);

    void getContestantsImages(String contestantId,
                              DataManager.Callback<ArrayList<ContestantMedia>> callback);

    void uploadMedia(String contestantId,
                     Uri uriToFile,
                     File file,
                     String mediaType,
                     DataManager.Callback<ContestantMedia> callback);

    String getLanguage();

    void logout();

    String getFreeChargingUrl();
    String getShopUrl();
    String getCouponUrl();
    Uri getAdUrl();

    String getUserIdx();

}
