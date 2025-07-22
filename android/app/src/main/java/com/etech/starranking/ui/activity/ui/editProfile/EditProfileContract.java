package com.etech.starranking.ui.activity.ui.editProfile;

import android.net.Uri;

import com.etech.starranking.base.BaseContractPresenter;
import com.etech.starranking.base.BaseContractView;
import com.etech.starranking.ui.activity.model.ContestantMedia;

import java.io.File;
import java.util.ArrayList;

public class EditProfileContract {
    public interface View extends BaseContractView {
        void loadMedias(ArrayList<ContestantMedia> cats);

        void mediaFetchFail(String s);

        //        void setupView(boolean isreset);
//        void setNoRecordsAvailable(boolean noRecords);
        void mediaDeleteSuccess(String message, ContestantMedia media);

        void userProfileUpdateSuccess(String message);

        void imageUploadSuccess(ContestantMedia media);

        void mediaUploadFailed(ArrayList<ContestantMedia> contestantMedias);

        void showProgressDialog();
    }

    public interface Presenter<V extends EditProfileContract.View> extends BaseContractPresenter<V> {

        void getContestantMedias(String contestantId);

        void submitInformation(String contestantId, Uri imageUri, File profileImageFile, String intro, ArrayList<ContestantMedia> youtubeMedia);

        void deleteMedia(ContestantMedia media);

        void uploadLocalImagesToServer(ArrayList<ContestantMedia> medias);

        //rename
        void retry();
    }
}
