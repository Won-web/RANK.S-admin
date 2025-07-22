package com.etech.starranking.ui.activity;

import android.content.Context;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.SampleWebviewBinding;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.dashboard.starShop.PaidChargingActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;

public class SampleWebViewActivity extends BaseActivity {

    public static final String ARG_URL = "arg_SampleWebview_url";
    public static final String ARG_FROM = "from";
    private static final String TAG = "SampleWebViewActivity";

    private WebView webView;
    SampleWebviewBinding binding;

    String subbanerWebview;
    String homepgWebview;
    String argFrom;

    @Override
    public void titleClicked() {
//        super.titleClicked();
        if (isBackEnabled) {
            Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
            startActivity(i);
            finishAffinity();
        } else {
            AppUtils.setToast(SampleWebViewActivity.this, getString(R.string.str_msg_please_wait_timer_is_running));
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(SampleWebViewActivity.this);
        binding = DataBindingUtil.setContentView(SampleWebViewActivity.this, R.layout.sample_webview);
        checkInternetAndShowNoInternetDialog();
        webView = (WebView) findViewById(R.id.wv_sample);
        webView.clearCache(true);
        webView.getSettings().setAppCacheEnabled(true);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webView.setWebViewClient(new myWebClient());
        webView.setWebChromeClient(new WebChromeClient());
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);
        webView.getSettings().setLoadsImagesAutomatically(true);
        webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);

        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setDisplayZoomControls(false);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.getSettings().setUseWideViewPort(true);


        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setSupportZoom(true);




        webView.setInitialScale(1);
        webView.getSettings().setDefaultZoom(WebSettings.ZoomDensity.FAR);

        Bundle extras = getIntent().getExtras();
        argFrom = extras.getString(ARG_FROM, "");

