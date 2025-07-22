package com.etech.starranking.ui.activity.ui.contestantDetails;

import android.app.Activity;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.util.Patterns;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.MediaController;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatImageButton;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.core.content.FileProvider;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;
import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.base.BaseMainAdpter;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.databinding.LayoutContestantDetailsTab1Binding;
import com.etech.starranking.ui.activity.model.ContestantDetailsModel;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.activity.model.GiftDetails;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.OtherContestantDetails;
import com.etech.starranking.ui.activity.model.StarDetails;
import com.etech.starranking.ui.activity.model.UserDetailsFromMobile;
import com.etech.starranking.ui.activity.ui.contestantDetails.contestantVoteHistory.ContestantVoteHistory;
import com.etech.starranking.ui.activity.ui.editProfile.EditProfileActivity;
import com.etech.starranking.ui.adapter.HashMapAdapter;
import com.etech.starranking.ui.adapter.ProfileImageAdapter;
import com.etech.starranking.ui.adapter.VideoListAdapter;
import com.etech.starranking.ui.adapter.previewImgSliderAdapter;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.etech.starranking.utils.CustomAlertDialog;
import com.etech.starranking.utils.CustomDividerItemDecorator;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.model.ShareStoryContent;
import com.facebook.share.widget.ShareDialog;
import com.google.android.youtube.player.YouTubeStandalonePlayer;
//import com.google.firebase.dynamiclinks.DynamicLink;
//import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.kakao.kakaolink.v2.KakaoLinkResponse;
import com.kakao.kakaolink.v2.KakaoLinkService;
import com.kakao.kakaotalk.api.KakaoTalkApi;
import com.kakao.message.template.ButtonObject;
import com.kakao.message.template.ContentObject;
import com.kakao.message.template.FeedTemplate;
import com.kakao.message.template.LinkObject;
import com.kakao.message.template.MessageTemplateProtocol;
import com.kakao.network.ErrorResult;
import com.kakao.network.callback.ResponseCallback;
import com.mikhaellopez.circularimageview.CircularImageView;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_USER_STARS;
import static com.etech.starranking.ui.activity.ui.contestantDetails.contestantVoteHistory.ContestantVoteHistory.BANNER_TAPPED_CODE;
import static com.facebook.share.internal.DeviceShareDialogFragment.TAG;

public class ContestantDetails extends BaseFragment implements ContestantContract.View {

    private static final String TAG = "ContestantDetails";
    private static final int EDIT_PROFILE_CODE = 124;
    private static final int VOTE_HISTORY_CODE = 125;
    private static final String YOUR_DEVELOPER_KEY = "AIzaSyDPuqPTOfYn3pkxs43wu5YpsuwBc6U2DLw";

    LayoutContestantDetailsTab1Binding binding;
    ProfileImageAdapter adapter;
    VideoListAdapter vdAdapter;
    VideoListAdapter ytvdAdapter;
    LoginProfile user;
    HashMapAdapter hashMapAdapter;
    //    OtherContestantDetailsAdapter detailsAdapter;
    String mainimg_url, contesntntmessage;

    //    MessageRepliesAdapter msgRepliesAdapter;
    ContestantContract.Presenter<ContestantContract.View> presenter;
    private MediaController mediacontroller;
    private static int NUM_PAGES = 0;
    String contestantid;
    String contestid;
    AppCompatTextView giftto_name;
    CircularImageView mobileProfile, starGift;
    String gift_username = "";
    String gift_userid;
    UserDetailsFromMobile mobmodel;
    ArrayList<ContestantMedia> imglist = new ArrayList<>();
    boolean mobilenumberSuccess;
    String gift_amt_to_user = "";
    boolean mobileNumberIsvalid;
    boolean giftAmtIsvalid;
    int selectedPosition = 0;
    boolean ismobilenumbervalid;
    boolean isstarAmtvalid;
    Date voteStartDate,voteEndDate;
    String voteOpenDateString , voteCloseDateString;
    Date d = new Date();
    public static ContestantDetails newInstance() {
        return newInstance(null);
    }

