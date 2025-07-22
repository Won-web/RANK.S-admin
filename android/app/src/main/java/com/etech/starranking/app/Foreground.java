package com.etech.starranking.app;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_IsAutoLogin;

public class Foreground implements Application.ActivityLifecycleCallbacks {

    private static Foreground instance;
    private static Context appCtx;

    public static Foreground init(Application application) {
        appCtx = application.getApplicationContext();
        if (instance == null) {
            instance = new Foreground();

            application.registerActivityLifecycleCallbacks(instance);
        }

        return instance;
    }

    public static Foreground get(Context ctx) {
        if (instance == null) {
            appCtx = ctx.getApplicationContext();
            if (appCtx instanceof Application) {
                init((Application) appCtx);
            }
            throw new IllegalStateException("IllegalException");
        }
        return instance;
    }

    public static Foreground get() {
        return instance;
    }


    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {

    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {
//        Log.d("app", "resumed");
    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
//        Log.d("app", "paused");
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {
//        Log.d("app", "stopped");
    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {
        boolean isAutologin = StarRankingApp.getDataManager().getBoolean(PREF_IsAutoLogin, false);

        if (!isAppOnForeground(appCtx)) {
            if (!isAutologin) {
                StarRankingApp.getDataManager().logout();
            }

        }

    }

    private boolean isAppOnForeground(Context context) {
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
        if (appProcesses == null) {
            return false;
        }
        final String packageName = context.getPackageName();
        for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
            if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND && appProcess.processName.equals(packageName)) {
                return true;
            }
        }
        return false;
    }

}
