package com.etech.starranking.ui.activity.ui.dashboard.webview;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.base.BaseFragment;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.databinding.NavWebviewBinding;
import com.etech.starranking.utils.Constants;


public class WebviewFragment extends BaseFragment {

    NavWebviewBinding binding;

    public WebviewFragment() {


    }


    public static WebviewFragment newInstance(Bundle bundle) {
        WebviewFragment fragment = new WebviewFragment();
        if (bundle != null)
            fragment.setArguments(bundle);
        return fragment;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = DataBindingUtil.inflate(inflater, R.layout.nav_webview, container, false);
        binding.wv.clearCache(true);
        binding.wv.getSettings().setAppCacheEnabled(false);
        binding.wv.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        binding.wv.setWebViewClient(new WebviewFragment.myWebClient());
        binding.wv.getSettings().setJavaScriptEnabled(true);

        binding.wv.getSettings().setUseWideViewPort(true);
        binding.wv.getSettings().setLoadWithOverviewMode(true);
        binding.wv.getSettings().setBuiltInZoomControls(true);
        binding.wv.getSettings().setSupportZoom(true);

        binding.wv.loadUrl(AppApiHelper.BASE_URL + Constants.HOWTOUSE_URL);
        if(getActivity() instanceof BaseActivity){
            ((BaseActivity) getActivity()).checkInternetAndShowNoInternetDialog();
        }
        return binding.getRoot();
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

}