    public static ContestantDetails newInstance(Bundle bundle) {
        ContestantDetails fragment = new ContestantDetails();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        presenter.onDetach();
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = DataBindingUtil.inflate(inflater, R.layout.layout_contestant_details_tab1, container, false);
        presenter = new ContestantPresenter<>();
        presenter.onAttach(this);
        contestantid = getArguments().getString("contestantid", "");
        contestid = getArguments().getString("contestid", "");
        voteCloseDateString = getArguments().getString("vote_close_date","");
        voteOpenDateString = getArguments().getString("vote_open_date","");
        voteEndDate = AppUtils.getVoteStartAndCloseDate(voteCloseDateString);
        voteStartDate = AppUtils.getVoteStartAndCloseDate(voteOpenDateString);


        Log.e("contestantid", contestantid);
        Log.e("contestid", contestid);
        presenter.initView(contestantid, contestid);
        user = StarRankingApp.getDataManager().getUserFromPref();

        if (!user.getUser_id().equals("")) {
            binding.headerVote.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                   /* if (Constants.CONTEST_STATUS_OPEN.equals(contestantDetailsModel.getContest_status())) {
                        showdialog(getContext(), R.layout.popup_layout_vote);
                    } else {
                        showError(Constants.FAIL_CODE, getString(R.string.str_msg_voting_period));
                    }
                    */

                    if(d.after(voteStartDate) && d.before(voteEndDate)){
                        showdialog(getContext(), R.layout.popup_layout_vote);
                    }
                    else{
                        showError(Constants.FAIL_CODE, getString(R.string.str_msg_voting_period));
                    }

                }
            });
        } else {
            binding.headerVote.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    AppUtils.loginPopup(getContext());
                }
            });

        }


        binding.headershare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Dialog dialog = new Dialog(getActivity());
                dialog.setContentView(R.layout.popup_layout_share);
                dialog.findViewById(R.id.ivFacebookShare).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        facebookShare();
                    }
                });
                dialog.findViewById(R.id.ivInstaShare).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        instaShare();
                    }
                });
                dialog.findViewById(R.id.ivKakaoShare).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        kakaoShare();
                    }
                });
                dialog.getWindow().setGravity(Gravity.BOTTOM);
                dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
                AppCompatImageButton ivClose = (AppCompatImageButton) dialog.findViewById(R.id.ivClose);

                ivClose.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                });

                dialog.show();
            }
        });
        binding.tvprofVote.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (!user.getUser_id().equals("")) {
                    Log.d(TAG, "onClick: "+contestantDetailsModel.getContest_status());
                    /*if (Constants.CONTEST_STATUS_OPEN.equals(contestantDetailsModel.getContest_status())) {
                        showdialog(getContext(), R.layout.popup_layout_vote);
                    } else {
                        showError(Constants.FAIL_CODE, getString(R.string.str_msg_voting_period));
                    }*/
                    if(d.after(voteStartDate) && d.before(voteEndDate)){
                        showdialog(getContext(), R.layout.popup_layout_vote);
                    }
                    else{
                        showError(Constants.FAIL_CODE, getString(R.string.str_msg_voting_period));
                    }
                } else {
                    AppUtils.loginPopup(getContext());
                }

            }
        });
        binding.tvprofHistroy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getActivity(), ContestantVoteHistory.class);
                i.putExtra(ContestantVoteHistory.ARG_CONTEST_ID, contestid);
                i.putExtra(ContestantVoteHistory.ARG_CONTESTANT_ID, contestantid);
                startActivityForResult(i, VOTE_HISTORY_CODE);
                //showStarHistorydialog(getActivity(), R.layout.popup_layout_voting_history);
            }
        });
        binding.tvprofCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(getContext(), contestid);
//                final Dialog dialog = new Dialog(getActivity());
//                dialog.setContentView(R.layout.popup_layout_share);
//                dialog.getWindow().setGravity(Gravity.BOTTOM);
//                dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//                dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
//                AppCompatImageButton ivClose = (AppCompatImageButton) dialog.findViewById(R.id.ivClose);
//
//                ivClose.setOnClickListener(new View.OnClickListener() {
//                    @Override
//                    public void onClick(View v) {
//                        dialog.dismiss();
//                    }
//                });
//
//                dialog.show();
            }
        });
        binding.tvprofGift.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!user.getUser_id().equals("")) {
                    showGiftdialog(getContext(), R.layout.popup_sendstar);
                } else {
                    AppUtils.loginPopup(getContext());
                }

//                final Dialog dialog = new Dialog(getActivity());
//                dialog.setContentView(R.layout.popup_sendstar);
//
//                dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//                dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
//
//
//                dialog.show();

//                FragmentManager manager = getFragmentManager();
//                FragmentTransaction transaction = manager.beginTransaction();
//                transaction.replace(R.id.llframemain, new StarShopFragment()).addToBackStack(null);
//                transaction.commit();

            }
        });

//binding.ivContestantMainProfile.
//        String filePath = "https://www.youtube.com/watch?v=sx5PJyzGEpc";