        if (getIntent().getExtras() != null) {
//            if (from_terms_or_other.equals("terms")) {
//                webView.loadUrl(AppApiHelper.BASE_URL + Constants.TERMS_URL);
//
//                binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.white));
//
//                binding.toolbar. .setText(getString(R.string.str_lbl_view_details));
//                binding.toolbar.tvTitle.setTextColor(getResources().getColor(R.color.black));
////                binding.toolbar.ibClose.setVisibility(View.VISIBLE);
//                binding.toolbar.ibClose.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.black)));
//                binding.toolbar.ibCharge.setVisibility(View.GONE);
//                binding.btnGoToContestantList.setVisibility(View.GONE);
//                binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.black)));
//                getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.white));
//            }
//            else
            if (argFrom.equals("Contestbanner")) {
                subbanerWebview = extras.getString("bannerWebview", "");
                homepgWebview = extras.getString("homepgview", "");
                webView.loadUrl(subbanerWebview);
                if (homepgWebview.equals("") || homepgWebview.trim().isEmpty()) {

                    binding.llbtns.setVisibility(View.GONE);
//                    binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                    binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
                    binding.toolbar.ibCharge.setVisibility(View.VISIBLE);
                    binding.toolbar.ibClose.setVisibility(View.GONE);
                    binding.btnGoToContestantList.setVisibility(View.VISIBLE);

                /*    binding.toolbar.tvTitle.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
                            startActivity(i);
                            finishAffinity();
                        }
                    });*/
                } else {
//                    binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                    binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
                    binding.toolbar.ibCharge.setVisibility(View.VISIBLE);
                    binding.toolbar.ibClose.setVisibility(View.GONE);
                    binding.btnGoToContestantList.setVisibility(View.GONE);
                    binding.llbtns.setVisibility(View.GONE);
                    binding.llbtns.setVisibility(View.VISIBLE);

                 /*   binding.toolbar.tvTitle.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
                            startActivity(i);
                            finishAffinity();
                        }
                    });*/
                }
//                getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.colorAccent));

            } else if (argFrom.equals("fromTabs")|| argFrom.equals("fromStarShopTabs")) {
                webView.loadUrl(getIntent().getStringExtra(ARG_URL));
                Log.d(TAG, "onCreate: " + getIntent().getStringExtra(ARG_URL));
//                binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
                binding.toolbar.ibCharge.setVisibility(View.GONE);
                binding.toolbar.ibClose.setVisibility(View.GONE);
                binding.btnGoToContestantList.setVisibility(View.GONE);
                binding.llbtns.setVisibility(View.GONE);

             /*   binding.toolbar.tvTitle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
                        startActivity(i);
                        finishAffinity();
                    }
                });*/
//                getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.colorAccent));
            } else if (argFrom.equals("fromFreeChargingTabs")) {
                webView.loadUrl(getIntent().getStringExtra(ARG_URL));
                Log.d(TAG, "onCreate: " + getIntent().getStringExtra(ARG_URL));
                binding.toolbar.ibCharge.setVisibility(View.GONE);
                binding.toolbar.ibClose.setVisibility(View.GONE);
                binding.btnGoToContestantList.setVisibility(View.GONE);

                binding.llbtns.setVisibility(View.GONE);
                binding.toolbar.getRoot().setVisibility(View.GONE);
                webView.addJavascriptInterface(new WebAppInterface(this),"Android");

            } else if (argFrom.equals("signinterms")) {
                webView.loadUrl(Constants.Terms_webUrl);
                Log.d(TAG, "onCreate: " + Constants.Terms_webUrl);
//                binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
                binding.toolbar.ibCharge.setVisibility(View.GONE);
                binding.toolbar.ibClose.setVisibility(View.GONE);
                binding.btnGoToContestantList.setVisibility(View.GONE);
                binding.llbtns.setVisibility(View.GONE);

            /*    binding.toolbar.tvTitle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
                        startActivity(i);
                        finishAffinity();
                    }
                });*/
//                getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.colorAccent));
            } else if (argFrom.equals("signinprivacy")) {
                webView.loadUrl(Constants.privacy_webUrl);
                Log.d(TAG, "onCreate: " + Constants.privacy_webUrl);
//                binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
                binding.toolbar.ibCharge.setVisibility(View.GONE);
                binding.toolbar.ibClose.setVisibility(View.GONE);
                binding.btnGoToContestantList.setVisibility(View.GONE);
                binding.llbtns.setVisibility(View.GONE);

               /* binding.toolbar.tvTitle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
                        startActivity(i);
                        finishAffinity();
                    }
                });*/
//                getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.colorAccent));
            } else if (argFrom.equals("notice")) {
                webView.loadUrl(getIntent().getStringExtra(ARG_URL));
                Log.d(TAG, "onCreate: " + getIntent().getStringExtra(ARG_URL));
//                binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//                binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
                binding.toolbar.ibCharge.setVisibility(View.GONE);
                binding.toolbar.ibClose.setVisibility(View.GONE);
                binding.btnGoToContestantList.setVisibility(View.GONE);
                binding.llbtns.setVisibility(View.GONE);

            /*    binding.toolbar.tvTitle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent i = new Intent(getApplicationContext(), DashboardActivity.class);
                        startActivity(i);
                        finishAffinity();
                    }
                });*/
//                getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.colorAccent));
            }
        } else if (extras == null) {
            webView.loadUrl(Constants.webUrl);
//            binding.toolbar.tool.setBackgroundColor(getResources().getColor(R.color.colorAccent));
//            binding.toolbar.ibBack.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(R.color.white)));
            binding.toolbar.ibCharge.setVisibility(View.VISIBLE);
            binding.toolbar.ibClose.setVisibility(View.GONE);
            binding.btnGoToContestantList.setVisibility(View.GONE);
            binding.llbtns.setVisibility(View.GONE);
//            getWindow().setStatusBarColor(ContextCompat.getColor(this, R.color.colorAccent));


        }


        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(SampleWebViewActivity.this);
            }
        });
        binding.btnGoToContestantList.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        binding.btnGoToContestantListhp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        binding.btnGoTohOmepg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                webView.loadUrl(homepgWebview);
            }
        });

    }


    public class myWebClient extends WebViewClient {
        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            Log.d(TAG, "onPageStarted: ");
            super.onPageStarted(view, url, favicon);
        }

        @Nullable
        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
            Log.d(TAG, "shouldInterceptRequest: "+url);
            return super.shouldInterceptRequest(view, url);
        }

        @Nullable
        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
           // Log.d(TAG, "shouldInterceptRequest: "+request.getUrl());
            return super.shouldInterceptRequest(view, request);
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            Log.d(TAG, "shouldOverrideUrlLoading Older: " + url);
            view.loadUrl(url);
            return true;

        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
          //  Log.d(TAG, "shouldOverrideUrlLoading Newer: " + request.getUrl());
            return super.shouldOverrideUrlLoading(view, request);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            Log.d(TAG, "onPageFinished: url " + url);
            super.onPageFinished(view, url);
            binding.progressBar1.setVisibility(View.GONE);
            if (StarRankingApp.getDataManager().getAdUrl().getPath().equals(Uri.parse(url).getPath())) {
                Log.d(TAG, "onPageFinished: same path disable back button for 10 seconds");
                isBackEnabled = false;
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        isBackEnabled = true;
                    }
                }, 10000);
            }
        }


    }

    boolean isBackEnabled = true;

    @Override
    public void onBackPressed() {
        if(argFrom.equals("fromStarShopTabs")){
            if(webView.canGoBack()){
                webView.goBack();
            }else{
                super.onBackPressed();
            }
        }else  if (!argFrom.equals("fromFreeChargingTabs")) {
            if (isBackEnabled) {
            /*if (!"Contestbanner".equals(argFrom) && webView.canGoBack()) {
                webView.goBack();
            } else {*/

                super.onBackPressed();
                /*}*/
            } else {
                AppUtils.setToast(this, getString(R.string.str_msg_please_wait_timer_is_running));
            }
        }
    }


    public class WebAppInterface {

        Context mContext;

        WebAppInterface(Context c) {
            mContext = c;
        }

        @JavascriptInterface
        public void showToast(String toast) {
            finish();

        }

    }
}
