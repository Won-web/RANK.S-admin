package com.etech.starranking.data.network;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import com.etech.starranking.BuildConfig;
import com.etech.starranking.R;
import com.etech.starranking.app.StarRankingApp;
import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.apiHelper.RestConst;
import com.etech.starranking.data.network.apiHelper.RestHelper;
import com.etech.starranking.data.network.apiHelper.RestResponse;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.CategoryList;
import com.etech.starranking.ui.activity.model.CommentsModel;
import com.etech.starranking.ui.activity.model.ContestDetailAndContestantListModel;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.ContestantList;
import com.etech.starranking.ui.activity.model.ContestantModel;
import com.etech.starranking.ui.activity.model.ContestantVoteHistoryList;
import com.etech.starranking.ui.activity.model.EarningStar;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.EndTransactionModel;
import com.etech.starranking.ui.activity.model.GiftDetailsVm;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.model.NoticeList;
import com.etech.starranking.ui.activity.model.NotificationsList;
import com.etech.starranking.ui.activity.model.OtherContestantDetails;
import com.etech.starranking.ui.activity.model.PaidChargeList;
import com.etech.starranking.ui.activity.model.ContestantMedia;
import com.etech.starranking.ui.activity.model.RestResponseModel;
import com.etech.starranking.ui.activity.model.SearchList;
import com.etech.starranking.ui.activity.model.SettingsModel;
import com.etech.starranking.ui.activity.model.StarDetailsVm;
import com.etech.starranking.ui.activity.model.StarHistory;
import com.etech.starranking.ui.activity.model.SubContestList;
import com.etech.starranking.ui.activity.model.TokenDetails;
import com.etech.starranking.ui.activity.model.TransactionDetails;
import com.etech.starranking.ui.activity.model.UsedStar;
import com.etech.starranking.ui.activity.model.UserFromMobile;
import com.etech.starranking.ui.activity.model.VoteListModel;
import com.etech.starranking.ui.activity.ui.login.LoginActivity;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.etech.starranking.utils.FileUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_ACCESS_TOKEN;
import static com.etech.starranking.data.prefs.AppPreferencesHelper.PREF_REFRESH_TOKEN;
import static com.etech.starranking.utils.Constants.RES_CODE_KEY;
import static com.etech.starranking.utils.Constants.RES_DATA_KEY;
import static com.etech.starranking.utils.Constants.RES_HAS_MORE;

import okhttp3.Credentials;


@SuppressWarnings("Convert2Lambda")
public class AppApiHelper implements ApiHelper {


    ArrayList<ContestSliderContents> homeArrayList = new ArrayList<>();
    ArrayList<SubContestList> subContestLists = new ArrayList<>();
    ArrayList<PaidChargeList> paidChargeList = new ArrayList<>();
    ArrayList<ContestantList> listArrayList = new ArrayList<>();
    ArrayList<ContestantVoteHistoryList> listvoteArrayList = new ArrayList<>();
    ArrayList<ContestantMedia> imageslistArrayList = new ArrayList<>();
    ArrayList<OtherContestantDetails> contestantDetails = new ArrayList<>();
    ArrayList<EarningStar> earnedStarDetails = new ArrayList<>();
    ArrayList<CategoryList> catlist = new ArrayList<>();
    ArrayList<UsedStar> usedStarsDetails = new ArrayList<>();

    ArrayList<CommentsModel> commentDetails = new ArrayList<>();
    ArrayList<NotificationsList> notificationsLists = new ArrayList<>();
    ArrayList<NoticeList> noticeLists = new ArrayList<>();
    Context context;

    private Gson gson = new Gson();
    // public static final String BASE_HOST = "http://php.dss.gos.mybluehostin.me/rankingstar/apis/v2/";/*demo*/

   //  public static final String BASE_HOST = "http://php.dss.gos.mybluehostin.me/rankingstar/";/*demo*/
    // public static final String BASE_HOST = "https://ranking-star.com/";
    //  public static final String BASE_HOST = "https://ranking-star.com/apis/v2/";
    public static final String BASE_HOST = "https://ranking-star.com/apis/v3/";/*live*/
    //Add api in BASE_HOST
    public static final String BASE_URL_SCHEME = "https";
    // public static final String BASE_URL_HOST = "php.dss.gos.mybluehostin.me/rankingstar/";/*demo*//*not working*/
    public static final String BASE_URL_HOST = "ranking-star.com";/*live*/
    public static final String BASE_URL = BASE_HOST;//+ "api/";
    //    static final String CHARGINGSTATION_URL = "purchaseStarWebView?language=english";
    public static final String FREE_CHARGING_URL = "shopping/shop/free_charging.php";/*?uid=USER_ID&uname=USER_NAME&이름=USER_NAME1*/
    public static final String SHOP_URL = "shopping/shop/list.php";/*?ca_id=10&uid=USER_ID&uname=USER_NAME&이름=USER_NAME1*/
    public static final String COUPON_CHARGING_URL = "shopping/shop/cp.php";/*?uid=USER_ID&uname=USER_NAME&이름=USER_NAME1*/
    public static final String AD_URL = "shopping/shop/free_charging_go.php";
    public static final String KEY_UID = "uid";
    public static final String KEY_UNAME = "uname";
    public static final String KEY_UEMAIL = "uemail";
    public static final String KEY_UPHONE = "uphone";
    public static final String KEY_CA_ID = "ca_id";
    public static final String KEY_DEVICE = "device";

    private static final String API_CONTEST_LIST = "getContestList";
    private static final String API_CONTESTANT_LIST = "getContestDetails";
    private static final String API_STAR_HISTORY = "starHistory";
    private static final String API_VOTE_HISTORY = "votingHistory";
    private static final String API_CONTESTANT_DETAIL = "getContestantDetails";
    private static final String API_CONTEST_BANNER_LIST = "getContestBannerList";
    //    private static final String API_SIGNUP = "signup";
//    private static final String API_LOGIN = "login";
    private static final String API_SIGNUP = "userSignUpApp";
    private static final String API_LOGIN = "userLogin";
    private static final String API_GET_TOKEN_FROM_REFRESH_TOKEN = "getTokenFromRefreshToken";
    private static final String API_PROFILE = "getProfileDetails";
    //    private static final String API_ATTENDANCE = "dailyCheckIn";
    private static final String API_ATTENDANCE = "dailyCheckInStar";
    //    private static final String API_REGISTER_DEVICE = "registerDevice";
    private static final String API_REGISTER_DEVICE = "registerDeviceToken";
    private static final String API_DOUBLECHECK = "checkEmailExists";
    private static final String API_SETSETTINGS = "pushSetting";
    private static final String API_GETSETTINGS = "getPushSetting";
    private static final String API_ADDVOTES = "addVote";
    private static final String API_GIFT_STAR = "giftstar";
    private static final String API_CONTESTANT_SEARCH = "contestantBySearch";
    private static final String API_GETDETAILS_GIFT = "getDetailsByPhone";
    private static final String API_PLAN_LIST = "getPlanList";
    private static final String API_NOTICE_LIST = "getNotice";
    private static final String API_NOTIFICATION_LIST = "getNotification";
    private static final String API_EDIT_CONTESTANT_DETAIL = "editContestantDetail";
    private static final String API_CONTESTANT_MEDIA = "getContestantMediaGallary";
    private static final String API_DELETE_GALLERY_ITEM = "deleteGallaryItem";
    private static final String API_EDIT_USER_PROFILE = "editUserProfile";
    //    private static final String API_VERIFYSOCIALMEDIA = "verifySocialMediaLogin";
//    private static final String API_SOCIALLOGIN = "socialLogin";
    private static final String API_VERIFYSOCIALMEDIA = "verifySocialMediaUserLogin";
    private static final String API_SOCIALLOGIN = "socialSignUp";
    private static final String API_UPLOAD_MEDIA = "addGallaryItem";
    //    private static final String API_BEGIN_TRANSACTION = "beginTransaction";
    private static final String API_BEGIN_TRANSACTION = "startTransaction";
    //    private static final String API_COMPLETE_TRANSACTION = "completeTransaction";
    private static final String API_COMPLETE_TRANSACTION = "endTransaction";
    private static final String API_UPDATE_TRANSACTION = "updateTransaction";
    private static final String API_VERIFY_OTP = "verifyOtp";
    private static final String API_RESEND_OTP = "resendOtp";
    private static final String API_SEND_OTP_FOR_FORGOT_PWD = "forgotPassword";
    private static final String API_CREATE_NEW_PASSWORD = "createNewPassword";
    private static final String API_DELETE_ACCOUNT = "deleteUserAccount";


