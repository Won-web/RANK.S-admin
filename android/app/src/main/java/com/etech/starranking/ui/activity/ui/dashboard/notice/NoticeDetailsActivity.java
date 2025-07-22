package com.etech.starranking.ui.activity.ui.dashboard.notice;

import android.os.Bundle;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.databinding.ActivityNoticeDetailsBinding;
import com.etech.starranking.ui.activity.SampleWebViewActivity;
import com.etech.starranking.utils.AppUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class NoticeDetailsActivity extends BaseActivity {

    String noticeTitle, noticedate, noticeContent;
    ActivityNoticeDetailsBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppUtils.gradientStatusbar(NoticeDetailsActivity.this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_notice_details);
        Bundle extras = getIntent().getExtras();

        binding.toolbar.ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        binding.toolbar.ibCharge.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppUtils.callStarChargigWebview(NoticeDetailsActivity.this);
            }
        });
        if (extras != null) {
            noticeTitle = extras.getString("noticeTitle", "");
            noticedate = extras.getString("noticeDate", "");


            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            Date newDate = null;
            try {
                newDate = format.parse(noticedate);
            } catch (ParseException e) {
            }

            format = new SimpleDateFormat("yyyy.MM.dd");
            String date = format.format(newDate);

            noticeContent = extras.getString("noticeContent", "");

            binding.tvDeatilNoticeTitle.setText(noticeTitle);
            binding.tvDetailNoticeTime.setText(date);
            binding.tvDeatilNoticeContent.setText(noticeContent);
        }
        WebView webView=binding.webView;
        webView.clearCache(true);
        webView.getSettings().setAppCacheEnabled(false);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);

        webView.setWebViewClient(new WebViewClient(){
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                NoticeDetailsActivity.this.hideLoader();
            }
        });
        webView.setWebChromeClient(new WebChromeClient());
        webView.getSettings().setJavaScriptEnabled(true);
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
        webView.loadUrl(getIntent().getStringExtra("noticeUrl"));
        showLoader();


    }
}