//        binding.lvOtherDetails.setLayoutManager(layoutManager);
        binding.imgLarger.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getContext(), PreviewImageSlider.class);
                i.putExtra("previewlist", imglist);
                i.putExtra(PreviewImageSlider.ARG_POSITION, selectedPosition);
                startActivity(i);

            }
        });
        binding.btnEditProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (AppUtils.AskAndCheckPermission(requireActivity(), AppUtils.WRITE_STORAGE, 123) && contestantDetailsModel != null) {
                    Intent i = new Intent(getActivity(), EditProfileActivity.class);
                    i.putExtra("mainimg", mainimg_url);
                    i.putExtra("msg", contesntntmessage);
                    i.putExtra(EditProfileActivity.ARG_CONTESTANT_DETAILS, contestantDetailsModel);
                    startActivityForResult(i, EDIT_PROFILE_CODE);
                }
//                FragmentManager manager = getFragmentManager();
//                FragmentTransaction transaction = manager.beginTransaction();
//                transaction.replace(R.id.llframemain, new EditProfileActivity()).addToBackStack(null);
//                transaction.commit();
            }
        });
        binding.ivContestantMainProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent profileImagePreviewIntent = new Intent(getContext(), ProfileImagePreviewActivity.class);
                profileImagePreviewIntent.putExtra(ProfileImagePreviewActivity.ARG_IMAGE_URL, contestantDetailsModel.getMain_image());
                startActivity(profileImagePreviewIntent);
            }
        });
        return binding.getRoot();
    }

    private void facebookShare() {
        Uri uri = generateUri();
        ShareLinkContent content = new ShareLinkContent.Builder()
                .setContentUrl(uri)
                .build();
        ShareDialog shareDialog = new ShareDialog(this);
        shareDialog.show(content, ShareDialog.Mode.AUTOMATIC);
    }

    private Uri generateUri() {
     /*   Uri.Builder builder = new Uri.Builder();
        builder.scheme("http")
                .authority("www.etechservices.biz")
                .appendPath("rankingstar")
                .appendPath("api")
                .appendPath("shareContestantOnFacebook")
                .appendQueryParameter("contest_id",)
                .appendQueryParameter("contestant_id", contestantDetailsModel.getContestant_id())
                .appendQueryParameter("language", StarRankingApp.getDataManager().getLanguage());*/
        Uri result = Uri.parse(AppApiHelper.BASE_URL + "shareContestantOnFacebook?contest_id=" + contestantDetailsModel.getContest_id() + "&contestant_id=" + contestantDetailsModel.getContestant_id() + "&language=" + StarRankingApp.getDataManager().getLanguage());
        Log.d(TAG, "generateUri: " + result);
    /*    DynamicLink dynamicLink = FirebaseDynamicLinks.getInstance().createDynamicLink()
                .setLink(result)
                .setDomainUriPrefix("https://starranking.page.link/")
                // Open links with this app on Android
                .setAndroidParameters(new DynamicLink.AndroidParameters.Builder().build())
                // Open links with com.example.ios on iOS
                .setIosParameters(new DynamicLink.IosParameters.Builder("com.example.ios").build())
                .buildDynamicLink();

        Uri dynamicLinkUri = dynamicLink.getUri();*/

        return result;
    }

    private void instaShare() {


        Glide.with(this)
                .asBitmap()
                .load(contestantDetailsModel.getMain_image())
                .into(new SimpleTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(Bitmap resource, Transition<? super Bitmap> transition) {
                        try {
                            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
                            String fileName = "Img" + timeStamp + ".jpg";
                            File output = new File(getContext().getFilesDir().getPath() + File.separator + "images" + File.separator + fileName);
                            if (!output.exists()) {
                                new File(output.getParent()).mkdirs();
                                output.createNewFile();
                            }

                            OutputStream outputStream = new FileOutputStream(output);
                            resource.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
                            outputStream.close();

                           /* File logo = new File(getContext().getFilesDir().getPath() + File.separator + "images" + File.separator + "logo.jpg");
                            if (!logo.exists()) {
                                new File(logo.getParent()).mkdirs();
                                logo.createNewFile();
                            }*/
//                            Bitmap tempBMP = BitmapFactory.decodeResource(getResources(), R.drawable.icon_180);
//                            outputStream = new FileOutputStream(logo);
//                            tempBMP.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
//                            outputStream.close();
//                            Uri uri = Uri.parse("content://com.etech.starranking.provider/externalFiles/Pictures/a.jpg");
                            Uri uri = FileProvider.getUriForFile(getContext(), getContext().getPackageName() + ".provider", output);
//                            Uri backgroundUri = FileProvider.getUriForFile(getContext(), getContext().getPackageName() + ".provider", logo);
//this works in some devices
                            Intent shareIntent = new Intent("com.instagram.share.ADD_TO_STORY");
                            shareIntent.setDataAndType(uri, "image/jpeg");
//                            shareIntent.putExtra("interactive_asset_uri", uri);
                            shareIntent.putExtra("content_url", generateUri().toString());
                            shareIntent.setPackage("com.instagram.android");

                            shareIntent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                            Activity activity = getActivity();
                            activity.grantUriPermission(
                                    "com.instagram.android", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);

//            intent.setDataAndType(uri, "jpg");
//            intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
//            intent.putExtra("content_url", attributionLinkUrl);
//            intent.setPackage("com.instagram.android");
//            activity.grantUriPermission("com.instagram.android", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);

//            Intent shareIntent = new Intent();
//            shareIntent.setComponent(new ComponentName("com.instagram.android", "com.instagram.share.handleractivity.StoryShareHandlerActivity"));
//            shareIntent.setAction(Intent.ACTION_SEND);
//            shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
//            shareIntent.setType("image/jpeg");
//            shareIntent.putExtra("content_url", "https://www.google.com/");
//            shareIntent.setPackage("com.instagram.android");
//            startActivity(Intent.createChooser(shareIntent, "abc"));


//                            Activity activity = getActivity();
            /*List<ResolveInfo> activities = activity.getPackageManager().queryIntentActivities(shareIntent, 0);
            for(int i=0;i<activities.size();i++){
                ResolveInfo info=activities.get(i);
                Log.d(TAG, "instaShare: "+info.activityInfo.name);
            }*/
                            if (activity.getPackageManager().resolveActivity(shareIntent, 0) != null) {
                                activity.startActivityForResult(shareIntent, 0);
                            } else {
                                AppUtils.setToast(getContext(), getString(R.string.msg_instagram_not_installed));
                            }
//            }


                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });

    }

    Uri profileImageUri;
    private static final int TAKE_PHOTO_FOR_PROFILE_CODE = 124;

    private void takeNewProfilePic() {
        if (AppUtils.AskAndCheckPermission(getActivity(), AppUtils.WRITE_STORAGE, 125)) {
            Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            File profileImageFile = AppUtils.getOutputMediaFileForImage();
            profileImageUri = FileProvider.getUriForFile(this.getContext(), getActivity().getPackageName() + ".provider", profileImageFile);
            cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, profileImageUri);
            startActivityForResult(cameraIntent, TAKE_PHOTO_FOR_PROFILE_CODE);
        }
    }

    private void kakaoShare() {
        FeedTemplate params = FeedTemplate
                .newBuilder(
                        ContentObject.newBuilder(
                                contestantDetailsModel.getContest_name() + " - " + contestantDetailsModel.getName() + " " + getString(R.string.str_lbl_pleese_support),
                                contestantDetailsModel.getMain_image(),
                                LinkObject.newBuilder()
                                        .setWebUrl(generateUri().toString())
                                        .setMobileWebUrl(generateUri().toString())
                                        .setAndroidExecutionParams(getParamsForKakao())
                                        .setIosExecutionParams(getParamsForKakao())
                                        .build())
//                        .setDescrption(contestantDetailsModel.getIntroduction())
                                .build())

                .build();

        Map<String, String> serverCallbackArgs = new HashMap<String, String>();
//        serverCallbackArgs.put("user_id", "${current_user_id}");
//        serverCallbackArgs.put("product_id", "${shared_product_id}");

        KakaoLinkService.getInstance().sendDefault(this.requireContext(), params, serverCallbackArgs, new ResponseCallback<KakaoLinkResponse>() {
            @Override
            public void onFailure(ErrorResult errorResult) {
//                Logger.e(errorResult.toString());
                Log.e(TAG, "onFailure: " + errorResult.getErrorMessage());
            }

            @Override
            public void onSuccess(KakaoLinkResponse result) {
                Log.d(TAG, "onSuccess: ");
                // 템플릿 밸리데이션과 쿼터 체크가 성공적으로 끝남. 톡에서 정상적으로 보내졌는지 보장은 할 수 없다. 전송 성공 유무는 서버콜백 기능을 이용하여야 한다.
            }
        });


    }

    private String getParamsForKakao() {
        String result = "contest_id=" + contestantDetailsModel.getContest_id() + "&contestant_id=" + contestantDetailsModel.getContestant_id();
        Log.d(TAG, "getParamsForKakao() returned: " + result);
        return result;
    }


    public void showdialog(Context context, int layoput) {
        final Dialog dialog = new Dialog(context);

        dialog.setContentView(layoput);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

        final AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.votebar);
        final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
        final AppCompatEditText editText = (AppCompatEditText) dialog.findViewById(R.id.etvote);
        final AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.btnUseAll);
        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);


        // LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();

        tvpopupStarsAmt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                editText.setText(user.getRemaining_star());
            }
        });

        votebar.setText(String.format(getString(R.string.str_lbl_vote_popup_title), contestantDetailsModel.getName()));
        votebar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                int total = Integer.parseInt(user.getRemaining_star().toString());
