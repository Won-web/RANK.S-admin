
package com.etech.starranking.data.prefs;

import android.content.Context;
import android.content.SharedPreferences;


import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;


public class AppPreferencesHelper implements PreferencesHelper {

    public static final String PREF_USER_ID = "user_id2";
    public static final String PREF_APP_VERNAME = "appVerName";
    public static final String PREF_APP_VERCODE = "appVerCode";
    public static final String PREF_DEVICE_MODEL_NAME = "modelName";
    public static final String PREF_DEVICE_BRANDNAME = "brandName";
    //    public static final String PREF_DEVICE_UUID = "device_uid";
    public static final String PREF_DEVICE_VEROS = "device_ver_os";
    public static final String PREF_IS_PUSH_IN_APP = "is_push_in_app";
    public static final String PREF_USER_EMAIL = "user_email";
    public static final String PREF_USER_MOBILE = "user_mob";
    public static final String PREF_USERTYPE = "user_usertype";
    public static final String PREF_USER_AUTOLOGIN = "user_autologin";
    public static final String PREF_USER_LOGINTYPE = "user_logintype";
    public static final String PREF_USER_NAME = "user_name";
    public static final String PREF_USER_NICKNAME = "user_nickname";
    public static final String PREF_USER_PROFILEURL = "user_profileurl";
    public static final String PREF_USER_STARS = "user_stars";
    public static final String APP_LANGUAGE = "app_language";
    public static final String PREF_IsAutoLogin = "is_autologin";
    public static final String PREF_EMAIL_VERIFY = "user_email_verify";
    public static final String PREF_USER_ID_SET = "user_id_pwd";
    public static final String PREF_SAVE_SKIP_BUTTON_RESPONSE = "skip";
    public static final String PREF_IS_ACTIVITY_START = "false";
    public static final String PREF_REFRESH_TOKEN = "refreshToken";
    public static final String PREF_ACCESS_TOKEN = "accessToken";


    private static String prefFile = "shared_pref";


    private static SharedPreferences mPrefs;


    public AppPreferencesHelper(Context context) {

        mPrefs = context.getSharedPreferences(prefFile, Context.MODE_PRIVATE);
//        mPrefsApp = context.getSharedPreferences(prefFileApp, Context.MODE_PRIVATE);
    }


    @Override
    public String get(String key, String defaultValue) {
        return mPrefs.getString(key, defaultValue);
    }

    @Override
    public void set(String key, String value) {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.putString(key, value);
        editor.commit();
    }

    @Override
    public void setBoolean(String key, boolean value) {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.putBoolean(key, value);
        editor.commit();
    }

    @Override
    public boolean getBoolean(String key, boolean defaultValue) {
        return mPrefs.getBoolean(key, defaultValue);
    }

    @Override
    public void setint(String key, int value) {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.putInt(key, value);
        editor.commit();
    }

    @Override
    public int getint(String key, int defaultValue) {
        return mPrefs.getInt(key, defaultValue);
    }


    public static void clear() {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.clear();
        editor.commit();
    }

    @Override
    public void remove(String key) {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.remove(key);
        editor.commit();
    }

    @Override
    public void setBooleanAppPref(String key, boolean value) {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.putBoolean(key, value);
        editor.commit();
    }

    @Override
    public boolean getBooleanAppPref(String key, boolean defaultValue) {
        return mPrefs.getBoolean(key, defaultValue);
    }

//    @Override
//    public void setAppPref(String key, String value) {
//        SharedPreferences.Editor editor = mPrefsApp.edit();
//        editor.putString(key, value);
//        editor.commit();
//    }
//
//    @Override
//    public String getAppPref(String key, String defaultValue) {
//        return mPrefsApp.getString(key, defaultValue);
//    }
//
//    @Override
//    public void setBooleanAppPref(String key, boolean value) {
//        SharedPreferences.Editor editor = mPrefsApp.edit();
//        editor.putBoolean(key, value);
//        editor.commit();
//    }
//
//    @Override
//    public boolean getBooleanAppPref(String key, boolean defaultValue) {
//        return mPrefsApp.getBoolean(key, defaultValue);
//    }
//
//
//    @Override
//    public void setLong(String key, long value) {
//        SharedPreferences.Editor editor = mPrefsApp.edit();
//        editor.putLong(key, value);
//        editor.commit();
//    }

