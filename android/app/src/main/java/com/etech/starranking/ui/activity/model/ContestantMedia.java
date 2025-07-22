package com.etech.starranking.ui.activity.model;

import android.net.Uri;

import com.etech.starranking.utils.Constants;
import com.google.gson.annotations.SerializedName;

import java.io.File;
import java.io.Serializable;

public class ContestantMedia implements Serializable {

    @SerializedName("media_id")
    private String mediaId;
    @SerializedName("contestant_id")
    private String contestantId;
    @SerializedName("media_path")
    private String mediaPath;
    @SerializedName("thumb_path")
    private String thumbPath;
    @SerializedName("media_type")
    private String mediaType;
    @SerializedName("vedio_id")
    private String vedioId;
    private boolean isLocal = false;
    private Uri mediaUri;
    private String syncStatus = Constants.SYNC_PENDING;
    private File file;


    public String getMediaId() {
        return mediaId;
    }

    public void setMediaId(String mediaId) {
        this.mediaId = mediaId;
    }

    public String getContestantId() {
        return contestantId;
    }

    public void setContestantId(String contestantId) {
        this.contestantId = contestantId;
    }

    public String getMediaPath() {
        return mediaPath;
    }

    public void setMediaPath(String mediaPath) {
        this.mediaPath = mediaPath;
    }

    public String getThumbPath() {
        return thumbPath;
    }

    public void setThumbPath(String thumbPath) {
        this.thumbPath = thumbPath;
    }

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }

    public boolean isLocal() {
        return isLocal;
    }

    public void setLocal(boolean local) {
        isLocal = local;
    }

    public Uri getMediaUri() {
        return mediaUri;
    }

    public void setMediaUri(Uri mediaUri) {
        this.mediaUri = mediaUri;
    }

    public String getSyncStatus() {
        return syncStatus;
    }

    public void setSyncStatus(String syncStatus) {
        this.syncStatus = syncStatus;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getVedioId() {
        return vedioId;
    }

    public void setVedioId(String vedioId) {
        this.vedioId = vedioId;
    }
}