//                int wantToVote = Integer.parseInt(editText.getText().toString());
//                if(editText.getText().toString().equals("")){
//                    AppUtils.setToast(getContext(), "Enter votes");
//                }
//                if (wantToVote > total) {
//                    AppUtils.setToast(getContext(), "You dont have enough stars");
//                    Intent i = new Intent(getContext(), StarChargingWebview.class);
//                    startActivity(i);
//                } else {

                if (isValidData()) {
                    dialog.dismiss();
                    presenter.addvotecall(contestid, contestantid, user.getUser_id(), editText.getText().toString(), user.getName());
                }
//
//                    //api call
//                }
            }

            boolean isValidData() {
                if (editText.getText() == null || editText.getText().toString().isEmpty()) {
                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_enter_star));
                    return false;
                } else if (Integer.parseInt(editText.getText().toString()) == 0) {
                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_star_can_not_0));
                    return false;
                }
                return true;
            }
        });
        dialog.show();
    }

    public void showGiftdialog(Context context, int layoput) {
        final Dialog dialog = new Dialog(context);
        dialog.setContentView(layoput);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

        dialog.setCancelable(false);
        final AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.bar);
        final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
        final AppCompatEditText giftNo = (AppCompatEditText) dialog.findViewById(R.id.giftMobileNo);
        final AppCompatEditText giftVotesAmt = (AppCompatEditText) dialog.findViewById(R.id.giftVotesAmt);
        final AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.giftbtnUseAll);
        giftto_name = (AppCompatTextView) dialog.findViewById(R.id.giftto_name);
        final AppCompatTextView giftWarining = (AppCompatTextView) dialog.findViewById(R.id.giftWarining);
        final AppCompatTextView giftHint = (AppCompatTextView) dialog.findViewById(R.id.giftHint);
        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);

        mobileProfile = (CircularImageView) dialog.findViewById(R.id.mobileProfile);
        starGift = (CircularImageView) dialog.findViewById(R.id.star);

        // LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();


        tvpopupStarsAmt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                giftVotesAmt.setText(user.getRemaining_star());
            }
        });
        giftVotesAmt.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                giftto_name.setVisibility(View.VISIBLE);
                gift_amt_to_user = giftVotesAmt.getText().toString();

                giftto_name.setText(gift_username + " " + getResources().getString(R.string.str_lbl_gift_to) + " " + gift_amt_to_user + " " + getResources().getString(R.string.str_lbl_gift_surity));
                giftWarining.setVisibility(View.VISIBLE);
                giftHint.setVisibility(View.GONE);
                starGift.setBorderColor(getContext().getResources().getColor(R.color.colorAccent));

                if (!giftVotesAmt.getText().toString().equals("")) {

                    giftto_name.setVisibility(View.VISIBLE);
                    if (Integer.parseInt(giftVotesAmt.getText().toString()) > Integer.parseInt(user.getRemaining_star())) {
                        isstarAmtvalid = false;
                        AppUtils.setToast(getContext(), getResources().getString(R.string.str_not_enough_star));
                    } else {
                        isstarAmtvalid = true;

                    }
                } else {
                    isstarAmtvalid = false;
                }

                if (isValiGiftData()) {
                    btnConfirm.setClickable(true);
                    btnConfirm.setBackgroundColor(getResources().getColor(R.color.colorAccent));
                } else {
                    btnConfirm.setClickable(false);
                    btnConfirm.setBackgroundColor(getResources().getColor(R.color.grey));

                }
            }

            @Override
            public void afterTextChanged(Editable s) {


            }
        });

        giftNo.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {


                if (s.toString().length() == 11) {
                    if (user.getMobile().equals(s.toString())) {
                        ismobilenumbervalid = false;
                        giftto_name.setVisibility(View.GONE);
                        AppUtils.setToast(getContext(), getResources().getString(R.string.str_cant_gift_urself));

                    } else {
                        ismobilenumbervalid = true;
                        giftto_name.setVisibility(View.VISIBLE);
                        presenter.getdetails(s.toString());
                    }

                } else {
                    ismobilenumbervalid = false;

                    giftto_name.setVisibility(View.GONE);
                    mobileProfile.setBorderColor(getContext().getResources().getColor(R.color.circularimage_border));
                    mobileProfile.setImageResource(R.drawable.profile);
                    gift_username = "";
                    gift_userid = "";
                }

                if (isValiGiftData()) {
                    btnConfirm.setClickable(true);
                    btnConfirm.setBackgroundColor(getResources().getColor(R.color.colorAccent));
                } else {
                    btnConfirm.setClickable(false);
                    btnConfirm.setBackgroundColor(getResources().getColor(R.color.grey));

                }
            }

            @Override
            public void afterTextChanged(Editable s) {


            }
        });


        votebar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (gift_userid == null || gift_userid.isEmpty()) {
                    AppUtils.setToast(getContext(), getString(R.string.str_msg_please_povide_valid_user));
                } else {
                    if (isValiGiftData()) {
                        if (isValidData()) {
                            presenter.sendgift(gift_userid, gift_username, user.getUser_id(), user.getName(), giftVotesAmt.getText().toString());
                            dialog.dismiss();
                        }
                    } else {
                        AppUtils.setToast(getContext(), getString(R.string.str_msg_enter_proper_data));
                    }

                }
            }

            boolean isValidData() {
                if (giftVotesAmt.getText() == null || giftVotesAmt.getText().toString().isEmpty()) {
                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_enter_star));
                    return false;
                } else if (Integer.parseInt(giftVotesAmt.getText().toString()) == 0) {
                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_star_can_not_0));
                    return false;
                }
                return true;
            }
        });

        dialog.show();
    }


