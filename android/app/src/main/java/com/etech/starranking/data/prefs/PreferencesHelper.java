
package com.etech.starranking.data.prefs;


import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.LoginProfile;

public interface PreferencesHelper {

    String get(String key, String defaultValue);

    void set(String key, String value);

    void setBoolean(String key, boolean value);

    boolean getBoolean(String key, boolean defaultValue);

    void setint(String key, int value);

    int getint(String key, int defaultValue);

    void setLong(String key, long value);

    long getLong(String key, long defaultValue);

//    void clear();

    void remove(String key);

    //    void setAppPref(String key, String value);
//
//    String getAppPref(String key, String defaultValue);
//
    void setBooleanAppPref(String key, boolean value);

    //
    boolean getBooleanAppPref(String key, boolean defaultValue);

    void saveUserToPref(LoginProfile user);
    void saveUserEmail(String email);
    void setUserId(String userId);

    LoginProfile getUserFromPref();
    LoginProfile getUserEmail();
    EmailOtpVerify getUserId();
    void setResponseOfSkipButton(String skipButton);
    String getSkipButtonResponse();

}
