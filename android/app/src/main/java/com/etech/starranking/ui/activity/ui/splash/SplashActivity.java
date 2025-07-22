package com.etech.starranking.ui.activity.ui.splash;

import android.app.NotificationManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;

import com.etech.starranking.R;
import com.etech.starranking.base.BaseActivity;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.databinding.ActivitySplashBinding;
import com.etech.starranking.ui.activity.ui.dashboard.DashboardActivity;
import com.etech.starranking.ui.activity.ui.dashboard.home.ContestantDetailsFragmentActivity;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
//import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
//import com.google.firebase.dynamiclinks.PendingDynamicLinkData;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

public class SplashActivity extends BaseActivity {

    ActivitySplashBinding binding;
    private static final String TAG = "SplashActivity";
    boolean isDeepLinked = false;
    String contestId = null, contestantId = null;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_splash);
        initUI();
        testMe();
    }

    private void testMe() {
//        Log.d(TAG,"encoded "+ md5("123456"));


    }


    /*  @Override
      protected void onPause() {
          super.onPause();

      }
  */
    private void initUI() {

        checkAndSetDeepLink();
//        getdeviceinfo();
//        Glide.with(SplashActivity.this)
//                .asGif()
//                .load(R.raw.rankingstar_splash_eng)
//                .into(imageView);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {

                Intent i = new Intent(SplashActivity.this, DashboardActivity.class);
                startActivity(i);
                if (isDeepLinked) {
                    startContestantDetailsActivity(contestId, contestantId);
                }
                opemMyCustomActivity();
                // startContestantDetailsActivity("1", "1");

            }
        }, 1600);
    }

    private void opemMyCustomActivity() {


    }

    @Override
    protected void onRestart() {
        super.onRestart();
        Log.d(TAG, "onRestart: ");
        if (binding != null)
            binding.splashLogo.setImageResource(0);
    }

   /* @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "onStart: ");
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d(TAG, "onResume: ");
    }*/

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Log.d(TAG, "onNewIntent: ");
        setIntent(intent);
        initUI();
    }

    private void checkAndSetDeepLink() {
        Intent intent = getIntent();
        String action = intent.getAction();
        Uri data = intent.getData();
        Log.d(TAG, "checkAndSetDeepLink: " + intent);
        Log.d(TAG, "checkAndSetDeepLink: " + action);
        Log.d(TAG, "checkAndSetDeepLink: " + data);
//        Uri targetUrl =                AppLinks.getTargetUrlFromInboundIntent(this, getIntent());
//        if (targetUrl != null) {
//            Log.i(TAG, "App Link Target URL: " + targetUrl.toString());
//        }
        if (data != null) {
            String contestId = data.getQueryParameter("contest_id");
            String contestantId = data.getQueryParameter("contestant_id");
            if (contestantId != null && contestId != null && !contestantId.isEmpty() && !contestId.isEmpty()) {
                isDeepLinked = true;
                this.contestantId = contestantId;
                this.contestId = contestId;
            }
        }
/*        FirebaseDynamicLinks.getInstance()
                .getDynamicLink(getIntent())
                .addOnSuccessListener(this, new OnSuccessListener<PendingDynamicLinkData>() {
                    @Override
                    public void onSuccess(PendingDynamicLinkData pendingDynamicLinkData) {
                        // Get deep link from result (may be null if no link is found)
                        Uri deepLink = null;
                        if (pendingDynamicLinkData != null) {
                            deepLink = pendingDynamicLinkData.getLink();
                        }
                        if (deepLink != null) {
                            String contestId = deepLink.getQueryParameter("contest_id");
                            String contestantId = deepLink.getQueryParameter("contestant_id");
                            if (contestantId != null && contestId != null && !contestantId.isEmpty() && !contestId.isEmpty()) {
                                isDeepLinked = true;
                                SplashActivity.this.contestantId = contestantId;
                                SplashActivity.this.contestId = contestId;
                            }
                        }
                    }
                })
                .addOnFailureListener(this, new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Log.w(TAG, "getDynamicLink:onFailure", e);
                    }
                });*/
    }

    private void startContestantDetailsActivity(String contestId, String contestantId) {
        Intent startIntent = new Intent(this, ContestantDetailsFragmentActivity.class);
        startIntent.putExtra("contestid", contestId);
        startIntent.putExtra("contestantid", contestantId);
        startActivity(startIntent);
    }

  /*  public static String getKeyHash(final Context context) {
        PackageInfo packageInfo = getPackageInfo(context, PackageManager.GET_SIGNATURES);
        if (packageInfo == null)
            return null;

        for (Signature signature : packageInfo.signatures) {
            try {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
                return Base64.encodeToString(md.digest(), Base64.NO_WRAP);
            } catch (NoSuchAlgorithmException e) {
                Log.w(TAG, "Unable to get MessageDigest. signature=" + signature, e);
            }
        }
        return null;
    }*/


}