//    public void showvideoPopup(Activity context, String url, int layoput) {
//        final Dialog dialog = new Dialog(context);
//
//        dialog.setContentView(layoput);
//        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
//        dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
///
//        /
//        /
//        WebView wv = (WebView) dialog.findViewById(R.id.vvContestantVideo);
//        AppCompatImageButton close = (AppCompatImageButton) dialog.findViewById(R.id.ibVideoClose);
//
//        wv.setWebViewClient(new WebViewClient(){
//            @Override
//            public boolean shouldOverrideUrlLoading(WebView view, String url) {
//                return false;
//            }
//        });
//        WebSettings webSettings = wv.getSettings();
//        webSettings.setJavaScriptEnabled(true);
//       // wv.loadData(frameVideo, "text/html", "utf-8");
//        close.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//
//            }
//        });
//
//
//        dialog.show();
//    }


    @Override
    public void failfromMobile() {
        gift_userid = "";
        gift_username = "";
        giftto_name.setVisibility(View.GONE);
    }

    public boolean isValiGiftData() {

        if (ismobilenumbervalid && isstarAmtvalid) {

            return true;
        } else {
            return false;
        }


    }

    @Override
    public void loadOtherData(ArrayList<OtherContestantDetails> details) {
        //   detailsAdapter.addData(details);
    }

    ContestantDetailsModel contestantDetailsModel;

    @Override
    public void loadDetails(ArrayList<ContestantDetailsModel> baseresponse) {
        Log.d(TAG, "loadDetails: "+baseresponse.get(0).getProfile2());
        contestantDetailsModel = baseresponse.get(0);
        binding.tvContestantAge.setText(baseresponse.get(0).getAge() + getString(R.string.str_post_fix_years));
        if (baseresponse.get(0).getHeight() != null && Float.parseFloat(baseresponse.get(0).getHeight()) < 9)
            binding.tvContestantHeight.setText(baseresponse.get(0).getHeight() + getString(R.string.str_post_fix_ft));
        else
            binding.tvContestantHeight.setText(baseresponse.get(0).getHeight() + getString(R.string.str_post_fix_cm));
        binding.tvContestantWeight.setText(baseresponse.get(0).getWeight() + getString(R.string.str_post_fix_kg));
        binding.ContestantName.setText(baseresponse.get(0).getName());
        String rank;
        rank = baseresponse.get(0).getCurrent_ranking();
        if ("1".equals(baseresponse.get(0).getCurrent_ranking())) {
            rank = rank + getString(R.string.str_first);
        } else if ("2".equals(baseresponse.get(0).getCurrent_ranking())) {
            rank = rank + getString(R.string.str_second);
        } else if ("3".equals(baseresponse.get(0).getCurrent_ranking())) {
            rank = rank + getString(R.string.str_thrid);
        }
        binding.tvContestantCurrRank.setText(rank);
        String rs = String.format("%,d", Long.parseLong(baseresponse.get(0).getTotal_vote()));

        binding.tvContestantVotes.setText(rs);

        if (baseresponse.get(0).getProfile2() != null) {
            Log.e("here", String.valueOf(baseresponse.get(0).getProfile2()));
            binding.lvOtherDetails.setVisibility(View.VISIBLE);
            hashMapAdapter = new HashMapAdapter(getContext(), baseresponse.get(0).getProfile2());
            binding.lvOtherDetails.setAdapter(hashMapAdapter);
            binding.lvOtherDetails.setLayoutManager(new LinearLayoutManager(getContext()));
            binding.lvOtherDetails.addItemDecoration(new CustomDividerItemDecorator(getResources().getDrawable(R.drawable.divider)));
        } else {
            binding.lvOtherDetails.setVisibility(View.GONE);
        }

//        detailsAdapter.addData(baseresponse.get(0).getProfile2());
        mainimg_url = baseresponse.get(0).getMain_image();

        AppUtils.setImageUrl(getContext(), baseresponse.get(0).getMain_image(), binding.ivContestantMainProfile, true, R.drawable.home_main_holder);
        AppUtils.setImageUrl(getContext(), baseresponse.get(0).getMain_image(), binding.msgcontestantimg, false);

        if (baseresponse.get(0).getUser_id().equals(user.getUser_id())) {
            binding.btnEditProfile.setVisibility(View.VISIBLE);
        }
        if (baseresponse.get(0).getIntroduction().equals("")) {
            contesntntmessage = getResources().getString(R.string.str_no_msg);
            binding.msg.setText(getResources().getString(R.string.str_no_msg));
        } else {
            contesntntmessage = baseresponse.get(0).getIntroduction();
            binding.msg.setText(baseresponse.get(0).getIntroduction());
        }
    }

    //    @Override
