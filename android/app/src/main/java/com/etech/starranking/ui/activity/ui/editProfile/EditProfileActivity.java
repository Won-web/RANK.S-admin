package com.etech.starranking.ui.activity.ui.editProfile;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.core.content.FileProvider;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.GridLayoutManager;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.databinding.LayoutEditProfileBinding;
import com.etech.starranking.ui.activity.model.ContestantDetailsModel;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.adapter.ContestantMediaAdapter;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.etech.starranking.utils.FileUtil;
//import com.iknow.android.features.trim.VideoTrimmerActivity;

import java.io.File;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.etech.starranking.utils.Constants.MAX_MEDIA_IMAGE_COUNT;
import static com.etech.starranking.utils.Constants.MAX_MEDIA_VIDEO_COUNT;
import static com.etech.starranking.utils.Constants.MAX_VIDEO_LENGTH;
import static com.etech.starranking.utils.Constants.MEDIA_TYPE_IMAGE;
import static com.etech.starranking.utils.Constants.MEDIA_TYPE_VIDEO;

@SuppressWarnings("Convert2Lambda")
public class EditProfileActivity extends BaseActivity implements EditProfileContract.View {

    //todo trim videos
    //todo optimization of whole process
    //todo local delete mechanism
    //todo after submit add local medias to db and start sync
// todo add item in response from local datbase
    public static String ARG_CONTESTANT_DETAILS = "arg_ContestantDetails_EditProfileActivity";
    private static final String TAG = "EditProfileActivity";

    private static final int TAKE_PHOTO_FOR_PROFILE_CODE = 124;
    private static final int PICK_PROFILE_IMAGE_CODE = 125;
    private static final int TAKE_PHOTO_FOR_MEDIA_CODE = 126;
    private static final int PICK_IMAGES_FOR_MEDIA_CODE = 127;
    private static final int CAPTURE_VIDEO_FOR_MEDIA_CODE = 128;
    private static final int PICK_VIDEO_FOR_MEDIA_CODE = 129;
    private static final int TRIM_VIDEO_CODE = 130;