    private static final String TAG = "AppApiHelper";
    private static final String KEY_PAGE_NUMBER = "page";
    private static final String KEY_EMAIL = "email";
    private static final String KEY_PASSWORD = "password";
    private static final String KEY_CURRENT_PWD = "current_password";
    private static final String KEY_AUTOLOGIN = "auto_login";
    private static final String KEY_LOGINTYPE = "login_type";
    private static final String KEY_MOBILE = "mobile";
    private static final String KEY_NAME = "name";
    private static final String KEY_NICK_NAME = "nick_name";
    private static final String KEY_LANGUAGE = "language";
    private static final String KEY_TRANSACTION_ID = "transaction_id";
    private static final String KEY_PAYMENT_STATUS = "payment_status";
    private static final String KEY_DESC = "description";
    private static final String KEY_PAYMENT_TRANSATIONC_ID = "payment_transaction_id";
    private static final String KEY_PAYMENT_DETAILS = "payment_details";
    private static final String KEY_SOCIALID = "social_id";
    private static final String KEY_RECEIVERID = "receiver_id";
    private static final String KEY_SENDERID = "sender_id";
    private static final String KEY_STAR = "star";
    private static final String KEY_SENDERNAME = "sender_name";
    private static final String KEY_MEDIA_ID = "media_id";
    private static final String KEY_DEVICE_ID = "device_id";

    private static final String KEY_terms_condition = "terms_condition";
    private static final String KEY_PRIVACY = "privacy_policy";
    private static final String KEY_NEWS = "newslatter_subscribe";
    private static final String KEY_USERID = "user_id";
    private static final String KEY_PLAN_ID = "plan_id";
    private static final String KEY_AMOUNT = "amount";
    private static final String KEY_USER_TYPE = "user_type";
    private static final String KEY_PUSHALERT = "pushalert";
    private static final String KEY_PUSHSOUND = "pushsound";
    private static final String KEY_PUSHVIBRATE = "pushvibrate";
    private static final String KEY_CONTESTID = "contest_id";
    private static final String KEY_CONTESTANTID = "contestant_id";
    private static final String KEY_VOTERID = "voter_id";
    private static final String KEY_VOTE = "vote";
    private static final String KEY_VOTERNAME = "voter_name";
    private static final String KEY_SEARCH_TERM = "searchTerm";
    private static final String KEY_CLIENT_ID = "client_id";
    private static final String KEY_DEVICE_UID = "device_uid";
    private static final String KEY_DEVICE_TOKEN = "device_token";
    private static final String KEY_DEVICE_NAME = "device_name";
    private static final String KEY_DEVICE_MODEL = "device_model";
    private static final String KEY_DEVICE_VER = "device_version";
    private static final String KEY_APP_NAME = "app_name";
    private static final String KEY_APP_VER = "app_version";
    private static final String KEY_PUSH_ALERT = "push_alert";
    private static final String KEY_PUSH_SOUND = "push_sound";
    private static final String KEY_PUSH_BADGE = "push_badge";
    private static final String KEY_PUSH_VIBRATE = "push_vibrate";
    private static final String KEY_ENV = "environment";
    private static final String KEY_OS = "os";
    private static final String KEY_INTRODUCTION = "introduction";
    private static final String KEY_MAIN_IMAGE = "main_image";
    private static final String KEY_MEDIA_TYPE = "media_type";
    private static final String KEY_MEDIA_PATH = "media_path";
    private static final String KEY_APP_VERSION = "app_version";
    private static final String KEY_GRANT_TYPE = "grant_type";
    private static final String KEY_CLIENT_SECRET = "client_secret";
    private static final String KEY_REFRESH_TOKEN = "refresh_token";
    private static final String KEY_USERNAME = "username";
    public Boolean isNewAccessTokenApiCallRunning = false;

    public AppApiHelper() {
        RestHelper.DEFAULT_BASE_URL = BASE_URL;
    }

    @Override
    public void getHomeSliderList(final Pagging<ContestSliderContents> pagging, final String language, final DataManager.Callback<Pagging<ContestSliderContents>> homcallback) {

        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_PAGE_NUMBER, String.valueOf(pagging.getPageNumber()));

