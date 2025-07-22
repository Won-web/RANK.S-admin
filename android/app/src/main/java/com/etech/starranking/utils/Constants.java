package com.etech.starranking.utils;

import android.os.ParcelUuid;

import com.etech.starranking.BuildConfig;
import com.etech.starranking.data.network.AppApiHelper;

public class Constants {
    public static final String SUCCESS_CODE_STRING = "success";
    public static final int FAIL_CODE = 0;
    public static final int SUCCESS_CODE = 1;
    public static final int CANCEL_CODE = -1;
    public static final int FAIL_INTERNET_CODE = -2;
    public static final int PERMISSION_CODE = 101;
    public static final int UPDATE_VERSION_CODE= -3;
    public static final int UNAUTHORIZED_USER=3;
    public static final String RES_MSG_KEY = "res_message";
    public static final String RES_CODE_KEY = "res_code";
    public static final String RES_DATA_KEY = "res_data";
    public static final String RES_HAS_MORE = "has_more_page";
    public static final String RES_HAS_UPGRADE="upgrade";
    public static final String RES_HAS_UPGRADE_ANDROID="Android";
    public static final String IS_VERSION_DIFFRENT="isVersionDifferent";
    public static final String FORCE_UPDATE_APP="forceUpdateApp";
    public static final String MESSAGE_TYPE="MessageType";
    public static final String URL="URL";
    public static final String UPDATE_BUTTON_TITLE="update_button_title";
    public static final String SKIP_BUTTON="Skip";


    public static String OAUTH_CLIENT_ID = "Ow8X_ktpUNHrqUM1CYEY";
    public static String OAUTH_CLIENT_SECRET = "cc8IXaUPpq";
    public static String OAUTH_CLIENT_NAME = "네이버 아이디로 로그인";

    public static final String STARSHOP_URL = AppApiHelper.BASE_URL + "purchaseStarWebView?language="+AppUtils.LANGUAGE_DEFAULT_VALUE+"&os=Android";
    public static final String CHARGINGSTATION_URL = "purchaseStarWebView?language="+AppUtils.LANGUAGE_DEFAULT_VALUE;
    public static final String HOWTOUSE_URL = "howToUseWebView?language="+AppUtils.LANGUAGE_DEFAULT_VALUE;
    public static final String TERMS_URL = "termsAndConditionWebView?language="+AppUtils.LANGUAGE_DEFAULT_VALUE;


    public static final int MIN_BUFFER_DURATION = 3000;
    public static final int MAX_BUFFER_DURATION = 5000;
    public static final int MIN_PLAYBACK_START_BUFFER = 1500;
    public static final int MIN_PLAYBACK_RESUME_BUFFER = 5000;

    public static final String webUrl = AppApiHelper.BASE_URL + "underConstruction";
    public static final String Terms_webUrl = AppApiHelper.BASE_URL + "termsAndCondSignUp";
    public static final String privacy_webUrl = AppApiHelper.BASE_URL + "privacyPolicyForSignUp";
    public static final int NOTIFICATION_ID = 101;
    public static final String INTENT_NOTIFFICATION_TYPE = "notification_Type";
    public static final String INTENT_FILTER_RECEIVER_NOTIFICATION = BuildConfig.APPLICATION_ID + "." + "CUSTOM_NOTIFICATION";

    public static final String SYNC_PENDING = "pending";
    public static final String SYNC_DONE = "done";

    public static final int MAX_MEDIA_IMAGE_COUNT = 10;
    public static final int MAX_MEDIA_VIDEO_COUNT = 0;

    public static final String MEDIA_TYPE_IMAGE = "image";
    public static final String MEDIA_TYPE_VIDEO = "video";
    public static final String MEDIA_TYPE_YOUTUBE="youtube";

    public static final int MAX_VIDEO_LENGTH = 1 * 60;

    public static final String LOGIN_TYPE_FACEBOOK = "facebook";
    public static final String LOGIN_TYPE_GOOGLE = "google";
    public static final String LOGIN_TYPE_KAKAO = "kakao";
    public static final String LOGIN_TYPE_NAVER = "naver";
    public static final String LOGIN_TYPE_AUTH = "auth";

    public static final String CONTEST_STATUS_PREPARING = "preparing";
    public static final String CONTEST_STATUS_OPEN = "open";
    public static final String CONTEST_STATUS_CLOSE = "close";

    public static final String OS_ANDROID = "Android";
    public static final String OS_ANDROID_ALL_CAP="ANDROID";

    public static final String LB_TYPE_STAR_UPDATED="starUpdated";
    public static final String LB_TYPE_GENERAL="generalNotification";

    public static final String CHANNEL_ID="serverDataNotificationChannel";
    public static final String CHANNEL_ID_SILENT="silent";

    public static final String LB_KEY_MESSAGE="message";

    public static final String PS_SUCCESS="success";
    public static final String PS_PENDING="pending";
    public static final String PS_CANCEL="cancel";
    public static final String PS_PRODUCT_FAIL="productfail";
    public static final String PS_CONSUME_FAIL="consumefail";
    public static final String PS_FAIL="fail";
    public static final String PS_PURCHASE_COMPLETED="paymentcompleted";

    public static final String VOTE="Vote";
    public static final String GIFT="Gift";
    public static String IsActivityStart="false";
    public static final String YES="yes";

}