    LayoutEditProfileBinding binding;
    EditProfileContract.Presenter<EditProfileContract.View> presenter;
    ContestantMediaAdapter adapter;
    ContestantDetailsModel contestantDetailsModel;
    ArrayList<ContestantMedia> localMedias = new ArrayList<>();
    ArrayList<ContestantMedia> youtubeMedia, uploadCopy;
    Uri profileImageUri, mediaImageCaptureUri, mediaVideoCaptureUri;
    File profileImageFile, mediaImageCaptureFile, mediaVideoCaptureFile;
    ProgressDialog progressDialog;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(EditProfileActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.layout_edit_profile);
        setupView(binding.extraViews);
        getArguments();
        initPresenter();
        initUI();
    }

    private void getArguments() {
        //noinspection ConstantConditions
        contestantDetailsModel = (ContestantDetailsModel) getIntent().getExtras().getSerializable(ARG_CONTESTANT_DETAILS);
    }

    private void initPresenter() {
        presenter = new EditProfilePresenter<>();
        presenter.onAttach(this);
        presenter.getContestantMedias(contestantDetailsModel.getContestant_id());
    }

    @SuppressWarnings("ConstantConditions")
    private void initUI() {
        AppUtils.setImageUrl(this, contestantDetailsModel.getMain_image(), binding.ivProfileImg);
        if (contestantDetailsModel.getIntroduction() == null || contestantDetailsModel.getIntroduction().isEmpty()) {
            binding.txtIntro.setText(R.string.str_no_msg);
        } else {
            binding.txtIntro.setText(contestantDetailsModel.getIntroduction());
        }
        setClickListeners();
    }

    private void setClickListeners() {
        binding.btndelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                binding.txtIntro.setText("");
            }
        });
        binding.tool.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(EditProfileActivity.this);
            }
        });
        binding.tool.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.btnchangeProfilepic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changeProfileClicked();
            }
        });
        binding.btnSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isValidData()) {
                    setDataInPojo();

                    presenter.submitInformation(contestantDetailsModel.getContestant_id(), profileImageUri, profileImageFile, binding.txtIntro.getText().toString(), uploadCopy);
                }
            }
        });
        binding.btnClear1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                binding.etyt1.setText(null);
            }
        });
        binding.btnClear2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                binding.etyt2.setText(null);
            }
        });
        binding.btnClear3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                binding.etyt3.setText(null);
            }
        });
    }

    private void setDataInPojo() {
        uploadCopy = new ArrayList<>();
        if (binding.etyt1.getText() != null && !binding.etyt1.getText().toString().trim().isEmpty()) {
            ContestantMedia media = new ContestantMedia();
            if (youtubeMedia.size() > 0) {
                media = youtubeMedia.get(0);
            }
            media.setMediaPath(binding.etyt1.getText().toString().trim());
            uploadCopy.add(media);
        } else {
            if (youtubeMedia.size() > 0) {
                ContestantMedia media = youtubeMedia.get(0);
                media.setMediaPath("");
                uploadCopy.add(media);
            }

        }
        if (binding.etyt2.getText() != null && !binding.etyt2.getText().toString().trim().isEmpty()) {
            ContestantMedia media = new ContestantMedia();
            if (youtubeMedia.size() > 1) {
                media = youtubeMedia.get(1);
            }
            media.setMediaPath(binding.etyt2.getText().toString().trim());
            uploadCopy.add(media);
        } else {
            if (youtubeMedia.size() > 1) {
                ContestantMedia media = youtubeMedia.get(1);
                media.setMediaPath("");
                uploadCopy.add(media);
            }

        }
        if (binding.etyt3.getText() != null && !binding.etyt3.getText().toString().trim().isEmpty()) {
            ContestantMedia media = new ContestantMedia();
            if (youtubeMedia.size() > 2) {
                media = youtubeMedia.get(2);
            }
            media.setMediaPath(binding.etyt3.getText().toString().trim());
            uploadCopy.add(media);
        } else {
            if (youtubeMedia.size() > 2) {
                ContestantMedia media = youtubeMedia.get(2);
                media.setMediaPath("");
                uploadCopy.add(media);
            }

        }
    }

    private boolean isValidData() {
        boolean isValid = true;
  /*      if (binding.etyt1.getText() != null && !binding.etyt1.getText().toString().trim().isEmpty()) {
            if (!isValidUrl(binding.etyt1.getText().toString().trim())) {
                isValid = false;
            }
        }
        if (binding.etyt2.getText() != null && !binding.etyt2.getText().toString().trim().isEmpty()) {
            if (!isValidUrl(binding.etyt2.getText().toString().trim())) {
                isValid = false;
            }
        }
        if (binding.etyt3.getText() != null && !binding.etyt3.getText().toString().trim().isEmpty()) {
            if (!isValidUrl(binding.etyt3.getText().toString().trim())) {
                isValid = false;
            }
        }

        if (!isValid)
            AppUtils.setToast(this, getString(R.string.str_val_youtube_link));*/

        return isValid;
    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    boolean isValidUrl(String url) {
        String pattern = "(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|conwatch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%\u200C\u200B2F|youtu.be%2F|%2Fv%2F)[^#\\&\\?\\n]*";
        Pattern compiledPattern = Pattern.compile(pattern);
        //url is youtube url for which you want to extract the id.
        Matcher matcher = compiledPattern.matcher(url);
        if (matcher.find()) {
            return true;
        }
        return false;
    }

    private void changeProfileClicked() {
        String[] choices = new String[]{
                getString(R.string.str_take_pic),
                getString(R.string.str_pick_gallary)
        };
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setItems(choices, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                switch (which) {
                    case 0:
                        takeNewProfilePic();
                        break;
                    case 1:
                        pickProfileImageFromGalary();
                        break;
                }
            }
        });
        builder.show();
    }

    private void takeNewProfilePic() {
        Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        profileImageFile = AppUtils.getOutputMediaFileForImage();
        profileImageUri = FileProvider.getUriForFile(this, getPackageName() + ".provider", profileImageFile);
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, profileImageUri);
        startActivityForResult(cameraIntent, TAKE_PHOTO_FOR_PROFILE_CODE);
    }

    private void pickProfileImageFromGalary() {
        Intent pickIntent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        pickIntent.setType("image/*");
        startActivityForResult(pickIntent, PICK_PROFILE_IMAGE_CODE);

    }


    @Override
    public void loadMedias(ArrayList<ContestantMedia> cats) {
        setupView(true);
        youtubeMedia = new ArrayList<>();
        for (ContestantMedia media : cats) {
            if (Constants.MEDIA_TYPE_YOUTUBE.equals(media.getMediaType())) {
                youtubeMedia.add(media);
            }
        }
        cats.removeAll(youtubeMedia);
        adapter.addData(cats);
        setYoutubeInfo();
    }

    private void setYoutubeInfo() {
        if (youtubeMedia.size() > 0) {
            binding.etyt1.setText(youtubeMedia.get(0).getMediaPath());
            if (youtubeMedia.size() > 1) {
                binding.etyt2.setText(youtubeMedia.get(1).getMediaPath());

                if (youtubeMedia.size() > 2) {
                    binding.etyt3.setText(youtubeMedia.get(2).getMediaPath());
                }
            }
        }
    }

    private void setupView(boolean isreset) {
        if (isreset) {
            adapter = null;
        }
        if (adapter == null) {
            adapter = new ContestantMediaAdapter(getApplicationContext(),
                    new BaseMainAdpter.OnRecyclerviewClick() {
                        @Override
                        public void onClick(Object model, View view, int position, ViewType viewType) {
                            if (viewType == ViewType.View) {
//                                Intent i = new Intent(getApplicationContext(), ContestantDetails.class);
//                                startActivity(i);

                            } else if (viewType == ViewType.Delete) {
                                deleteMedia((ContestantMedia) model);

                            } else if (viewType == ViewType.Add) {
                                addNewMedia();
                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });

            binding.gvProfileImgs.setLayoutManager(new GridLayoutManager(this, 2));
            binding.gvProfileImgs.setAdapter(adapter);
        } else {
            binding.gvProfileImgs.setLayoutManager(new GridLayoutManager(this, 2));
            binding.gvProfileImgs.setAdapter(adapter);
        }
    }

    private void deleteMedia(ContestantMedia media) {
        presenter.deleteMedia(media);
    }

    private void addNewMedia() {
        Log.d(TAG, "addNewMedia:");
        boolean isShowAddNewImage = canWeAddNewImage();
        boolean isShowAddNewVideo = canWeAddNewVideo();
        ArrayList<String> arrayList = new ArrayList<>();
        if (isShowAddNewImage) {
            arrayList.add(getString(R.string.str_take_pic));
            arrayList.add(getString(R.string.str_pick_images_gallary));
        }
        if (isShowAddNewVideo) {
            arrayList.add(getString(R.string.str_capture_video));
            arrayList.add(getString(R.string.str_pick_video));
        }
        String[] choices = arrayList.toArray(new String[0]);
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setItems(choices, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                String selectedItem = arrayList.get(which);
                handleAddMediaDialogSelection(selectedItem);
            }
        });
        builder.show();
    }

    private boolean canWeAddNewImage() {
        int count = 0;
        for (int i = 0; i < adapter.getHomeArrayList().size(); i++) {
            ContestantMedia item = adapter.getHomeArrayList().get(i);
            if (MEDIA_TYPE_IMAGE.equals(item.getMediaType())) {
                count = count + 1;
            }
        }
        if (count < MAX_MEDIA_IMAGE_COUNT) {
            return true;
        }
        return false;
    }

    private boolean canWeAddNewVideo() {
        int count = 0;
        for (int i = 0; i < adapter.getHomeArrayList().size(); i++) {
            ContestantMedia item = adapter.getHomeArrayList().get(i);
            if (MEDIA_TYPE_VIDEO.equals(item.getMediaType())) {
                count = count + 1;
            }
        }
        if (count < MAX_MEDIA_VIDEO_COUNT) {
            return true;
        }
        return false;
    }


    private void handleAddMediaDialogSelection(String selectedItem) {
        if (selectedItem.equals(getString(R.string.str_take_pic))) {
            takePicForNewMedia();
        } else if (selectedItem.equals(getString(R.string.str_pick_images_gallary))) {
            pickImagesForNewMedias();
        } else if (selectedItem.equals(getString(R.string.str_capture_video))) {
            captureVideoForNewMedia();
//            showUnderDevelopment();
        } else if (selectedItem.equals(getString(R.string.str_pick_video))) {
            pickVideoForNewMedia();
//            showUnderDevelopment();
        }
    }

    private void showUnderDevelopment() {
        final Dialog dialog = new Dialog(this);

        dialog.setContentView(R.layout.popup_layout_underdevelopment);

        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(false);
        final AppCompatTextView tvbar = (AppCompatTextView) dialog.findViewById(R.id.tvbar);


        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btndone);


        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();

            }
        });


        tvbar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });


        dialog.show();

    }


    private void takePicForNewMedia() {
        Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        mediaImageCaptureFile = AppUtils.getOutputMediaFileForImage();
        mediaImageCaptureUri = FileProvider.getUriForFile(this, getPackageName() + ".provider", mediaImageCaptureFile);
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, mediaImageCaptureUri);
        startActivityForResult(cameraIntent, TAKE_PHOTO_FOR_MEDIA_CODE);
    }

    private void pickImagesForNewMedias() {
        Intent pickIntent = new Intent();
        pickIntent.setType("image/*");
        pickIntent.setAction(Intent.ACTION_GET_CONTENT);
        pickIntent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
        startActivityForResult(pickIntent, PICK_IMAGES_FOR_MEDIA_CODE);
    }

    private void captureVideoForNewMedia() {
        Intent cameraIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        mediaVideoCaptureFile = AppUtils.getOutputMediaFileForVideo();
        mediaVideoCaptureUri = FileProvider.getUriForFile(this, getPackageName() + ".provider", mediaVideoCaptureFile);
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, mediaVideoCaptureUri);
        cameraIntent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, MAX_VIDEO_LENGTH);
        startActivityForResult(cameraIntent, CAPTURE_VIDEO_FOR_MEDIA_CODE);
    }

    private void pickVideoForNewMedia() {
        Intent pickIntent = new Intent();
        pickIntent.setType("video/*");
        pickIntent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(pickIntent, PICK_VIDEO_FOR_MEDIA_CODE);
    }


    @Override
    public void userProfileUpdateSuccess(String message) {
        AppUtils.setToast(this, message);
        setResult(Activity.RESULT_OK);
        finish();
    }

    @Override
    public void mediaFetchFail(String s) {
        AppUtils.setToast(this, s);
    }

    @Override
    public void mediaDeleteSuccess(String message, ContestantMedia media) {
        AppUtils.setToast(this, message);
        if (adapter != null) {
            adapter.getHomeArrayList().remove(media);
            adapter.notifyDataSetChanged();
        }
        localMedias.remove(media);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == TAKE_PHOTO_FOR_PROFILE_CODE) {
            handleTakePhotoForProfileResult(requestCode, resultCode, data);
        }
        if (requestCode == PICK_PROFILE_IMAGE_CODE) {
            handlePickProfileImageResult(requestCode, resultCode, data);
        }
        if (requestCode == TAKE_PHOTO_FOR_MEDIA_CODE) {
            handleTakePhotoForMediaResult(requestCode, resultCode, data);

        }
        if (requestCode == PICK_IMAGES_FOR_MEDIA_CODE) {
            handlePickImageForMediaResult(requestCode, resultCode, data);

        }
        if (requestCode == CAPTURE_VIDEO_FOR_MEDIA_CODE) {
            handleCaptureVideoForMediaResult(requestCode, resultCode, data);
        }
       /* if (requestCode == PICK_VIDEO_FOR_MEDIA_CODE) {
            handlePickVideoForMediaResult(requestCode, resultCode, data);
        }
        if (requestCode == TRIM_VIDEO_CODE) {
            handleTrimVideoResult(requestCode, resultCode, data);
        }*/
    }

    private void handleTakePhotoForProfileResult(int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "handleTakePhotoForProfileResult: ");
        if (requestCode == TAKE_PHOTO_FOR_PROFILE_CODE && resultCode == Activity.RESULT_OK /*&& data != null*/) {
            AppUtils.setImageUrl(this, profileImageUri, binding.ivProfileImg);
        }
    }

    private void handlePickProfileImageResult(int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "handlePickProfileImageResult: ");
        if (requestCode == PICK_PROFILE_IMAGE_CODE && resultCode == Activity.RESULT_OK && data != null) {
            profileImageFile = null;
            profileImageUri = data.getData();
            AppUtils.setImageUrl(this, profileImageUri, binding.ivProfileImg);
        }
    }

    private void handleTakePhotoForMediaResult(int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "handleTakePhotoForMediaResult: ");
        if (requestCode == TAKE_PHOTO_FOR_MEDIA_CODE && resultCode == Activity.RESULT_OK) {
            createAndAddMediaToList(mediaImageCaptureUri, mediaImageCaptureFile, MEDIA_TYPE_IMAGE);
            uploadLocalImagesToServer();
        }
    }

    private void handlePickImageForMediaResult(int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "handlePickImageForMediaResult: ");
        if (requestCode == PICK_IMAGES_FOR_MEDIA_CODE && resultCode == Activity.RESULT_OK && data != null) {
            if (data.getClipData() != null) {
                int count = data.getClipData().getItemCount(); //evaluate the count before the for loop --- otherwise, the count is evaluated every loop.
                int currentTotalImageCount = getCurrentTotalImageCount();
                if (count > (MAX_MEDIA_IMAGE_COUNT - currentTotalImageCount)) {
                    AppUtils.setToast(this, getString(R.string.str_max_images));
                    count = MAX_MEDIA_IMAGE_COUNT - currentTotalImageCount;
                }
                for (int i = 0; i < count; i++) {
                    Uri imageUri = data.getClipData().getItemAt(i).getUri();
                    createAndAddMediaToList(imageUri, MEDIA_TYPE_IMAGE);
                }
                uploadLocalImagesToServer();
            } else if (data.getData() != null) {
                Uri uri = data.getData();
                createAndAddMediaToList(uri, MEDIA_TYPE_IMAGE);
                uploadLocalImagesToServer();
            }
        }

    }

    private void uploadLocalImagesToServer() {
        if (adapter != null)
            presenter.uploadLocalImagesToServer(adapter.getHomeArrayList());
    }

    private void handleCaptureVideoForMediaResult(int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "handleCaptureVideoForMediaResult: ");
        if (requestCode == CAPTURE_VIDEO_FOR_MEDIA_CODE && resultCode == Activity.RESULT_OK) {
            createAndAddMediaToList(mediaVideoCaptureUri, mediaVideoCaptureFile, MEDIA_TYPE_VIDEO);
            uploadLocalImagesToServer();
        }
    }