        new RestHelper.Builder()
                .setUrl(API_CONTEST_BANNER_LIST)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                Pagging<ContestSliderContents> pagging1 = new Pagging<>();
                                boolean hasMore = false /*jsonObject.getJSONObject(Constants.RES_DATA_KEY).getBoolean(RES_HAS_MORE)*/;
                                pagging1.setHasMore(hasMore);
                                pagging1.setPageNumber(pagging.getPageNumber() + 1);
                                JSONArray contestListJson = jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("banner_list");
                                pagging1.addItemToList((ArrayList<ContestSliderContents>) gson.fromJson(contestListJson.toString(), new TypeToken<ArrayList<ContestSliderContents>>() {
                                }.getType()));
                                homcallback.onSuccess(pagging1);
                            } catch (Exception e) {
                                e.printStackTrace();
                                homcallback.onFailed(code, message);
                            }
                        } else {
                            homcallback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();


    }

    @Override
    public void getHomeSubContestList(final Pagging<SubContestList> pagging, final String language, final DataManager.Callback<Pagging<SubContestList>> homcallback) {
        Log.d(TAG, "getHomeSubContestList: ");

        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_PAGE_NUMBER, String.valueOf(pagging.getPageNumber()));

        new RestHelper.Builder()
                .setUrl(API_CONTEST_LIST)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                Pagging<SubContestList> pagging1 = new Pagging<>();
                                boolean hasMore = jsonObject.getJSONObject(RES_DATA_KEY).getBoolean(RES_HAS_MORE);
                                pagging1.setHasMore(hasMore);
                                pagging1.setPageNumber(pagging.getPageNumber() + 1);
                                JSONArray contestListJson = jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("contest_list");
                                pagging1.addItemToList((ArrayList<SubContestList>) gson.fromJson(contestListJson.toString(), new TypeToken<ArrayList<SubContestList>>() {
                                }.getType()));
                                homcallback.onSuccess(pagging1);
                            } catch (Exception e) {
                                e.printStackTrace();
                                homcallback.onFailed(code, message);
                            }
                        } else {
                            homcallback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();


//        Pagging<SubContestList> pagging1 = new Pagging<SubContestList>();
//
//        subContestLists.clear();
//        subContestLists.add(new SubContestList("open", "2020 Miss Korea Contest", R.drawable.contest5));
//        subContestLists.add(new SubContestList("preparing", "Spring Girl Crush Contest", R.drawable.contest5));
//        subContestLists.add(new SubContestList("close", "Spring Girl Crush Contest",R.drawable.contest5));
//
//        if (subContestLists != null && subContestLists.size() > 0) {
//
//            //
//            pagging1.addItemToList((ArrayList<SubContestList>) subContestLists);
//            pagging1.setPagenumber(pagging.getPagenumber() + 1);
//        }
//        homcallback.onSuccess(pagging1);
    }

    @Override
    public void getContestContestantList(String language, String contest_id, DataManager.Callback<ContestDetailAndContestantListModel> callback) {
        Log.d(TAG, "ContestDetailandCOntestantLIst: ");


        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTID, contest_id);
        new RestHelper.Builder()
                .setUrl(API_CONTESTANT_LIST)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                ContestDetailAndContestantListModel model = gson.fromJson(jsonObj.toString(), ContestDetailAndContestantListModel.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();

    }


    @Override
    public void getContestCategory(Pagging<CategoryList> pagging, DataManager.Callback<Pagging> callback) {
        Pagging<CategoryList> pagging1 = new Pagging<CategoryList>();

        catlist.clear();
        catlist.add(new CategoryList("Women"));
        catlist.add(new CategoryList("Man"));
        catlist.add(new CategoryList("Junior"));
        catlist.add(new CategoryList("Senior"));
        catlist.add(new CategoryList("Team"));

        if (catlist != null && catlist.size() > 0) {

            //
            pagging1.addItemToList((ArrayList<CategoryList>) catlist);
            pagging1.setPageNumber(pagging.getPageNumber() + 1);
        }
        callback.onSuccess(pagging1);
    }

    @Override
    public void doSignup(String language, String email, String password,
                         String name, String mobile, String nickname,
                         int is_termstrue, int is_privacypolicy,
                         int is_newsSubsribe, DataManager.Callback<EmailOtpVerify> callback) {
        Log.d(TAG, "getSignupData: ");
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_EMAIL, email);
        params.put(KEY_PASSWORD, password);
        params.put(KEY_MOBILE, mobile);
        params.put(KEY_NAME, name);
        params.put(KEY_NICK_NAME, nickname);
        params.put(KEY_terms_condition, String.valueOf(is_termstrue));
        params.put(KEY_PRIVACY, String.valueOf(is_privacypolicy));
        params.put(KEY_NEWS, String.valueOf(is_newsSubsribe));
        params.put("otp_for", "register");
//        params.put(KEY_DEVICE_ID,getDeviceID());


        new RestHelper.Builder()
                .setUrl(API_SIGNUP)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {

                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                EmailOtpVerify model = gson.fromJson(jsonObj.toString(), EmailOtpVerify.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                Log.d(TAG, "onRequestCallback: " + e);
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void getLoginProfile(String language, String email,
                                String password, String auto_login,
                                String login_type, DataManager.Callback<LoginDataModel> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERNAME, email);
        params.put(KEY_PASSWORD, password);
        params.put(KEY_AUTOLOGIN, auto_login);
        params.put(KEY_LOGINTYPE, login_type);

        params.put(KEY_GRANT_TYPE, "password");
        params.put(KEY_CLIENT_ID, "ranking-star");
        params.put(KEY_CLIENT_SECRET, "b4bca6aa25828cf702d06cbc9656d4e3");
//        params.put(KEY_DEVICE_ID,getDeviceID());

        new RestHelper.Builder()
                .setUrl(API_LOGIN)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        Log.d(TAG, "onRequestCallback: " + code);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                LoginDataModel model = gson.fromJson(jsonObj.toString(), LoginDataModel.class);
                                if (model.getTokenDetails() != null) {
                                    saveAccessToken(model.getTokenDetails().getAccess_token());
                                    saveRefreshToken(model.getTokenDetails().getRefresh_token());
                                }
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

   /* private String getDeviceID() {
        return Settings.Secure.getString(StarRankingApp.appContext.getContentResolver(),
                Settings.Secure.ANDROID_ID);
    }*/

    @Override
    public void getUserProfileAlwasys(String language, String user_id, String user_type, DataManager.Callback<LoginDataModel> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);
        params.put(KEY_USER_TYPE, user_type);

        new RestHelper.Builder()
                .setUrl(API_PROFILE)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        Log.d(TAG, "Constants.UNAUTHORIZED_USER: " + code + ", " + message);
                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getUserProfileAlwasys(language, user_id, user_type, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    Log.d(TAG, "onFailed: code1");
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    LoginDataModel model = gson.fromJson(jsonObj.toString(), LoginDataModel.class);
                                    callback.onSuccess(model);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void getSettings(String language, String user_id, DataManager.Callback<SettingsModel> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);


        new RestHelper.Builder()
                .setUrl(API_GETSETTINGS)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);

                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getSettings(language, user_id, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    SettingsModel model = gson.fromJson(jsonObj.toString(), SettingsModel.class);
                                    callback.onSuccess(model);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }

                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void doubleCheckemail(String language, String email, DataManager.Callback<String> callback) {
        Log.d(TAG, "doublecheck: ");
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_EMAIL, email);


        new RestHelper.Builder()
                .setUrl(API_DOUBLECHECK)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 0) {
                            callback.onFailed(code, message);
                        } else {
                            callback.onSuccess(message);
                        }


                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void attendanceCheckIn(String language, String user_id, DataManager.Callback<String> callback) {
        Log.d(TAG, "attendance: ");
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);


        new RestHelper.Builder()
                .setUrl(API_ATTENDANCE)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        Log.e("check", restResponse.getResString());
                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    attendanceCheckIn(language, user_id, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY).getJSONObject("star_details");

                                    if (code == 0) {
                                        callback.onFailed(code, message);
                                    } else {
                                        callback.onSuccess(jsonObj.getString("available_star"));
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }

                        }


                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void setSettings(String language, String user_id, String pushalert,
                            String pushsound, String pushvibrate, DataManager.Callback<String> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);
        params.put(KEY_PUSH_ALERT, pushalert);
        params.put(KEY_PUSH_SOUND, pushsound);
        params.put(KEY_PUSH_VIBRATE, pushvibrate);


        new RestHelper.Builder()
                .setUrl(API_SETSETTINGS)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {

                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);

                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    setSettings(language, user_id, pushalert, pushsound, pushvibrate, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                callback.onSuccess(message);
                            } else {
                                callback.onFailed(code, message);
                            }
                        }


                    }
                })
                .build()
                .sendRequest();
    }


    @Override
    public void getAddVoteApi(String language, String contest_id, String contestant_id,
                              String voter_id, String vote, String voter_name,
                              DataManager.Callback<StarDetailsVm> callback) {
        Log.d(TAG, "AddVote: ");
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTID, contest_id);
        params.put(KEY_CONTESTANTID, contestant_id);
        params.put(KEY_VOTERID, voter_id);
        params.put(KEY_VOTE, vote);
        params.put(KEY_VOTERNAME, voter_name);


        new RestHelper.Builder()
                .setUrl(API_ADDVOTES)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getAddVoteApi(language, contest_id, contestant_id, voter_id, vote, voter_name, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    StarDetailsVm model = gson.fromJson(jsonObj.toString(), StarDetailsVm.class);
                                    callback.onSuccess(model);

                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();

    }

    @Override
    public void getGiftStarApi(String receiver_id, String sender_id, String sender_name,
                               String star, String language, DataManager.Callback<GiftDetailsVm> callback) {
        Log.d(TAG, "gift: ");
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_RECEIVERID, receiver_id);
        params.put(KEY_SENDERID, sender_id);
        params.put(KEY_STAR, star);
        params.put(KEY_SENDERNAME, sender_name);

        new RestHelper.Builder()
                .setUrl(API_GIFT_STAR)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getGiftStarApi(receiver_id, sender_id, sender_name, star, language, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    GiftDetailsVm model = gson.fromJson(jsonObj.toString(), GiftDetailsVm.class);
                                    callback.onSuccess(model);

                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }


   /* @Override
    public void getContestantsImages(Pagging<ContestantMedia> pagging, DataManager.Callback<Pagging> callback) {
        Pagging<ContestantMedia> pagging1 = new Pagging<ContestantMedia>();


        imageslistArrayList.clear();
        imageslistArrayList.add(new ContestantMedia(R.drawable.images));
        imageslistArrayList.add(new ContestantMedia(R.drawable.imgg));
        imageslistArrayList.add(new ContestantMedia(R.drawable.images));
        imageslistArrayList.add(new ContestantMedia(R.drawable.imgg));
        imageslistArrayList.add(new ContestantMedia(R.drawable.images));
        imageslistArrayList.add(new ContestantMedia(R.drawable.imgg));

        if (imageslistArrayList != null && imageslistArrayList.size() > 0) {

            //
            pagging1.addItemToList((ArrayList<ContestantMedia>) imageslistArrayList);
            pagging1.setPagenumber(pagging.getPagenumber() + 1);
        }
        callback.onSuccess(pagging1);
    }*/


    @Override
    public void getEarningStars(String language, String user_id, DataManager.Callback<StarHistory> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);
        new RestHelper.Builder()
                .setUrl(API_STAR_HISTORY)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        Log.d(TAG, "jsonObject: " + code);

                        if (code == Constants.UNAUTHORIZED_USER) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    Log.d(TAG, "onSuccess: " + baseRes);
                                    getEarningStars(language, user_id, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });

                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    StarHistory model = gson.fromJson(jsonObj.toString(), StarHistory.class);
                                    callback.onSuccess(model);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();


    }

    @Override
    public void getUsedStars(String language, String user_id, DataManager.Callback<StarHistory> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);
        new RestHelper.Builder()
                .setUrl(API_STAR_HISTORY)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getUsedStars(language, user_id, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });

                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    StarHistory model = gson.fromJson(jsonObj.toString(), StarHistory.class);
                                    callback.onSuccess(model);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();

    }

    @Override
    public void getContestantVoteList(String language, String contest_id, String contestant_id, DataManager.Callback<VoteListModel> callback) {

        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTID, contest_id);
        params.put(KEY_CONTESTANTID, contestant_id);
        new RestHelper.Builder()
                .setUrl(API_VOTE_HISTORY)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {

                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                VoteListModel list = gson.fromJson(jsonObject.getJSONObject(RES_DATA_KEY).toString(), VoteListModel.class);
                                list.setBanner(jsonObject.getJSONObject(RES_DATA_KEY).getJSONObject("banner_list").getString("sub_banner"));
                                callback.onSuccess(list);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();

    }

