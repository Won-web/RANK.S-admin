package com.etech.starranking.ui.activity.ui.editProfile;

import android.net.Uri;
import android.util.Log;

import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BasePresenter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.utils.Constants;
import com.etech.starranking.utils.FileUtil;

import java.io.File;
import java.util.ArrayList;

public class EditProfilePresenter<V extends EditProfileContract.View>
        extends BasePresenter<V>
        implements EditProfileContract.Presenter<V> {

    private boolean isGetMediasPending = false;

    @Override
    public void getContestantMedias(String contestantId) {
        this.contestantId = contestantId;
        isGetMediasPending = true;
        startLoading();
        StarRankingApp.getDataManager().getContestantsImagesForEdit(contestantId, new DataManager.Callback<ArrayList<ContestantMedia>>() {
            @Override
            public void onSuccess(ArrayList<ContestantMedia> baseRes) {
                isGetMediasPending = false;
                if (getView() == null)
                    return;
                stopLoading();
                getView().loadMedias(baseRes);
            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isGetMediasPending = false;
                }
                if (getView() == null)
                    return;
                if (code == Constants.FAIL_CODE) {
                    stopLoading();
                    getView().mediaFetchFail(msg);
                    getView().loadMedias(new ArrayList<>());
                } else
                    onFailedWithConnectionLostView(code, msg);
            }
        });
    }


    private boolean isSubmitInfoPending = false;
    private String contestantId, intro;
    private Uri imageUri;
    private File profileImageFIle;
    private ArrayList<ContestantMedia> youtubeMedia;

    @Override
    public void submitInformation(String contestantId, Uri imageUri, File profileImageFile, String intro, ArrayList<ContestantMedia> youtubeMedia) {
        startLoading();
        isSubmitInfoPending = true;
        this.contestantId = contestantId;
        this.intro = intro;
        this.profileImageFIle = profileImageFile;
        this.imageUri = imageUri;
        this.youtubeMedia=youtubeMedia;
        if (profileImageFile == null && imageUri != null) {
            try {
                profileImageFile = FileUtil.from(StarRankingApp.appContext, imageUri);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        File finalProfileImageFile = profileImageFile;
        StarRankingApp.getDataManager().editContestantDetails(contestantId, imageUri, profileImageFile, intro,youtubeMedia, new DataManager.Callback<String>() {
            @Override
            public void onSuccess(String baseRes) {
                isSubmitInfoPending = false;
                if (finalProfileImageFile != null) {
                    finalProfileImageFile.delete();
                }
                if (getView() == null)
                    return;
                stopLoading();
                getView().userProfileUpdateSuccess(baseRes);

            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isSubmitInfoPending = false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }

    private boolean isDeleteMediaPending = false;
    private ContestantMedia media;

    @Override
    public void deleteMedia(ContestantMedia media) {
        this.media = media;
        isDeleteMediaPending = true;
        StarRankingApp.getDataManager().deleteContestantMedia(media.getMediaId(), new DataManager.Callback<String>() {
            @Override
            public void onSuccess(String baseRes) {
                isDeleteMediaPending = false;
                if (getView() == null)
                    return;
                stopLoading();
                getView().mediaDeleteSuccess(baseRes, media);

            }

            @Override
            public void onFailed(int code, String msg) {
                if (code != Constants.FAIL_INTERNET_CODE) {
                    isDeleteMediaPending = false;
                }
                onFailedWithConnectionLostView(code, msg);
            }
        });
    }

    @Override
    public void retry() {
        if (isSubmitInfoPending) {
            submitInformation(contestantId, imageUri, profileImageFIle, intro, youtubeMedia);
        } else if (isGetMediasPending) {
            getContestantMedias(contestantId);
        } else if (isDeleteMediaPending) {
            deleteMedia(media);
        }
         if (isUploadImagePending) {
            actualUpload();
        }
    }

    ArrayList<ContestantMedia> medias;
    ArrayList<ContestantMedia> imageWithPendingUpload = new ArrayList<>();

    @Override
    public void uploadLocalImagesToServer(ArrayList<ContestantMedia> medias) {
        this.medias = medias;

        for (int i = 0; i < medias.size(); ++i) {
            ContestantMedia media = medias.get(i);
            if (/*MEDIA_TYPE_IMAGE.equals(media.getMediaType()) &&*/ media.isLocal()) {
                if (!imageWithPendingUpload.contains(media)) {
                    imageWithPendingUpload.add(media);
                }
            }
        }
        actualUpload();
    }

    private boolean isUploadImagePending = false;
    private static final String TAG = "EditProfilePresenter";

    private void actualUpload() {
        Log.d(TAG, "actualUpload: ");
        if (imageWithPendingUpload.size() > 0) {
            startLoading();
            isUploadImagePending = true;
            ContestantMedia contestantMedia = imageWithPendingUpload.get(0);
            if (Constants.MEDIA_TYPE_VIDEO.equals(contestantMedia.getMediaType())) {
                getView().showProgressDialog();
            }
            Log.d(TAG, "actualUpload: requesting for" + contestantMedia.getMediaUri());
            if (contestantMedia.getFile() == null) {
                Log.d(TAG, "actualUpload: copying from uri to file:" + contestantMedia.getMediaUri());
                try {
                    contestantMedia.setFile(FileUtil.from(StarRankingApp.appContext, contestantMedia.getMediaUri()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            StarRankingApp.getDataManager().uploadMedia(
                    contestantId,
                    contestantMedia.getMediaUri(),
                    contestantMedia.getFile(),
                    contestantMedia.getMediaType(),
                    new DataManager.Callback<ContestantMedia>() {
                        @Override
                        public void onSuccess(ContestantMedia baseRes) {
                            Log.d(TAG, "onSuccess: response for" + contestantMedia.getMediaUri());
                            contestantMedia.setLocal(false);
                            contestantMedia.setMediaId(baseRes.getMediaId());
                            contestantMedia.setMediaPath(baseRes.getMediaPath());
                            contestantMedia.setThumbPath(baseRes.getThumbPath());
                            imageWithPendingUpload.remove(contestantMedia);
                            getView().imageUploadSuccess(contestantMedia);
                            if (contestantMedia.getFile() != null) {
                                //noinspection ResultOfMethodCallIgnored
                                contestantMedia.getFile().delete();
                                Log.d(TAG, "onSuccess: deleting uploaded media");
                                contestantMedia.setFile(null);
                                contestantMedia.setMediaUri(null);
                            }
                            actualUpload();
                        }

                        @Override
                        public void onFailed(int code, String msg) {
                            if (getView() == null)
                                return;
                            onFailedWithConnectionLostView(code, msg);
                            if (code != Constants.FAIL_INTERNET_CODE) {
                                for (int i = 0; i < imageWithPendingUpload.size(); i++) {
                                    ContestantMedia media = imageWithPendingUpload.get(i);
                                    if (media.getFile() != null) {
                                        media.getFile().delete();
                                        media.setFile(null);
                                    }
                                }

                                isUploadImagePending = false;
                                getView().mediaUploadFailed(imageWithPendingUpload);
                                imageWithPendingUpload.clear();

                            }

                        }
                    });

        } else {
            if (getView() == null)
                return;
            isUploadImagePending = false;
            stopLoading();
        }
    }
}