//    private void handlePickVideoForMediaResult(int requestCode, int resultCode, Intent data) {
//        Log.d(TAG, "handlePickVideoForMediaResult: ");
//        if (requestCode == PICK_VIDEO_FOR_MEDIA_CODE && resultCode == Activity.RESULT_OK && data != null) {
//          /*  if (data.getClipData() != null) {
//                int count = data.getClipData().getItemCount(); //evaluate the count before the for loop --- otherwise, the count is evaluated every loop.
//                int currentTotalImageCount = getCurrentTotalVideoCount();
//                if(count>(MAX_MEDIA_VIDEO_COUNT-currentTotalImageCount)){
//                    AppUtils.setToast(this,getString(R.string.str_max_video));
//                    count=MAX_MEDIA_VIDEO_COUNT-currentTotalImageCount;
//                }
//                for (int i = 0; i < count; i++) {
//                    Uri imageUri = data.getClipData().getItemAt(i).getUri();
//                    createAndAddMediaToList(imageUri, MEDIA_TYPE_VIDEO);
//                }
//            }else */
//            if (data.getData() != null) {
//                Uri uri = data.getData();
//                trimVideo(uri);
//            }
//        }
//    }

   /* private void handleTrimVideoResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == TRIM_VIDEO_CODE && resultCode == Activity.RESULT_OK) {
            if (orignalVideoBeforeTrim != null) {
                //noinspection ResultOfMethodCallIgnored
                orignalVideoBeforeTrim.delete();
                Log.d(TAG, "handleTrimVideoResult: deleting orignal video before trim");
                orignalVideoBeforeTrim = null;

            }
            createAndAddMediaToList(mediaVideoCaptureUri, mediaVideoCaptureFile, MEDIA_TYPE_VIDEO);
            uploadLocalImagesToServer();
        }
    }*/

    File orignalVideoBeforeTrim = null;

  /*  private void trimVideo(Uri uri) {
        showLoader();
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {

                    orignalVideoBeforeTrim = FileUtil.from(EditProfileActivity.this, uri);
                    Uri orignalVideoBeforeTrimUri = FileProvider.getUriForFile(EditProfileActivity.this, getPackageName() + ".provider", orignalVideoBeforeTrim);
                    mediaVideoCaptureFile = AppUtils.getOutputMediaFileForVideo();
                    mediaVideoCaptureUri = FileProvider.getUriForFile(EditProfileActivity.this, getPackageName() + ".provider", mediaVideoCaptureFile);
                    Intent trimIntent = VideoTrimmerActivity.call(EditProfileActivity.this, orignalVideoBeforeTrim.getPath(), orignalVideoBeforeTrimUri.toString(), mediaVideoCaptureFile.getPath());
                    if (presenter != null && presenter.getView() != null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                startActivityForResult(trimIntent, TRIM_VIDEO_CODE);
                                hideLoader();
                            }

                        });
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }


            }
        }).start();


    }
*/
    private int getCurrentTotalImageCount() {
        if (adapter != null) {
            int count = 0;
            for (int i = 0; i < adapter.getHomeArrayList().size(); i++) {
                if (MEDIA_TYPE_IMAGE.equals(adapter.getHomeArrayList().get(i).getMediaType())) {
                    count = count + 1;
                }
            }
            return count;
        }
        return 0;
    }


    /* private int getCurrentTotalVideoCount() {
         if (adapter != null) {
             int count = 0;
             for (int i = 0; i < adapter.getHomeArrayList().size(); i++) {
                 if (MEDIA_TYPE_VIDEO.equals(adapter.getHomeArrayList().get(i).getMediaType())) {
                     count = count + 1;
                 }
             }
             return count;
         }
         return 0;
     }*/
    private void createAndAddMediaToList(Uri uri, String type) {
        createAndAddMediaToList(uri, null, type);
    }

    private void createAndAddMediaToList(Uri uri, File file, String type) {
        ContestantMedia localMedia = new ContestantMedia();
        localMedia.setLocal(true);
        localMedia.setMediaUri(uri);
        localMedia.setMediaType(type);
        localMedia.setFile(file);
        localMedia.setContestantId(contestantDetailsModel.getContestant_id());
        if (adapter != null) {
            adapter.getHomeArrayList().add(localMedia);
            adapter.notifyDataSetChanged();
        }
        localMedias.add(localMedia);
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        presenter.retry();
    }

    @Override
    public void imageUploadSuccess(ContestantMedia media) {
        localMedias.remove(media);
        if (adapter != null)
            adapter.notifyDataSetChanged();
    }

    @Override
    public void mediaUploadFailed(ArrayList<ContestantMedia> contestantMedias) {

        localMedias.removeAll(contestantMedias);
        if (adapter != null) {
            adapter.getHomeArrayList().removeAll(contestantMedias);
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void showProgressDialog() {
        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage(getString(R.string.msg_media_uploading));
        progressDialog.setCancelable(false);
        progressDialog.show();
    }

    @Override
    protected void onDestroy() {
        presenter.onDetach();
        super.onDestroy();
    }

    @Override
    public void hideLoader() {
        super.hideLoader();
        if (progressDialog != null) {
            progressDialog.hide();
            progressDialog = null;
        }
    }


}