//
//    @Override
//    public void getContestantList(String language, String contets_id, DataManager.Callback<ArrayList<ContestantList>> callback) {
//
//        Log.d(TAG, "ContestDetailandCOntestantLIst: ");
//        HashMap<String, String> params = new HashMap<>();
//        params.put("language", "english");
//        params.put("contest_id", "2");
////language:english
////contest_id:2
//        new RestHelper.Builder()
//                .setUrl(API_CONTESTANT_LIST)
//                .setParams(params)
//                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
//                .setCallBack(new RestHelper.RestHelperCallback() {
//                    @Override
//                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
//                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
//                        if (jsonObject != null) {
//                            try {
//
////                                JSONArray contest_details = jsonObject.getJSONObject(Constants.RES_DATA_KEY).getJSONArray("contest_details");
////
////                                ArrayList<ContestDetails> listC = gson.fromJson(contest_details.toString(),
////                                        new TypeToken<ArrayList<ContestDetails>>() {
////                                        }.getType());
//
//                                JSONArray contestantListJson = jsonObject.getJSONObject(Constants.RES_DATA_KEY).getJSONArray("contestant_details");
//
//                                ArrayList<ContestantList> list = gson.fromJson(contestantListJson.toString(),
//                                        new TypeToken<ArrayList<ContestantList>>() {
//                                        }.getType());
//
//                                callback.onSuccess(list);
//
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                                callback.onFailed(code, message);
//                            }
//                        } else {
//                            callback.onFailed(code, message);
//                        }
//                    }
//                })
//                .build()
//                .sendRequest();
//
//    }
//  @Override
//    public void getContestDetails(String language, String contets_id, DataManager.Callback<ArrayList<ContestDetails>> callback) {
//
//        Log.d(TAG, "ContestDetail: ");
//        HashMap<String, String> params = new HashMap<>();
//        params.put("language", "english");
//        params.put("contest_id", "2");
////language:english
////contest_id:2
//        new RestHelper.Builder()
//                .setUrl(API_CONTESTANT_LIST)
//                .setParams(params)
//                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
//                .setCallBack(new RestHelper.RestHelperCallback() {
//                    @Override
//                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
//                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
//                        if (jsonObject != null) {
//                            try {
//
//                                JSONArray contest_details = jsonObject.getJSONObject(Constants.RES_DATA_KEY).getJSONArray("contest_details");
//
//                                ArrayList<ContestDetails> list = gson.fromJson(contest_details.toString(),
//                                        new TypeToken<ArrayList<ContestDetails>>() {
//                                        }.getType());
//
//                                callback.onSuccess(list);
//
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                                callback.onFailed(code, message);
//                            }
//                        } else {
//                            callback.onFailed(code, message);
//                        }
//                    }
//                })
//                .build()
//                .sendRequest();
//
//    }

    @Override
    public void getContestantDetails(String language, String contestant_id, String contest_id, DataManager.Callback<ContestantModel> callback) {
        Log.d(TAG, "ContestDetailandCOntestantLIst: ");
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTANTID, contestant_id);
        params.put(KEY_CONTESTID, contest_id);

        new RestHelper.Builder()
                .setUrl(API_CONTESTANT_DETAIL)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {

                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                ContestantModel model = gson.fromJson(jsonObj.toString(), ContestantModel.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void getOtherContestantDetails(Pagging<OtherContestantDetails> pagging, DataManager.Callback<Pagging> callback) {
        Pagging<OtherContestantDetails> pagging1 = new Pagging<OtherContestantDetails>();

        contestantDetails.clear();
//        contestantDetails.add(new OtherContestantDetails("Education", "Education"));
//        contestantDetails.add(new OtherContestantDetails("Major", "Major"));
//        contestantDetails.add(new OtherContestantDetails("Hope", "Hope"));
//        contestantDetails.add(new OtherContestantDetails("Hobbiess", "Hobbiess"));
//        contestantDetails.add(new OtherContestantDetails("Specialities", "Specialities"));
//

        if (contestantDetails != null && contestantDetails.size() > 0) {

            //
            pagging1.addItemToList((ArrayList<OtherContestantDetails>) contestantDetails);
            pagging1.setPageNumber(pagging.getPageNumber() + 1);
        }
        callback.onSuccess(pagging1);
    }

    @Override
    public void getCommentLists(Pagging<CommentsModel> pagging, DataManager.Callback<Pagging> callback) {
        Pagging<CommentsModel> pagging1 = new Pagging<CommentsModel>();

        commentDetails.clear();
        commentDetails.add(new CommentsModel(R.drawable.profile, "Name x", "comment from name", "2 hrs ago"));
        commentDetails.add(new CommentsModel(R.drawable.profile, "Name y", "nice", "2 days ago"));
        commentDetails.add(new CommentsModel(R.drawable.profile, "Name x", "awesome", "2 hrs ago"));
        commentDetails.add(new CommentsModel(R.drawable.profile, "Name x", "commented", "1 hrs ago"));
        commentDetails.add(new CommentsModel(R.drawable.profile, "Name y", "nice", "recently"));
        commentDetails.add(new CommentsModel(R.drawable.profile, "Name z", "awesome", "2 week ago"));


        if (commentDetails != null && commentDetails.size() > 0) {

            //
            pagging1.addItemToList((ArrayList<CommentsModel>) commentDetails);
            pagging1.setPageNumber(pagging.getPageNumber() + 1);
        }
        callback.onSuccess(pagging1);
    }


    @Override
    public void getSearchResult(String language, String searchTerm, Pagging<SearchList> pagging, DataManager.Callback<Pagging<SearchList>> onApiCallback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_PAGE_NUMBER, String.valueOf(pagging.getPageNumber()));
        params.put(KEY_SEARCH_TERM, searchTerm);
        new RestHelper.Builder()
                .setUrl(API_CONTESTANT_SEARCH)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                Pagging<SearchList> pagging1 = new Pagging<>();
                                boolean hasMore = jsonObject.getJSONObject(RES_DATA_KEY).getBoolean(RES_HAS_MORE);
                                pagging1.setHasMore(hasMore);
                                pagging1.setPageNumber(pagging.getPageNumber() + 1);
                                JSONArray searchResult = jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("contestant_list");
                                ArrayList<SearchList> searchListArrayList = gson.fromJson(searchResult.toString(), new TypeToken<ArrayList<SearchList>>() {
                                }.getType());
                                pagging1.addItemToList(searchListArrayList);
                                onApiCallback.onSuccess(pagging1);
                            } catch (Exception e) {
                                e.printStackTrace();
                                onApiCallback.onFailed(code, message);
                            }
                        } else {
                            onApiCallback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void doRegisterDevice(String language, String user_id, String token, DataManager.Callback<String> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CLIENT_ID, "rankingstar");
        params.put(KEY_USERID, user_id);
        params.put(KEY_DEVICE_UID, "");//uuid
        params.put(KEY_DEVICE_TOKEN, token);//fcm
        params.put(KEY_DEVICE_NAME, Build.BRAND);
        params.put(KEY_DEVICE_MODEL, Build.MODEL);
        params.put(KEY_DEVICE_VER, Build.VERSION.RELEASE);//os version
        params.put(KEY_APP_NAME, "Ranking Star");
        params.put(KEY_APP_VER, String.valueOf(BuildConfig.VERSION_NAME));
        params.put(KEY_PUSH_ALERT, "enabled");
        params.put(KEY_PUSH_SOUND, "enabled");
        params.put(KEY_PUSH_BADGE, "enabled");
        params.put(KEY_PUSH_VIBRATE, "enabled");
        params.put(KEY_ENV, "production");
        params.put(KEY_OS, Constants.OS_ANDROID);


        new RestHelper.Builder()
                .setUrl(API_REGISTER_DEVICE)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    doRegisterDevice(language, user_id, token, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            String successMsg = message;
                            callback.onSuccess(successMsg);

                        }

                        //                        if (jsonObject != null) {
//                            try {
//                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
//                                StarDetailsVm model = gson.fromJson(jsonObj.toString(), StarDetailsVm.class);
//                                callback.onSuccess(model);
//
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                                callback.onFailed(code, message);
//                            }
//                        } else {
//                            callback.onFailed(code, message);
//                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void getDetailsbyPhoneNumber(String mobile, String language, DataManager.Callback<UserFromMobile> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_MOBILE, mobile);
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);


        new RestHelper.Builder()
                .setUrl(API_GETDETAILS_GIFT)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getDetailsbyPhoneNumber(mobile, language, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                    UserFromMobile model = gson.fromJson(jsonObj.toString(), UserFromMobile.class);
                                    callback.onSuccess(model);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();

    }

    @Override
    public void getPlanList(Pagging<PaidChargeList> pagging, String language, DataManager.Callback<Pagging<PaidChargeList>> homcallback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_OS, Constants.OS_ANDROID);

        new RestHelper.Builder()
                .setUrl(API_PLAN_LIST)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                Pagging<PaidChargeList> pagging1 = new Pagging<>();
                                boolean hasMore = false /*jsonObject.getJSONObject(Constants.RES_DATA_KEY).getBoolean(RES_HAS_MORE)*/;
                                pagging1.setHasMore(hasMore);
                                pagging1.setPageNumber(pagging.getPageNumber() + 1);
                                JSONArray contestListJson = jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("plan_list");
                                pagging1.addItemToList(gson.fromJson(contestListJson.toString(), new TypeToken<ArrayList<PaidChargeList>>() {
                                }.getType()));
                                homcallback.onSuccess(pagging1);
                            } catch (Exception e) {
                                e.printStackTrace();
                                homcallback.onFailed(code, message);
                            }
                        } else {
                            homcallback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    private HashMap<String, String> getBasicAuthHeader() {
        HashMap<String, String> header = new HashMap<>();
        header.put("Authorization", Credentials.basic("ranking-star", "b4bca6aa25828cf702d06cbc9656d4e3"));
        header.put("Accept", "application/json");
        Log.d(TAG, "getBasicAuthHeader: " + header);
        return header;
    }

    private HashMap<String, String> getOAuthHeader() {
        HashMap<String, String> header = new HashMap<>();
        header.put("Authorization", getAccessToken());
        header.put("Accept", "application/json");
        Log.d(TAG, "getOAuthHeader: " + header);
        return header;
    }


    @Override
    public void getNoticeLists(Pagging<NoticeList> pagging, String language, DataManager.Callback<Pagging<NoticeList>> callback) {


        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);


        new RestHelper.Builder()
                .setUrl(API_NOTICE_LIST)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                Pagging<NoticeList> pagging1 = new Pagging<>();
                                boolean hasMore = false /*jsonObject.getJSONObject(Constants.RES_DATA_KEY).getBoolean(RES_HAS_MORE)*/;
                                pagging1.setHasMore(hasMore);
                                pagging1.setPageNumber(pagging.getPageNumber() + 1);
                                JSONArray contestListJson = jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("notice_list");
                                pagging1.addItemToList((ArrayList<NoticeList>) gson.fromJson(contestListJson.toString(), new TypeToken<ArrayList<NoticeList>>() {
                                }.getType()));
                                callback.onSuccess(pagging1);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();

    }

    @Override
    public void getNotificationLists(Pagging<NotificationsList> pagging, String language, String user_id, DataManager.Callback<Pagging<NotificationsList>> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);


        new RestHelper.Builder()
                .setUrl(API_NOTIFICATION_LIST)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getNotificationLists(pagging, language, user_id, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    Pagging<NotificationsList> pagging1 = new Pagging<>();
                                    boolean hasMore = false /*jsonObject.getJSONObject(Constants.RES_DATA_KEY).getBoolean(RES_HAS_MORE)*/;
                                    pagging1.setHasMore(hasMore);
                                    pagging1.setPageNumber(pagging.getPageNumber() + 1);
                                    JSONArray contestListJson = jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("notification_list");
                                    pagging1.addItemToList((ArrayList<NotificationsList>) gson.fromJson(contestListJson.toString(), new TypeToken<ArrayList<NotificationsList>>() {
                                    }.getType()));
                                    callback.onSuccess(pagging1);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }


    @Override
    public void editContestantDetails(String language, String contestantId, Uri imageUri, File file, String introduction, ArrayList<ContestantMedia> youtubeMedia, DataManager.Callback<String> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTANTID, contestantId);
        params.put(KEY_INTRODUCTION, introduction);
        String youtube_id_1 = "";
        String youtube_id_2 = "";
        String youtube_id_3 = "";
        String youtube_url_1 = "";
        String youtube_url_2 = "";
        String youtube_url_3 = "";
        if (youtubeMedia != null && youtubeMedia.size() > 0) {
            ContestantMedia media = youtubeMedia.get(0);
            if (media != null) {
                if (media.getMediaId() != null)
                    youtube_id_1 = media.getMediaId();
                if (media.getMediaPath() != null)
                    youtube_url_1 = media.getMediaPath();
            }
            if (youtubeMedia.size() > 1) {
                media = youtubeMedia.get(1);
                if (media != null) {
                    if (media.getMediaId() != null)
                        youtube_id_2 = media.getMediaId();
                    if (media.getMediaPath() != null)
                        youtube_url_2 = media.getMediaPath();
                }
                if (youtubeMedia.size() > 2) {
                    media = youtubeMedia.get(2);
                    if (media != null) {
                        if (media.getMediaId() != null)
                            youtube_id_3 = media.getMediaId();
                        if (media.getMediaPath() != null)
                            youtube_url_3 = media.getMediaPath();
                    }
                }
            }
        }

        params.put("youtube_id_1", youtube_id_1);
        params.put("youtube_id_2", youtube_id_2);
        params.put("youtube_id_3", youtube_id_3);

        params.put("youtube_url_1", youtube_url_1);
        params.put("youtube_url_2", youtube_url_2);
        params.put("youtube_url_3", youtube_url_3);

        ArrayList<String> list = new ArrayList<>();
        try {
            if (file == null) {
                list.add(FileUtil.from(StarRankingApp.appContext, imageUri).getPath());
            } else {
                list.add(file.getPath());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        HashMap<String, List<String>> attachments = new HashMap<>();
        attachments.put(KEY_MAIN_IMAGE, list);


        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_MULTIPART)
                .setUrl(API_EDIT_CONTESTANT_DETAIL)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setAttachments(attachments)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    editContestantDetails(language, contestantId, imageUri, file, introduction, youtubeMedia, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    callback.onSuccess(message);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void deleteContestantMedia(String language, String mediaId, DataManager.Callback<String> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_MEDIA_ID, mediaId);
        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_DELETE_GALLERY_ITEM)
                .setHeaders(getOAuthHeader())
                .setParams(params)

                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    deleteContestantMedia(language, mediaId, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    callback.onSuccess(message);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }


    @Override
    public void getUpdateUserProfile(String language, String user_id, String userType,
                                     String email, String mobile,
                                     String name, String nick_name,
                                     String current_password, String password, DataManager.Callback<String> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_USERID, user_id);
        params.put(KEY_USER_TYPE, userType);
        if (email != null)
            params.put(KEY_EMAIL, email);
        params.put(KEY_MOBILE, mobile);
        params.put(KEY_NAME, name);
        params.put(KEY_NICK_NAME, nick_name);
        if (current_password != null)
            params.put(KEY_CURRENT_PWD, current_password);
        if (password != null)
            params.put(KEY_PASSWORD, password);

        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_EDIT_USER_PROFILE)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    getUpdateUserProfile(language, user_id, userType, email, mobile, name, nick_name, current_password, password, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    callback.onSuccess(message);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void getVerifySocialMedia(String language, String social_id, String login_type, DataManager.Callback<LoginDataModel> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_SOCIALID, social_id);
        params.put(KEY_LOGINTYPE, login_type);

        params.put(KEY_GRANT_TYPE, "password");
        params.put(KEY_CLIENT_ID, "ranking-star");
        params.put(KEY_CLIENT_SECRET, "b4bca6aa25828cf702d06cbc9656d4e3");
        params.put(KEY_USERNAME, social_id);
        params.put(KEY_PASSWORD, social_id);

        Log.d(TAG, "getVerifySocialMedia: params " + params);
//        params.put(KEY_DEVICE_ID,getDeviceID());
        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_VERIFYSOCIALMEDIA)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            if (code == 2) {
                                //not verified

                                callback.onFailed(code, message);
                            }
                            if (code == 1) {
                                Log.d(TAG, "onRequestCallback: ");
                                //call socail login
                                try {
                                    JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);

                                    LoginDataModel model = gson.fromJson(jsonObj.toString(), LoginDataModel.class);
                                    // Log.d(TAG, "onRequestCallback: " + model.getTokenDetails().getAccess_token());
                                    if (model.getTokenDetails() != null) {
                                        saveAccessToken(model.getTokenDetails().getAccess_token());
                                        saveRefreshToken(model.getTokenDetails().getRefresh_token());
                                    }
                                    callback.onSuccess(model);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            }


                        } else {
                            Log.d(TAG, "onRequestCallback: " + message);
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void socialLogin(String language,
                            String social_id,
                            String name,
                            String nick_name,
                            String email,
                            String login_type,
                            String mobile,
                            DataManager.Callback<LoginDataModel> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, language);
        params.put(KEY_SOCIALID, social_id);
        if (name == null)
            name = "";
        params.put(KEY_NAME, name);
        if (nick_name == null)
            nick_name = "";
        params.put(KEY_NICK_NAME, nick_name);
        if (email == null)
            email = "";
        params.put(KEY_EMAIL, email);
        if (login_type == null)
            login_type = "";
        params.put(KEY_LOGINTYPE, login_type);
        if (mobile == null)
            mobile = "";
        params.put(KEY_MOBILE, mobile);
//        params.put(KEY_DEVICE_ID,getDeviceID());


        new RestHelper.Builder()
                .setUrl(API_SOCIALLOGIN)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                LoginDataModel model = gson.fromJson(jsonObj.toString(), LoginDataModel.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }


    @Override
    public void getContestantsImagesForEdit(String language, String contestantId, DataManager.Callback<ArrayList<ContestantMedia>> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTANTID, contestantId);
        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_CONTESTANT_MEDIA)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                ArrayList<ContestantMedia> list = gson.fromJson(jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("media_details").toString(), new TypeToken<ArrayList<ContestantMedia>>() {
                                }.getType());
                                callback.onSuccess(list);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }


    @Override
    public void uploadMedia(String language, String contestantId, Uri uriToFile, File file, String mediaType, DataManager.Callback<ContestantMedia> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, AppUtils.LANGUAGE_DEFAULT_VALUE);
        params.put(KEY_CONTESTANTID, contestantId);
        params.put(KEY_MEDIA_TYPE, mediaType);
        ArrayList<String> list = new ArrayList<>();
        try {
            if (file == null) {
                list.add(FileUtil.from(StarRankingApp.appContext, uriToFile).getPath());
                Log.d(TAG, "uploadMedia: file created");
            } else {
                list.add(file.getPath());
                Log.d(TAG, "uploadMedia: file reused");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        HashMap<String, List<String>> attachments = new HashMap<>();
        attachments.put(KEY_MEDIA_PATH, list);


        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_MULTIPART)
                .setUrl(API_UPLOAD_MEDIA)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setAttachments(attachments)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    uploadMedia(language, contestantId, uriToFile, file, mediaType, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    ContestantMedia media = gson.fromJson(jsonObject.getJSONObject(RES_DATA_KEY).getJSONArray("media_details").get(0).toString(), ContestantMedia.class);
                                    callback.onSuccess(media);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build().sendRequest();
    }

    public String contetIdForTransaction;

    @Override
    public void beginTransaction(String language, String userId, String planId, String amount, String contestId, DataManager.Callback<TransactionDetails> callback) {
        contetIdForTransaction = contestId;

        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, language);
        params.put(KEY_USERID, userId);
        params.put(KEY_PLAN_ID, planId);
        params.put(KEY_AMOUNT, amount);
        if (contestId == null)
            contestId = "";
        params.put(KEY_CONTESTID, contestId);
        params.put(KEY_OS, Constants.OS_ANDROID);
        params.put(KEY_APP_VERSION, "" + BuildConfig.VERSION_CODE);
        String finalContestId = contestId;
        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_BEGIN_TRANSACTION)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    beginTransaction(language, userId, planId, amount, contetIdForTransaction, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    TransactionDetails media = gson.fromJson(jsonObject.getJSONObject(RES_DATA_KEY).getJSONObject("transaction_details").toString(), TransactionDetails.class);
                                    callback.onSuccess(media);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }


    @Override
    public void endTransaction(String language, String transactionId, String paymentStatus, String description, String paymentTransationId,
                               String paymentDetails, DataManager.Callback<RestResponseModel<EndTransactionModel>> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, language);
        params.put(KEY_TRANSACTION_ID, transactionId);
        params.put(KEY_PAYMENT_STATUS, paymentStatus);
        params.put(KEY_DESC, description);
        if (paymentTransationId != null)
            params.put(KEY_PAYMENT_TRANSATIONC_ID, paymentTransationId);
        if (paymentDetails != null)
            params.put(KEY_PAYMENT_DETAILS, paymentDetails);
        params.put(KEY_OS, Constants.OS_ANDROID);
        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_COMPLETE_TRANSACTION)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    endTransaction(language, transactionId, paymentStatus, description, paymentTransationId,
                                            paymentDetails, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    RestResponseModel<EndTransactionModel> responseModel = gson.fromJson(jsonObject.toString(), new TypeToken<RestResponseModel<EndTransactionModel>>() {
                                    }.getType());
                                    callback.onSuccess(responseModel);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void updateTransaction(String language, String transactionId, String paymentStatus, String description, String paymentTransationId,
                                  String paymentDetails, DataManager.Callback<Object> callback) {

        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_LANGUAGE, language);
        params.put(KEY_TRANSACTION_ID, transactionId);
        params.put(KEY_PAYMENT_STATUS, paymentStatus);
        params.put(KEY_DESC, description);
        if (paymentTransationId != null)
            params.put(KEY_PAYMENT_TRANSATIONC_ID, paymentTransationId);
        if (paymentDetails != null)
            params.put(KEY_PAYMENT_DETAILS, paymentDetails);
        params.put(KEY_OS, Constants.OS_ANDROID);

        new RestHelper.Builder()
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setUrl(API_UPDATE_TRANSACTION)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    updateTransaction(language, transactionId, paymentStatus, description, paymentTransationId, paymentDetails, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    callback.onSuccess(new Object());
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void doVerifyEmailOtp(String email, String otp, String otpFor, DataManager.Callback<LoginDataModel> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put("email", email);
        params.put("otp", otp);
        params.put("otp_for", otpFor);
        Log.d(TAG, "doVerifyEmailOtp: " + params);

        new RestHelper.Builder()
                .setUrl(API_VERIFY_OTP)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                LoginDataModel model = gson.fromJson(jsonObj.toString(), LoginDataModel.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void doResendOtp(String email, String otpFor, DataManager.Callback<EmailOtpVerify> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put("email", email);
        params.put("otp_for", otpFor);
        Log.d(TAG, "doResendOtp: " + params);
        new RestHelper.Builder()
                .setUrl(API_RESEND_OTP)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                EmailOtpVerify model = gson.fromJson(jsonObj.toString(), EmailOtpVerify.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();


    }

    @Override
    public void doVerifyEmailForForgotPassword(String email, DataManager.Callback<EmailOtpVerify> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put("email", email);
        params.put("otp_for", "forgotpassword");

        new RestHelper.Builder()
                .setUrl(API_SEND_OTP_FOR_FORGOT_PWD)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                JSONObject jsonObj = jsonObject.getJSONObject(RES_DATA_KEY);
                                EmailOtpVerify model = gson.fromJson(jsonObj.toString(), EmailOtpVerify.class);
                                callback.onSuccess(model);
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    @Override
    public void doCreateNewPassword(String userId, String password, DataManager.Callback<Object> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put("user_id", userId);
        params.put("password", password);

        new RestHelper.Builder()
                .setUrl(API_CREATE_NEW_PASSWORD)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (jsonObject != null) {
                            try {
                                callback.onSuccess(new Object());
                            } catch (Exception e) {
                                e.printStackTrace();
                                callback.onFailed(code, message);
                            }
                        } else {
                            callback.onFailed(code, message);
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    ArrayList<DataManager.Callback<Object>> callbacksArrayList = new ArrayList<>();

    @Override
    public void getTokenFromRefreshToken(DataManager.Callback<Object> callback) {
        callbacksArrayList.add(callback);
        Log.d(TAG, " callbacksArrayList " + isNewAccessTokenApiCallRunning);

        if (!isNewAccessTokenApiCallRunning) {
            HashMap<String, String> params = new HashMap<>();
            params.put(KEY_GRANT_TYPE, "refresh_token");
            params.put(KEY_CLIENT_ID, "ranking-star");
            params.put(KEY_CLIENT_SECRET, "b4bca6aa25828cf702d06cbc9656d4e3");
            params.put(KEY_REFRESH_TOKEN, getRefreshToken());
            isNewAccessTokenApiCallRunning = true;
            new RestHelper.Builder()
                    .setUrl(API_GET_TOKEN_FROM_REFRESH_TOKEN)
                    .setHeaders(getBasicAuthHeader())
                    .setParams(params)
                    .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                    .setCallBack(new RestHelper.RestHelperCallback() {
                        @Override
                        public void onRequestCallback(int code, String message, RestResponse restResponse) {
                            Log.d(TAG, "onRequestCallback: code" + code + "," + message);
                            if (code == Constants.SUCCESS_CODE) {
                                try {
                                    JSONObject res = new JSONObject(restResponse.getResString());
                                    Log.d(TAG, "onRequestCallback:__ "+res);
                                    if (res.getInt(RES_CODE_KEY) == 1) {
                                        try {
                                            JSONObject jsonObj = res.getJSONObject(RES_DATA_KEY).getJSONObject("token_details");
                                            TokenDetails model = gson.fromJson(jsonObj.toString(), TokenDetails.class);
                                            if (model != null) {
                                                Log.d(TAG, "AccessToken: " + model.getAccess_token());
                                                saveAccessToken(model.getAccess_token());
                                                saveRefreshToken(model.getRefresh_token());
                                                // callback.onSuccess(jsonObj);
                                                for (int i = 0; i < callbacksArrayList.size(); i++) {
                                                    callback.onSuccess(callbacksArrayList.get(i));
                                                    Log.d(TAG, "onRequestCallback: " + callbacksArrayList.get(i));

                                                    //callbacksArrayList.remove(callbacksArrayList.get(i));
                                                    if (i == callbacksArrayList.size() - 1) {
                                                        callbacksArrayList.clear();
                                                    }
                                                    Log.d(TAG, "onRequestCallback: " + callbacksArrayList.size());
                                                }
                                                isNewAccessTokenApiCallRunning = false;


                                            }
                                        } catch (Exception e) {
                                            Log.d(TAG, "onRequestCallback:ee " + e);
                                            e.printStackTrace();
                                            for (int i = 0; i < callbacksArrayList.size(); i++) {
                                                callback.onFailed(code, message);
                                                if (i == callbacksArrayList.size() - 1) {
                                                    callbacksArrayList.clear();
                                                }
                                            }
                                            isNewAccessTokenApiCallRunning = false;

                                        }
                                    }
                                } catch (Exception e) {
                                    Log.d(TAG, "onRequestCallback: "+e);
                                    e.printStackTrace();
                                    for (int i = 0; i < callbacksArrayList.size(); i++) {
                                        callback.onFailed(code, message);
                                        if (i == callbacksArrayList.size() - 1) {
                                            callbacksArrayList.clear();
                                        }
                                    }
                                    isNewAccessTokenApiCallRunning = false;
                                }
                            } else if (code == 3) {
                                //redirect to login page
                                StarRankingApp.getDataManager().logout();
                                Intent intent = new Intent(StarRankingApp.appContext, LoginActivity.class);
                                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                                StarRankingApp.appContext.startActivity(intent);
                                isNewAccessTokenApiCallRunning = false;

                            }
                            else{
                                for (int i = 0; i < callbacksArrayList.size(); i++) {
                                    callback.onFailed(code, message);
                                    if (i == callbacksArrayList.size() - 1) {
                                        callbacksArrayList.clear();
                                    }
                                }
                                isNewAccessTokenApiCallRunning = false;
                            }
                        }
                    })
                    .build()
                    .sendRequest();
        }
    }

    @Override
    public void deleteUserAccount(String userId, DataManager.Callback<Object> callback) {
        HashMap<String, String> params = new HashMap<>();
        params.put("user_id", userId);

        new RestHelper.Builder()
                .setUrl(API_DELETE_ACCOUNT)
                .setHeaders(getOAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST)
                .setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        JSONObject jsonObject = AppUtils.checkResponse(code, message, restResponse);
                        if (code == 3) {
                            getTokenFromRefreshToken(new DataManager.Callback<Object>() {
                                @Override
                                public void onSuccess(Object baseRes) {
                                    deleteUserAccount(userId, callback);
                                }

                                @Override
                                public void onFailed(int code, String msg) {
                                    callback.onFailed(code,msg);
                                }
                            });
                        } else {
                            if (jsonObject != null) {
                                try {
                                    callback.onSuccess(new Object());
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    callback.onFailed(code, message);
                                }
                            } else {
                                callback.onFailed(code, message);
                            }
                        }
                    }
                })
                .build()
                .sendRequest();
    }

    /*@Override
    public void getTokenFromRefreshToken() {
        HashMap<String, String> params = new HashMap<>();
        params.put(KEY_GRANT_TYPE, "refresh_token");
        params.put(KEY_CLIENT_ID, "ranking-star");
        params.put(KEY_CLIENT_SECRET, "b4bca6aa25828cf702d06cbc9656d4e3");
        params.put(KEY_REFRESH_TOKEN, getRefreshToken());
        Log.d(TAG, "getTokenFromRefreshToken: "+params);
        new RestHelper.Builder()
                .setUrl(API_GET_TOKEN_FROM_REFRESH_TOKEN)
                .setHeaders(getBasicAuthHeader())
                .setParams(params)
                .setRequestMethod(RestConst.RequestMethod.METHOD_POST).setContentType(RestConst.ContentType.CONTENT_FORMDATA)
                .setCallBack(new RestHelper.RestHelperCallback() {
                    @Override
                    public void onRequestCallback(int code, String message, RestResponse restResponse) {
                        if (code == Constants.SUCCESS_CODE) {
                            try {
                                JSONObject res = new JSONObject(restResponse.getResString());
                                Log.d(TAG, "onRequestCallback: "+res.getJSONObject(RES_DATA_KEY).getJSONObject("token_details").toString());
                                if (res.getInt(RES_CODE_KEY) == 1) {
                                    try {
                                        JSONObject jsonObj = res.getJSONObject(RES_DATA_KEY).getJSONObject("token_details");
                                        TokenDetails model = gson.fromJson(jsonObj.toString(), TokenDetails.class);
                                        if (model != null) {
                                            saveAccessToken(model.getAccess_token());
                                            saveRefreshToken(model.getRefresh_token());
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        } else if (code == 3) {
                            //redirect to login page
                            StarRankingApp.getDataManager().logout();

                            Intent intent = new Intent(StarRankingApp.appContext, LoginActivity.class);
                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                            StarRankingApp.appContext.startActivity(intent);
                        }
                    }
                })
                .build()
                .sendRequest();
    }*/

    private String getRefreshToken() {
        return StarRankingApp.getDataManager().get(PREF_REFRESH_TOKEN, "");
    }

    private void saveRefreshToken(String refreshToken) {
        if (refreshToken != null)
            StarRankingApp.getDataManager().set(PREF_REFRESH_TOKEN, refreshToken);
    }

    private String getAccessToken() {
        return StarRankingApp.getDataManager().get(PREF_ACCESS_TOKEN, "");
    }

    private void saveAccessToken(String accessToken) {
        if (accessToken != null)
            StarRankingApp.getDataManager().set(PREF_ACCESS_TOKEN, "Bearer " + accessToken);
    }


}
//     new Handler().postDelayed(new Runnable() {
//            @Override
//            public void run() {
//    }
//            }, 2500);


