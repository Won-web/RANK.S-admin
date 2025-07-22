package com.etech.starranking.ui.activity.ui.dashboard.starShop;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.databinding.DataBindingUtil;
import androidx.viewpager.widget.ViewPager;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.databinding.ActivityStarShopBinding;
import com.etech.starranking.ui.activity.SampleWebViewActivity;
import com.etech.starranking.ui.activity.model.GiftDetails;
import com.etech.starranking.ui.activity.model.LoginProfile;
import com.etech.starranking.ui.activity.model.UserDetailsFromMobile;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.google.android.material.tabs.TabLayout;
import com.mikhaellopez.circularimageview.CircularImageView;
import com.tnkfactory.ad.TnkSession;
import com.tnkfactory.ad.TnkStyle;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_USER_STARS;


public class StarShopFragment extends BaseFragment implements
        StartShopContract.View {
    private static final int PURCHASE_CODE = 124;
    public static final String ARG_CONTEST_ID = "arg_StarShopFragment_contestId";


    TabLayout tabStarshop;
    ViewPager vpStarTabs;

    private StartShopContract.Presenter<StartShopContract.View> presenter;
    LoginProfile user;
    UserDetailsFromMobile mobmodel;
    AppCompatTextView giftto_name;
    ActivityStarShopBinding binding;
    CircularImageView mobileProfile, starGift;
    //    String profilelstr = "";
    String gift_username = "";
    String gift_userid;
    boolean mobilenumberSuccess;
    String gift_amt_to_user = "";
    boolean mobileNumberIsvalid;
    boolean giftAmtIsvalid;
    boolean ismobilenumbervalid;
    boolean isstarAmtvalid;
    private boolean isNeedToRefreshStar=false;

    public static StarShopFragment newInstance(Bundle bundle) {
        StarShopFragment fragment = new StarShopFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public StarShopFragment() {
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(inflater, R.layout.activity_star_shop, container, false);
        //  View root = inflater.inflate(R.layout.activity_star_shop, container, false);
        AppUtils.gradientStatusbar(getActivity());
        user = StarRankingApp.getDataManager().getUserFromPref();
//
        presenter = new StarShopPresenter<>();
        presenter.onAttach(this);
        presenter.init();

        binding.web.setWebViewClient(new myWebClient());
        binding.web.clearCache(true);
        binding.web.getSettings().setAppCacheEnabled(false);
        binding.web.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);

        binding.web.getSettings().setJavaScriptEnabled(true);
        binding.web.getSettings().setBuiltInZoomControls(true);
        binding.web.getSettings().setDisplayZoomControls(false);

        binding.web.getSettings().setUseWideViewPort(true);
        binding.web.getSettings().setLoadWithOverviewMode(true);
        binding.web.getSettings().setBuiltInZoomControls(true);
        binding.web.getSettings().setSupportZoom(true);

        binding.web.loadUrl(Constants.STARSHOP_URL);
        binding.tvstarsSmt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
//        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                onBackPressed();
//            }
//        });

        binding.web.addJavascriptInterface(new WebAppInterface(getActivity()), "Android");
        if (getActivity() instanceof BaseActivity) {
            ((BaseActivity) getActivity()).checkInternetAndShowNoInternetDialog();
        }
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

    }


    @Override
    public void onResume() {
        super.onResume();
        presenter.getUserProfileAlways(user.getUser_id(),user.getUser_type());
        if(isNeedToRefreshStar){
            isNeedToRefreshStar=false;
            presenter.getUserProfileAlways(user.getUser_id(),user.getUser_type());
        }
    }

    private static final String TAG = "StarShopFragment";


    @Override
    public void onDestroy() {
        super.onDestroy();
        presenter.onDetach();
    }

    public class myWebClient extends WebViewClient {
        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            binding.progressBar1.setVisibility(View.GONE);
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {

            view.loadUrl(url);
            return true;

        }
    }

    @Override
    public void getSuccessdetailsfromMobile(UserDetailsFromMobile model) {
        mobmodel = model;
        mobilenumberSuccess = true;
        mobileProfile.setBorderColor(getActivity().getResources().getColor(R.color.colorAccent));
        AppUtils.setImageUrl(getActivity(), mobmodel.getMain_image(), mobileProfile, false);
        gift_username = mobmodel.getName();
        gift_userid = mobmodel.getUser_id();
    }

    @Override
    public void getSuccessGiftSent(GiftDetails response, String receiverName, String stars) {
        StarRankingApp.getDataManager().set(PREF_USER_STARS, response.getRemaining_star());
        binding.tvstarsSmt.setText(AppUtils.getFormatedString(response.getRemaining_star()));
        AppUtils.showGiftSuccessDialog(getContext(), receiverName, stars);
    }


    @Override
    public void successAtteanance(String msg) {


        showdialog(getActivity(), R.layout.popup_layout_attendance_check);
        user.setRemaining_star(msg);
        binding.tvstarsSmt.setText(AppUtils.getFormatedString(user.getRemaining_star()));
        StarRankingApp.getDataManager().set(PREF_USER_STARS, msg);
    }

    @Override
    public void failfromMobile() {
        gift_userid = "";
        gift_username = "";
        giftto_name.setVisibility(View.GONE);
    }

    @Override
    public void onfail(String message) {
        showdialogCheckedIn(getActivity(), R.layout.popup_layout_alradychecked_attendance);
    }

    public class WebAppInterface {

        Context mContext;

        WebAppInterface(Context c) {
            mContext = c;
        }

        @JavascriptInterface
        public void showToast(String toast) {
//            Toast.makeText(mContext, toast, Toast.LENGTH_SHORT).show();
            //btn-toll
            //btn-attendance
            //btn-free-charging
            //btn-shop
            //btn-coupon
            //btn-gift

            if (toast.toString().equals("btn-toll")) {
                Intent i = new Intent(mContext, PaidChargingActivity.class);
                if (getArguments() != null)
                    i.putExtra(PaidChargingActivity.ARG_CONTEST_ID, getArguments().getString(ARG_CONTEST_ID));
                startActivityForResult(i, PURCHASE_CODE);
            }
            if (toast.toString().equals("btn-attendance")) {
                //popup attendance check
                presenter.attendanceCheckin(AppUtils.LANGUAGE_DEFAULT_VALUE, user.getUser_id());
            }
            if (toast.toString().equals("btn-free-charging")) {
                //webview
                isNeedToRefreshStar=true;
                Intent i = new Intent(mContext, SampleWebViewActivity.class);
                i.putExtra("from", "fromFreeChargingTabs");
                i.putExtra(SampleWebViewActivity.ARG_URL, StarRankingApp.getDataManager().getFreeChargingUrl());
                startActivity(i);


//                TnkSession.setUserName( mContext , user.getUser_id());
//                TnkSession.setAdWallListType(mContext, TnkStyle.AD_LIST_PPI);
//                TnkSession.showAdList(getActivity(),"랭킹스타 무료충전소");
            }
            if (toast.toString().equals("btn-shop")) {
                //webview
                /*
                Intent i = new Intent(mContext, SampleWebViewActivity.class);
                i.putExtra("from", "fromStarShopTabs");
                i.putExtra(SampleWebViewActivity.ARG_URL, StarRankingApp.getDataManager().getShopUrl());
                startActivity(i);
                */

                // defaul browser
                Intent intent = new Intent(Intent.ACTION_VIEW);
                Uri uri = Uri.parse(StarRankingApp.getDataManager().getShopUrl());
                intent.setData(uri);
                startActivity(intent);

            }
            if (toast.toString().equals("btn-coupon")) {
                //webview
                Intent i = new Intent(mContext, SampleWebViewActivity.class);
                i.putExtra("from", "fromTabs");
                i.putExtra(SampleWebViewActivity.ARG_URL, StarRankingApp.getDataManager().getCouponUrl());
                startActivity(i);
            }
            if (toast.toString().equals("btn-gift")) {
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        showdialogGift();
                    }
                });

            }

        }

    }

    public void showdialog(Context context, int layoput) {
        final Dialog dialog = new Dialog(context);

        dialog.setContentView(layoput);

        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(false);
        final AppCompatTextView tvbar = (AppCompatTextView) dialog.findViewById(R.id.tvbar);


        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);


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

    public void showdialogCheckedIn(Context context, int layoput) {
        final Dialog dialog = new Dialog(context);

        dialog.setContentView(layoput);

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

    public void showdialogGift() {
        final Dialog dialog = new Dialog(getActivity());
        dialog.setContentView(R.layout.popup_sendstar);
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

        btnConfirm.setClickable(false);
        btnConfirm.setBackgroundColor(getResources().getColor(R.color.grey));

        mobileProfile = (CircularImageView) dialog.findViewById(R.id.mobileProfile);
        starGift = (CircularImageView) dialog.findViewById(R.id.star);

        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();


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

                giftto_name.setText(getResources().getString(R.string.str_msg_star) + " " + gift_amt_to_user + " " + getResources().getString(R.string.str_lbl_gift_surity));
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

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PURCHASE_CODE && resultCode == Activity.RESULT_OK) {
            if (binding != null) {
                binding.tvstarsSmt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(PREF_USER_STARS, "0")));
            }
        }
    }

    @Override
    public void onReceiverNotification(Context context, String type, Intent intent) {
        super.onReceiverNotification(context, type, intent);
        if (Constants.LB_TYPE_STAR_UPDATED.equals(type)) {
            if (binding != null) {
                binding.tvstarsSmt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(PREF_USER_STARS, "0")));
            }
        }
    }

    public boolean isValiGiftData() {

        if (ismobilenumbervalid && isstarAmtvalid) {

            return true;
        } else {
            return false;
        }


    }

    @Override
    public void getSuccessUserProfileAlways(LoginProfile response) {
        StarRankingApp.getDataManager().saveUserToPref(response);
        this.user=response;
        binding.tvstarsSmt.setText(AppUtils.getFormatedString(StarRankingApp.getDataManager().get(PREF_USER_STARS, "0")));
    }
}