//    public void loadMessageData(ArrayList<CommentsModel> commentsModels) {
//        msgRepliesAdapter.addData(commentsModels);
//    }

    @Override
    public void setupView(boolean isreset) {

        if (isreset) {
            adapter = null;
            vdAdapter = null;
            ytvdAdapter = null;
//            detailsAdapter = null;
        }
        if (adapter == null) {

            adapter = new ProfileImageAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<ContestantMedia>() {
                        @Override
                        public void onClick(ContestantMedia model, View view, int position, ViewType viewType) {

                            if (viewType == viewType.Image) {
                                String image = model.getMediaPath();
                                selectedPosition = position;
                                AppUtils.setImageUrl(getContext(), image, binding.imgLarger, false);


                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });

            binding.rvImages.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false));
            binding.rvImages.setNestedScrollingEnabled(false);
            binding.rvImages.setAdapter(adapter);
        } else {
            binding.rvImages.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false));
            binding.rvImages.setNestedScrollingEnabled(false);
            binding.rvImages.setAdapter(adapter);
        }
        if (vdAdapter == null) {
            vdAdapter = new VideoListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<ContestantMedia>() {
                        @Override
                        public void onClick(ContestantMedia model, View view, int position, ViewType viewType) {
                            if (viewType == viewType.Button) {

                                boolean isURL = Patterns.WEB_URL.matcher(model.getMediaPath().toString().trim()).matches();
                                if (isURL) {
                                    Intent intent = new Intent(getActivity(), ExpoPlayerActivity.class);
                                    intent.putExtra("video_uri", model.getMediaPath().toString().trim());
//                                    intent.putExtra("video_uri", "http://techslides.com/demos/sample-videos/small.mp4");
                                    startActivity(intent);
//                                    Intent mIntent = ExpoPlayer.getStartIntent(getActivity(), model.getMedia_path().toString().trim());
//                                    startActivity(mIntent);
                                } else {
                                    Toast.makeText(getContext(), "not valid", Toast.LENGTH_SHORT).show();
                                }
                            } else if (viewType == viewType.Text) {

                            }
                        }

                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvprofileVdList.setAdapter(vdAdapter);
//            binding.rvprofileVdList.addItemDecoration(new CustomDividerItemDecorator(getResources().getDrawable(R.drawable.divider)));
            binding.rvprofileVdList.setNestedScrollingEnabled(false);
        } else {
            binding.rvprofileVdList.setAdapter(vdAdapter);
//            binding.rvprofileVdList.addItemDecoration(new DividerItemDecoration(binding.rvprofileVdList.getContext(), DividerItemDecoration.VERTICAL));
        }
        if (ytvdAdapter == null) {
            ytvdAdapter = new VideoListAdapter(getContext(),
                    new BaseMainAdpter.OnRecyclerviewClick<ContestantMedia>() {
                        @Override
                        public void onClick(ContestantMedia model, View view, int position, ViewType viewType) {
                            if (viewType == viewType.Button) {

                                String id = model.getVedioId();
                                if (id != null) {
                                    Intent intent = YouTubeStandalonePlayer.createVideoIntent(ContestantDetails.this.activity, YOUR_DEVELOPER_KEY, id);
                                    startActivity(intent);
                                } else {
                                    AppUtils.setToast(requireContext(), getString(R.string.str_msg_invalid_youtube_link));
                                }
                            }
                        }

                        private String getId(String mediaPath) {

                            String pattern = "(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%\u200C\u200B2F|youtu.be%2F|%2Fv%2F)[^#\\&\\?\\n]*";
                            Pattern compiledPattern = Pattern.compile(pattern);
                            //url is youtube url for which you want to extract the id.
                            Matcher matcher = compiledPattern.matcher(mediaPath);
                            if (matcher.find()) {
                                return matcher.group();
                            }
                            return null;
                        }


                        @Override
                        public void onLastItemReached() {

                        }
                    });
            binding.rvYoutubeVideo.setAdapter(ytvdAdapter);
//            binding.rvYoutubeVideo.addItemDecoration(new CustomDividerItemDecorator(getResources().getDrawable(R.drawable.divider)));
            binding.rvYoutubeVideo.setNestedScrollingEnabled(false);
        } else {
//            binding.rvprofileVdList.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false));
            binding.rvYoutubeVideo.setAdapter(ytvdAdapter);
//            binding.rvYoutubeVideo.addItemDecoration(new DividerItemDecoration(binding.rvprofileVdList.getContext(), DividerItemDecoration.VERTICAL));
        }


    }

    @Override
    public void setNoRecordsAvailable(boolean noRecords) {

    }

    @Override
    public void sucessfullyVotes(String vote, StarDetails response) {
//        AppUtils.setToast(getContext(), "Your vote added");
        StarRankingApp.getDataManager().set(AppPreferencesHelper.PREF_USER_STARS, response.getRemaining_star());
        CustomAlertDialog.showVoteSuccessPopUp(getContext(), vote, contestantDetailsModel.getName());
        try {
            int intVote = Integer.parseInt(contestantDetailsModel.getTotal_vote());
            intVote = intVote + Integer.parseInt(vote);
            binding.tvContestantVotes.setText(String.valueOf(intVote));
            contestantDetailsModel.setTotal_vote(String.valueOf(intVote));
            getActivity().setResult(Activity.RESULT_OK);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void loadGallaryData(ArrayList<ContestantMedia> videos) {
        ArrayList<ContestantMedia> videolist = new ArrayList<>();
        ArrayList<ContestantMedia> youtubeVideolList = new ArrayList<>();

        imglist.clear();
        for (int i = 0; i < videos.size(); i++) {
            ContestantMedia items = videos.get(i);
            if (Constants.MEDIA_TYPE_VIDEO.equals(items.getMediaType())) {
                videolist.add(items);
            } else if (Constants.MEDIA_TYPE_YOUTUBE.equals(items.getMediaType())) {
                youtubeVideolList.add(items);
            } else {
                imglist.add(items);
                AppUtils.setImageUrl(getContext(), imglist.get(0).getMediaPath(), binding.imgLarger, false);
            }

        }
        if (videolist.size() > 0) {
            binding.rvprofileVdList.setVisibility(View.VISIBLE);
            vdAdapter.addData(videolist);
        }else{
            binding.rvprofileVdList.setVisibility(View.GONE);
        }
        if(youtubeVideolList.size()>0) {
            binding.rvYoutubeVideo.setVisibility(View.VISIBLE);
            ytvdAdapter.addData(youtubeVideolList);
        }else{
            binding.rvYoutubeVideo.setVisibility(View.GONE);
        }
        adapter.addData(imglist);

        if (imglist.size() == 0) {
            binding.imgLarger.setVisibility(View.GONE);
            binding.rvImages.setVisibility(View.GONE);
        } else {
            binding.imgLarger.setVisibility(View.VISIBLE);
            binding.rvImages.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void noMediaFound() {
        binding.imgLarger.setVisibility(View.GONE);
        binding.rvImages.setVisibility(View.GONE);
    }

    @Override
    public void getSuccessdetailsfromMobile(UserDetailsFromMobile model) {
        mobmodel = model;
        mobilenumberSuccess = true;
        mobileProfile.setBorderColor(getResources().getColor(R.color.colorAccent));
        AppUtils.setImageUrl(getContext(), mobmodel.getMain_image(), mobileProfile, false);
        gift_username = mobmodel.getName();
        gift_userid = mobmodel.getUser_id();

    }

    @Override
    public void getSuccessGiftSent(GiftDetails response, String receiverName, String stars) {
        StarRankingApp.getDataManager().set(PREF_USER_STARS, response.getRemaining_star());
        AppUtils.showGiftSuccessDialog(getContext(), receiverName, stars);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.d(TAG, "onActivityResult: ");
        if (requestCode == EDIT_PROFILE_CODE && resultCode == Activity.RESULT_OK) {
            presenter.resetData();
            getActivity().setResult(Activity.RESULT_OK);
        } else if (requestCode == VOTE_HISTORY_CODE && resultCode == BANNER_TAPPED_CODE) {
            if (getActivity() != null)
                getActivity().finish();
        }
    }

    @Override
    public void onRetryClicked() {
        super.onRetryClicked();
        Log.d(TAG, "onRetryClicked: ");
        presenter.retry();
    }


}