    @Override
    public long getLong(String key, long defaultValue) {
        return mPrefs.getLong(key, defaultValue);
    }

    @Override
    public void setLong(String key, long value) {
        SharedPreferences.Editor editor = mPrefs.edit();
        editor.putLong(key, value);
        editor.commit();
    }


    public void saveUserToPref(LoginProfile user) {
        set(PREF_USER_ID, user.getUser_id());
        set(PREF_USER_EMAIL, user.getEmail());
        set(PREF_USER_MOBILE, user.getMobile());
        set(PREF_USERTYPE, user.getUser_type());
        set(PREF_USERTYPE, user.getUser_type());
        set(PREF_USER_LOGINTYPE, user.getLogin_type());
        set(PREF_USER_AUTOLOGIN, user.getIs_autologin());
        set(PREF_USER_NAME, user.getName());
        set(PREF_USER_STARS, user.getRemaining_star());
        set(PREF_USER_NICKNAME, user.getNick_name());
        set(PREF_USER_PROFILEURL, user.getMain_image());


//        if (user.getSetting() != null) {
//            setBoolean(PREF_IS_PUSH_ON, user.getSetting().getIs_push_on());
//            setBoolean(PREF_IS_DND_ENABLED, user.getSetting().getIs_dnd_on());
//            set(PREF_IS_DND_START_TIME, user.getSetting().getDnd_start());
//            set(PREF_IS_DND_END_TIME, user.getSetting().getDnd_end());
//        }
    }

    @Override
    public void saveUserEmail(String email) {
        set(PREF_EMAIL_VERIFY, email);
    }

    @Override
    public void setUserId(String userId) {
        set(PREF_USER_ID_SET, userId);
    }

    public LoginProfile getUserEmail() {
        LoginProfile user = new LoginProfile();
        user.setEmail(get(PREF_EMAIL_VERIFY, ""));
        return user;
    }

    @Override
    public EmailOtpVerify getUserId() {
        EmailOtpVerify user = new EmailOtpVerify();
        user.setUser_id(get(PREF_USER_ID_SET, ""));
        return user;
    }

    @Override
    public void setResponseOfSkipButton(String skipButton) {
        set(PREF_SAVE_SKIP_BUTTON_RESPONSE, skipButton);
    }

    @Override
    public String getSkipButtonResponse() {
        return get(PREF_SAVE_SKIP_BUTTON_RESPONSE, "");
    }


    //    public static void saveStars(String user) {
//        set(PREF_USER_STARS, user);
//
//    }
    public LoginProfile getUserFromPref() {
        LoginProfile user = new LoginProfile();
        user.setUser_id(get(PREF_USER_ID, ""));
        user.setEmail(get(PREF_USER_EMAIL, ""));
        user.setMobile(get(PREF_USER_MOBILE, ""));
        user.setUser_type(get(PREF_USERTYPE, ""));
        user.setLogin_type(get(PREF_USER_LOGINTYPE, ""));
        user.setIs_autologin(get(PREF_USER_AUTOLOGIN, ""));
        user.setName(get(PREF_USER_NAME, ""));
        user.setNick_name(get(PREF_USER_NICKNAME, ""));
        user.setMain_image(get(PREF_USER_PROFILEURL, ""));
        user.setRemaining_star(get(PREF_USER_STARS, "0"));
        user.setName(get(PREF_USER_NAME, ""));

        return user;
    }
    //  public static String getStarsOfUser() {
    //        LoginProfile user1 = new LoginProfile();
    //        user1.setRemaining_star(get(PREF_USER_STARS, ""));
    //        return String.valueOf(user1);
    //    }
}
