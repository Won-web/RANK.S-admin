package com.iknow.android.features.trim;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.FragmentActivity;

import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Window;
import android.view.WindowManager;

import com.iknow.android.R;
import com.iknow.android.databinding.ActivityVideoTrimBinding;
import com.iknow.android.features.common.ui.BaseActivity;
import com.iknow.android.interfaces.VideoTrimListener;
import com.iknow.android.utils.ToastUtil;

/**
 * Author：J.Chou
 * Date：  2016.08.01 2:23 PM
 * Email： who_know_me@163.com
 * Describe:
 */
public class VideoTrimmerActivity extends BaseActivity implements VideoTrimListener {

    private static final String TAG = "jason";
    private static final String VIDEO_PATH_KEY = "video-file-path";
    private static final String VIDEO_URI_KEY = "video-file-uri";
    private static final String VIDEO_OUT_FILE_PATH = "video-out-file";
    private static final String COMPRESSED_VIDEO_FILE_NAME = "compress.mp4";
    public static final int VIDEO_TRIM_REQUEST_CODE = 0x001;
    private ActivityVideoTrimBinding mBinding;
    private ProgressDialog mProgressDialog;

    public static Intent call(FragmentActivity from, String videoPath,String uri, String outFile) {
        if (!TextUtils.isEmpty(videoPath)) {
            Bundle bundle = new Bundle();
            bundle.putString(VIDEO_PATH_KEY, videoPath);
            bundle.putString(VIDEO_URI_KEY,uri);
            bundle.putString(VIDEO_OUT_FILE_PATH, outFile);
            Intent intent = new Intent(from, VideoTrimmerActivity.class);
            intent.putExtras(bundle);
            return intent;
        }
        return null;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initUI() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_video_trim);
        Bundle bd = getIntent().getExtras();
        String path = "";
        String uri="";
        String outFile="";
        if (bd != null) {
            path = bd.getString(VIDEO_PATH_KEY);
            uri=bd.getString(VIDEO_URI_KEY);
            outFile=bd.getString(VIDEO_OUT_FILE_PATH);
        }
        if (mBinding.trimmerView != null) {
            mBinding.trimmerView.setOnTrimVideoListener(this);
            mBinding.trimmerView.initVideoByURI(Uri.parse(uri),path);
            mBinding.trimmerView.setOutputFile(outFile);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mBinding.trimmerView.onVideoPause();
        mBinding.trimmerView.setRestoreState(true);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mBinding.trimmerView.onDestroy();
    }

    @Override
    public void onStartTrim() {
        buildDialog(getResources().getString(R.string.trimming)).show();
    }

    @Override
    public void onFinishTrim(String in) {
        if (mProgressDialog.isShowing()) mProgressDialog.dismiss();
        ToastUtil.longShow(this, getString(R.string.trimmed_done));
        setResult(Activity.RESULT_OK);
        finish();
        //TODO: please handle your trimmed video url here!!!
        //String out = StorageUtil.getCacheDir() + File.separator + COMPRESSED_VIDEO_FILE_NAME;
        //buildDialog(getResources().getString(R.string.compressing)).show();
        //VideoCompressor.compress(this, in, out, new VideoCompressListener() {
        //  @Override public void onSuccess(String message) {
        //  }
        //
        //  @Override public void onFailure(String message) {
        //  }
        //
        //  @Override public void onFinish() {
        //    if (mProgressDialog.isShowing()) mProgressDialog.dismiss();
        //    finish();
        //  }
        //});
    }

    @Override
    public void onCancel() {
        mBinding.trimmerView.onDestroy();
      setResult(Activity.RESULT_CANCELED);
        finish();
    }

    private ProgressDialog buildDialog(String msg) {
        if (mProgressDialog == null) {
            mProgressDialog = ProgressDialog.show(this, "", msg);
        }
        mProgressDialog.setMessage(msg);
        return mProgressDialog;
    }
}
