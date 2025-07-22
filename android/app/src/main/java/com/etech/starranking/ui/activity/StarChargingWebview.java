package com.etech.starranking.ui.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityStarChargingWebviewBinding;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.dashboard.starShop.StarShopFragment;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class StarChargingWebview extends BaseActivity {
    public static final String ARG_CONTEST_ID="arg_StarChargingWebview_contestId";
//        implements View.OnTouchListener, Handler.Callback {

    ActivityStarChargingWebviewBinding binding;

    //    static final int CLICK_ON_WEBVIEW = 1;
//    private static final int CLICK_ON_URL = 2;
//unused
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        AppUtils.gradientStatusbar(StarChargingWebview.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_star_charging_webview);
        setupView(binding.extraViews);
        Bundle bundle = new Bundle();
        bundle.putString(StarShopFragment.ARG_CONTEST_ID,getIntent().getStringExtra(ARG_CONTEST_ID));

        addFragment(StarShopFragment.newInstance(bundle), false, false);
        binding.toolbar.ibCharge.setVisibility(View.GONE);
        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
//        binding.web.getSettings().setJavaScriptEnabled(true);
//        binding.web.loadUrl("http://etechservices.biz/rankingstar/api/purchaseStarWebView?language=english&os=Android");
//        binding.tvstarsSmt.setText(user.getRemaining_star());
//        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                onBackPressed();
//            }
//        });
//        binding.toolbar.ibCharge.setVisibility(View.GONE);
//
//        binding.web.addJavascriptInterface(new WebAppInterface(this), "Android");

    }

//    public class WebAppInterface {
//        Context mContext;
//
//        WebAppInterface(Context c) {
//            mContext = c;
//        }
//
//        @JavascriptInterface
//        public void showToast(String toast) {
////            Toast.makeText(mContext, toast, Toast.LENGTH_SHORT).show();
//            //btn-toll
//            //btn-attendance
//            //btn-free-charging
//            //btn-shop
//            //btn-coupon
//            //btn-gift
//
//            if (toast.toString().equals("btn-toll")) {
//                Intent i = new Intent(mContext, PaidChargingActivity.class);
//                startActivity(i);
//            }
//            if (toast.toString().equals("btn-attendance")) {
//                //pop up attendance check
//
//
////                if (!user.getUser_id().equals("")) {
////                    showdialog(mContext, R.layout.popup_layout_attendance_check);
////                } else {
////                    Toast.makeText(mContext, "You have to Login first", Toast.LENGTH_SHORT).show();
////                }
//
//            }
//            if (toast.toString().equals("btn-free-charging")) {
//                //webview
//                Intent i = new Intent(mContext, SampleWebview.class);
//                i.putExtra("from", "fromTabs");
//                startActivity(i);
//            }
//            if (toast.toString().equals("btn-shop")) {
//                //webview
//                Intent i = new Intent(mContext, SampleWebview.class);
//                i.putExtra("from", "fromTabs");
//                startActivity(i);
//            }
//            if (toast.toString().equals("btn-coupon")) {
//                //webview
//                Intent i = new Intent(mContext, SampleWebview.class);
//                i.putExtra("from", "fromTabs");
//                startActivity(i);
//            }
//            if (toast.toString().equals("btn-gift")) {
//                //popup gift
//                if (!user.getUser_id().equals("")) {
//                    showGiftdialog(mContext, R.layout.popup_sendstar);
//                } else {
//                    Toast.makeText(mContext, "You have to Login first", Toast.LENGTH_SHORT).show();
//                }
//
//            }
//        }
//
//    }

//    public void showdialog(Context context, int layoput) {
//        final Dialog dialog = new Dialog(context);
//
//        dialog.setContentView(layoput);
//
//        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
//        dialog.setCancelable(false);
//        final AppCompatTextView tvbar = (AppCompatTextView) dialog.findViewById(R.id.tvbar);
//        final AppCompatTextView tvtitleBeforeconfirm = (AppCompatTextView) dialog.findViewById(R.id.tvtitleBeforeconfirm);
//        final AppCompatTextView bottomTxtBeforeConfrim = (AppCompatTextView) dialog.findViewById(R.id.bottomTxtBeforeConfrim);
//        final AppCompatTextView bottomTxtAfterConfrim = (AppCompatTextView) dialog.findViewById(R.id.bottomTxtAfterConfrim);
//        final AppCompatTextView tvtitleAfterconfirm = (AppCompatTextView) dialog.findViewById(R.id.tvtitleAfterconfirm);
//
//        final RelativeLayout rlEarnedStar = (RelativeLayout) dialog.findViewById(R.id.rlEarnedStar);
//
//
//        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);
//
//
//        btnConfirm.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//
//                btnConfirm.setVisibility(View.GONE);
//                bottomTxtAfterConfrim.setVisibility(View.VISIBLE);
//                tvtitleAfterconfirm.setVisibility(View.VISIBLE);
//                bottomTxtBeforeConfrim.setVisibility(View.GONE);
//                rlEarnedStar.setVisibility(View.GONE);
//                tvtitleBeforeconfirm.setVisibility(View.GONE);
//
//
//            }
//        });
//
//
//
//        tvbar.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//            }
//        });
//
//
//        dialog.show();
//    }

//    public void showGiftdialog(Context context, int layoput) {
//        final Dialog dialog = new Dialog(context);
//        dialog.setContentView(layoput);
//        dialog.getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
//        dialog.setCancelable(false);
//        final AppCompatTextView votebar = (AppCompatTextView) dialog.findViewById(R.id.bar);
//        final AppCompatTextView tvpopupStarsAmt = (AppCompatTextView) dialog.findViewById(R.id.tvpopupStarsAmt);
//        final AppCompatEditText giftNo = (AppCompatEditText) dialog.findViewById(R.id.giftMobileNo);
//        final AppCompatEditText giftVotesAmt = (AppCompatEditText) dialog.findViewById(R.id.giftVotesAmt);
//        final AppCompatTextView btn = (AppCompatTextView) dialog.findViewById(R.id.giftbtnUseAll);
//        final AppCompatButton btnConfirm = (AppCompatButton) dialog.findViewById(R.id.btnConfirm);
//
//
//        LoginProfile user = StarRankingApp.getDataManager().getUserFromPref();
//
//        tvpopupStarsAmt.setText(user.getRemaining_star());
//        btn.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                giftVotesAmt.setText(user.getRemaining_star());
//            }
//        });
//
//
//        votebar.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//            }
//        });
//        btnConfirm.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dialog.dismiss();
//            }
//        });
//
//        dialog.show();
//    }

    @Override
    public void onReceiverNotification(Context context, String type, Intent intent) {
        super.onReceiverNotification(context, type, intent);

    }
}