package com.etech.starranking.app;

import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.util.Log;
import android.webkit.WebView;

import androidx.appcompat.app.AppCompatDelegate;
import androidx.multidex.MultiDexApplication;

import com.etech.starranking.data.AppDataManager;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.database.room.AppDbHelper;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.ui.activity.ui.update.ActivityUpdateAvailable;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.facebook.FacebookSdk;
import com.google.firebase.FirebaseApp;
import com.google.firebase.iid.FirebaseInstanceId;
//import com.iknow.android.VideoTimmer;
import com.kakao.auth.ApprovalType;
import com.kakao.auth.AuthType;
import com.kakao.auth.IApplicationConfig;
import com.kakao.auth.ISessionConfig;
import com.kakao.auth.KakaoAdapter;
import com.kakao.auth.KakaoSDK;
import com.yariksoffice.lingver.Lingver;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Locale;


public class StarRankingApp extends MultiDexApplication {
    public static Location globleLocation = null;
    public static Context appContext;

    private static DataManager dataManager;


    private static class KakaoSDKAdapter extends KakaoAdapter {


        @Override
        public ISessionConfig getSessionConfig() {
            return new ISessionConfig() {
                @Override
                public AuthType[] getAuthTypes() {
                    return new AuthType[]{AuthType.KAKAO_LOGIN_ALL};
                }

                @Override
                public boolean isUsingWebviewTimer() {
                    return false;
                }

                @Override
                public boolean isSecureMode() {
                    return false;
                }

                @Override
                public ApprovalType getApprovalType() {
                    return ApprovalType.INDIVIDUAL;
                }

                @Override
                public boolean isSaveFormData() {
                    return true;
                }
            };
        }

        @Override
        public IApplicationConfig getApplicationConfig() {
            return new IApplicationConfig() {
                @Override
                public Context getApplicationContext() {
                    return StarRankingApp.appContext;
                }
            };
        }
    }


    @Override
    public void onCreate() {
        super.onCreate();
        appContext = getApplicationContext();
        KakaoSDK.init(new KakaoSDKAdapter());
//        VideoTimmer.init(getApplicationContext());

        try {
            new WebView(this).destroy();
        } catch (Exception e) {
        }

        dataManager = new AppDataManager(this, new AppApiHelper(), new AppDbHelper(), new AppPreferencesHelper(this));
        FirebaseApp.initializeApp(this);
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
        AppUtils.LANGUAGE_DEFAULT_VALUE = "korean";
        Locale locale = new Locale("ko");
       //  AppUtils.LANGUAGE_DEFAULT_VALUE="english";
       //  Locale locale = new Locale("en");
        Lingver.init(this, locale);
        Lingver.getInstance().setLocale(getApplicationContext(), locale);

        Foreground forground = Foreground.init(this);
        FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(instanceIdResult -> {
//            doRegisterDevice(langugae, baseRes.getLogin().getUser_id(), instanceIdResult.getToken());
            Log.d(TAG, "onCreate: fcm token: " + instanceIdResult.getToken());
        });
    }

    private static final String TAG = "StarRankingApp";

    public static DataManager getDataManager() {
        return dataManager;
    }

    public static void updateApp(JSONObject updateAndroid) throws JSONException {


        if (((updateAndroid.getJSONObject(Constants.RES_HAS_UPGRADE_ANDROID)).getString(Constants.IS_VERSION_DIFFRENT)).equals(Constants.YES)) {
            if (((updateAndroid.getJSONObject(Constants.RES_HAS_UPGRADE_ANDROID)).getString(Constants.FORCE_UPDATE_APP)).equals(Constants.YES)) {
                StarRankingApp.getDataManager().setResponseOfSkipButton("false");
                Intent intent = new Intent(StarRankingApp.appContext, ActivityUpdateAvailable.class);
                intent.putExtra("UpdateData", updateAndroid.toString());
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                StarRankingApp.appContext.startActivity(intent);
               // StarRankingApp.appContext.startActivity(intent);

            } else {

                if (!StarRankingApp.getDataManager().getSkipButtonResponse().equals("true")) {
                    Intent intent = new Intent(StarRankingApp.appContext, ActivityUpdateAvailable.class);
                    intent.putExtra("UpdateData", updateAndroid.toString());
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    StarRankingApp.appContext.startActivity(intent);
                }

            }

        }


    }


}
