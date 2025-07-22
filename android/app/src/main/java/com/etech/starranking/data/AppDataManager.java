package com.etech.starranking.data;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

import com.etech.starranking.data.database.room.DbHelper;
import com.etech.starranking.data.network.ApiHelper;
import com.etech.starranking.data.network.AppApiHelper;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.data.prefs.AppPreferencesHelper;
import com.etech.starranking.data.prefs.PreferencesHelper;
import com.etech.starranking.ui.activity.model.CategoryList;
import com.etech.starranking.ui.activity.model.CommentsModel;
import com.etech.starranking.ui.activity.model.ContestDetailAndContestantListModel;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.ContestantModel;
import com.etech.starranking.ui.activity.model.EmailOtpVerify;
import com.etech.starranking.ui.activity.model.EndTransactionModel;
import com.etech.starranking.ui.activity.model.GiftDetailsVm;
import com.etech.starranking.ui.activity.model.LoginDataModel;
import com.etech.starranking.ui.activity.model.LoginProfile;
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
import com.etech.starranking.ui.activity.model.TransactionDetails;
import com.etech.starranking.ui.activity.model.UserFromMobile;
import com.etech.starranking.ui.activity.model.VoteListModel;
import com.etech.starranking.utils.AppUtils;
import com.etech.starranking.utils.Constants;
import com.facebook.login.LoginManager;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.LogoutResponseCallback;
import com.kakao.usermgmt.callback.MeV2ResponseCallback;
import com.kakao.usermgmt.response.MeV2Response;
import com.nhn.android.naverlogin.OAuthLogin;

import java.io.File;
import java.util.ArrayList;

public class AppDataManager implements DataManager {

    private static final String TAG = "AppDataManager";
    private Context context;
    private ApiHelper apiHelper;
    private DbHelper dbHelper;
    private PreferencesHelper mPreferencesHelper;

    //
    public AppDataManager(Context context,
                          ApiHelper apiHelper,
                          DbHelper dbHelper,
                          PreferencesHelper mPreferencesHelper) {
        this.context = context;
        this.apiHelper = apiHelper;
        this.dbHelper = dbHelper;
        this.mPreferencesHelper = mPreferencesHelper;
    }

    @Override
    public String get(String key, String defaultValue) {
        return mPreferencesHelper.get(key, defaultValue);
    }

    @Override
    public void set(String key, String value) {
        mPreferencesHelper.set(key, value);
    }

    public void setBoolean(String key, boolean value) {
        mPreferencesHelper.setBoolean(key, value);
    }

    public boolean getBoolean(String key, boolean defaultValue) {
        return mPreferencesHelper.getBoolean(key, defaultValue);
    }

    public void setint(String key, int value) {
        mPreferencesHelper.setint(key, value);
    }

    public int getint(String key, int defaultValue) {
        return mPreferencesHelper.getint(key, defaultValue);
    }

    public void setLong(String key, long value) {
        mPreferencesHelper.setLong(key, value);
    }

    public long getLong(String key, long defaultValue) {
        return mPreferencesHelper.getLong(key, defaultValue);
    }

//    public void clear() {
//        mPreferencesHelper.clear();
//    }

    public void remove(String key) {
        mPreferencesHelper.remove(key);
    }
//
//    @Override
//    public void saveUserToPref(LoginProfile user) {
//        mPreferencesHelper.saveUserToPref(user);
//    }
//
//    @Override
//    public LoginProfile getUserFromPref() {
//        return mPreferencesHelper.getUserFromPref();
//    }
    //    ==================================================
//    pref method end

    //=========================================================================================
//    Api helper method start


    @Override
    public void getHomeSliderList(Pagging<ContestSliderContents> pagging, String language, Callback<Pagging<ContestSliderContents>> homcallback) {
        apiHelper.getHomeSliderList(pagging, language, homcallback);
    }


    @Override
    public void getHomeSubContestList(Pagging<SubContestList> pagging, String language, Callback<Pagging<SubContestList>> homcallback) {
        apiHelper.getHomeSubContestList(pagging, language, homcallback);
    }

    @Override
    public void getContestContestantList(String language, String contest_id, Callback<ContestDetailAndContestantListModel> callback) {
        apiHelper.getContestContestantList(language, contest_id, callback);
    }


    @Override
    public void getContestCategory(Pagging<CategoryList> pagging, Callback<Pagging> callback) {
        apiHelper.getContestCategory(pagging, callback);
    }
//
//    @Override
//    public void getContestantList(String langugae, String contest_id, Callback<ArrayList<ContestantList>> callback) {
//        apiHelper.getContestantList(langugae, contest_id, callback);
//    }
//
//    @Override
//    public void getContestDetails(String langugae, String contest_id, Callback<ArrayList<ContestDetails>> callback) {
//        apiHelper.getContestDetails(langugae, contest_id, callback);
//    }

    @Override
    public void getContestantDetails(String language, String contestant_id, String contest_id, Callback<ContestantModel> callback) {
        apiHelper.getContestantDetails(language, contestant_id, contest_id, callback);
    }


    @Override
    public void getOtherContestantDetails(Pagging<OtherContestantDetails> pagging, Callback<Pagging> callback) {
        apiHelper.getOtherContestantDetails(pagging, callback);
    }


    @Override
    public void getContestantsImagesForEdit(String language, String contestantId, Callback<ArrayList<ContestantMedia>> callback) {
        apiHelper.getContestantsImagesForEdit(language, contestantId, callback);
    }

    @Override
    public void getEarningStars(String language, String user_id, Callback<StarHistory> callback) {
        apiHelper.getEarningStars(language, user_id, callback);
    }

    @Override
    public void getUsedStars(String language, String user_id, Callback<StarHistory> callback) {
        apiHelper.getUsedStars(language, user_id, callback);
    }

    @Override
    public void getContestantVoteList(String language, String contest_id, String contestant_id, Callback<VoteListModel> callback) {
        apiHelper.getContestantVoteList(language, contest_id, contestant_id, callback);
    }


    @Override
    public void getCommentLists(Pagging<CommentsModel> pagging, Callback<Pagging> callback) {
        apiHelper.getCommentLists(pagging, callback);
    }


    @Override
    public void doSignup(String language, String email, String password, String name, String mobile, String nickname, int is_termstrue, int is_privacypolicy, int is_newsSubsribe, Callback<EmailOtpVerify> callback) {
        apiHelper.doSignup(language, email, password, nickname, mobile, name, is_termstrue, is_privacypolicy, is_newsSubsribe, callback);
    }

    @Override
    public void getLoginProfile(String language, String email, String password, String auto_login, String login_type, Callback<LoginDataModel> callback) {
        apiHelper.getLoginProfile(language, email, password, auto_login, login_type, callback);
    }

    @Override
    public void getUserProfileAlwasys(String language, String user_id, String user_type, Callback<LoginDataModel> callback) {
        apiHelper.getUserProfileAlwasys(language, user_id, user_type, callback);
    }

    @Override
    public void getSettings(String language, String user_id, Callback<SettingsModel> callback) {
        apiHelper.getSettings(language, user_id, callback);
    }

    @Override
    public void doubleCheckemail(String language, String email, Callback<String> callback) {
        apiHelper.doubleCheckemail(language, email, callback);
    }

    @Override
    public void attendanceCheckIn(String language, String user_id, Callback<String> callback) {
        apiHelper.attendanceCheckIn(language, user_id, callback);
    }

    @Override
    public void setSettings(String language, String user_id, String pushalert, String pushsound, String pushvibrate, Callback<String> callback) {
        apiHelper.setSettings(language, user_id, pushalert, pushsound, pushvibrate, callback);
    }


    @Override
    public void getAddVoteApi(String language, String contest_id, String contestant_id, String voter_id, String vote, String voter_name, Callback<StarDetailsVm> callback) {
        apiHelper.getAddVoteApi(language, contest_id, contestant_id, voter_id, vote, voter_name, callback);
    }

    @Override
    public void getGiftStarApi(String receiver_id, String sender_id, String sender_name, String star, String language, Callback<GiftDetailsVm> callback) {
        apiHelper.getGiftStarApi(receiver_id, sender_id, sender_name, star, language, callback);
    }


    @Override
    public void getSearchResult(String language, String searchTerm, Pagging<SearchList> pagging, Callback<Pagging<SearchList>> onApiCallback) {
        apiHelper.getSearchResult(language, searchTerm, pagging, onApiCallback);
    }

    @Override
    public void doRegisterDevice(String language, String user_id, String token, Callback<String> callback) {
        apiHelper.doRegisterDevice(language, user_id, token, callback);
    }

    @Override
    public void getDetailsbyPhoneNumber(String mobile, String language, Callback<UserFromMobile> callback) {
        apiHelper.getDetailsbyPhoneNumber(mobile, language, callback);
    }

    @Override
    public void getPlanList(Pagging<PaidChargeList> pagging, String language, Callback<Pagging<PaidChargeList>> homcallback) {
        apiHelper.getPlanList(pagging, language, homcallback);
    }

    @Override
    public void getNoticeLists(Pagging<NoticeList> pagging, String language, Callback<Pagging<NoticeList>> callback) {
        apiHelper.getNoticeLists(pagging, language, callback);
    }

    @Override
    public void getNotificationLists(Pagging<NotificationsList> pagging, String language, String user_id, Callback<Pagging<NotificationsList>> callback) {
        apiHelper.getNotificationLists(pagging, language, user_id, callback);
    }

    @Override
    public void editContestantDetails(String language, String contestantId, Uri imageUri, File file, String introduction, ArrayList<ContestantMedia> youtubeMedia, Callback<String> callback) {
        apiHelper.editContestantDetails(language, contestantId, imageUri, file, introduction, youtubeMedia, callback);
    }

    @Override
    public void deleteContestantMedia(String language, String mediaId, Callback<String> callback) {
        apiHelper.deleteContestantMedia(language, mediaId, callback);
    }

    @Override
    public void getUpdateUserProfile(String language, String user_id, String userType, String email, String mobile, String name, String nick_name, String current_password, String password, Callback<String> callback) {
        apiHelper.getUpdateUserProfile(language, user_id, userType, email, mobile, name, nick_name, current_password, password, callback);
    }

    @Override
    public void getVerifySocialMedia(String language, String social_id, String login_type, Callback<LoginDataModel> callback) {
        apiHelper.getVerifySocialMedia(language, social_id, login_type, callback);
    }

    @Override
    public void socialLogin(String language, String social_id, String name, String nick_name, String email, String login_type, String mobile, Callback<LoginDataModel> callback) {
        apiHelper.socialLogin(language, social_id, name, nick_name, email, login_type, mobile, callback);
    }

    @Override
    public void uploadMedia(String language, String contestantId, Uri uriToFile, File file, String mediaType, Callback<ContestantMedia> callback) {
        apiHelper.uploadMedia(language, contestantId, uriToFile, file, mediaType, callback);
    }

    @Override
    public void setBooleanAppPref(String key, boolean value) {
        mPreferencesHelper.setBooleanAppPref(key, value);
    }

    @Override
    public boolean getBooleanAppPref(String key, boolean defaultValue) {
        return mPreferencesHelper.getBooleanAppPref(key, defaultValue);
    }

    @Override
    public void beginTransaction(String language, String userId, String planId, String amount, String contestId, Callback<TransactionDetails> callback) {
        apiHelper.beginTransaction(language, userId, planId, amount, contestId, callback);
    }

    @Override
    public void endTransaction(String language, String transactionId,String paymentStatus,  String description, String paymentTransationId, String paymentDetails, Callback<RestResponseModel<EndTransactionModel>> callback) {
        apiHelper.endTransaction(language, transactionId, paymentStatus, description,paymentTransationId,paymentDetails, callback);
    }

    @Override
    public void saveUserToPref(LoginProfile user) {
        mPreferencesHelper.saveUserToPref(user);
    }

    @Override
    public void saveUserEmail(String email) {
        mPreferencesHelper.saveUserEmail(email);
    }

    @Override
    public void setUserId(String userId) {
        mPreferencesHelper.setUserId(userId);
    }

    @Override
    public LoginProfile getUserFromPref() {
        return mPreferencesHelper.getUserFromPref();
    }

    @Override
    public LoginProfile getUserEmail() {
        return mPreferencesHelper.getUserEmail();
    }

    @Override
    public EmailOtpVerify getUserId() {
        return mPreferencesHelper.getUserId();
    }

    @Override
    public void setResponseOfSkipButton(String skipButton) {
        mPreferencesHelper.setResponseOfSkipButton(skipButton);
    }

    @Override
    public String getSkipButtonResponse() {
        return mPreferencesHelper.getSkipButtonResponse();
    }


    @Override
    public void updateTransaction(String language, String transactionId, String paymentStatus, String description, String paymentTransationId, String paymentDetails, Callback<Object> callback) {
            apiHelper.updateTransaction(language, transactionId, paymentStatus, description, paymentTransationId, paymentDetails, callback);
    }

    @Override
    public void doVerifyEmailOtp(String email, String otp,String otpFor, Callback<LoginDataModel> callback) {
        apiHelper.doVerifyEmailOtp(email,otp,otpFor,callback);
    }

    @Override
    public void doResendOtp(String email,String otpFor, Callback<EmailOtpVerify> callback) {
        apiHelper.doResendOtp(email,otpFor,callback);
    }

    @Override
    public void doVerifyEmailForForgotPassword(String email, Callback<EmailOtpVerify> callback) {
        apiHelper.doVerifyEmailForForgotPassword(email,callback);
    }

    @Override
    public void doCreateNewPassword(String userId, String password, Callback<Object> callback) {
        apiHelper.doCreateNewPassword(userId, password, callback);
    }

    @Override
    public void getTokenFromRefreshToken(Callback<Object> callback) {
        apiHelper.getTokenFromRefreshToken(callback);
    }

    @Override
    public void deleteUserAccount(String userId, Callback<Object> callback) {
        apiHelper.deleteUserAccount(userId, callback);
    }

    //    Api helper method end
//    ====================================================
// DataManager Method Start


    @Override
    public void getSearchResult(String searchTerm, Pagging<SearchList> pagging, Callback<Pagging<SearchList>> onCallback) {
        apiHelper.getSearchResult(
                getLanguage(),
                searchTerm,
                pagging,
                onCallback
        );
    }

    @Override
    public void editContestantDetails(String contestantId, Uri imageUri, File file, String introduction, ArrayList<ContestantMedia> youtubeMedia, Callback<String> callback) {
        apiHelper.editContestantDetails(
                getLanguage(),
                contestantId,
                imageUri,
                file,
                introduction, youtubeMedia, callback
        );
    }

    @Override
    public void getContestantsImagesForEdit(String contestantId, Callback<ArrayList<ContestantMedia>> callback) {
        apiHelper.getContestantsImagesForEdit(
                getLanguage(),
                contestantId,
                callback
        );
    }


    @Override
    public void deleteContestantMedia(String mediaId, Callback<String> callback) {
        apiHelper.deleteContestantMedia(
                getLanguage(),
                mediaId,
                callback
        );
    }

    @Override
    public void getContestantsImages(String contestantId, Callback<ArrayList<ContestantMedia>> callback) {
        apiHelper.getContestantsImagesForEdit(getLanguage(), contestantId, callback);
    }

    @Override
    public void uploadMedia(String contestantId, Uri uriToFile, File file, String mediaType, Callback<ContestantMedia> callback) {
        apiHelper.uploadMedia(
                getLanguage(),
                contestantId,
                uriToFile,
                file,
                mediaType,
                callback
        );
    }

    @Override
    public String getLanguage() {
        return AppUtils.LANGUAGE_DEFAULT_VALUE;
        //todo something
    }

    @Override
    public void logout() {
        Log.d(TAG, "logout: ");
        logoutFacebook();
        logoutGoogle();
        logoutKakao();
        logoutNaver();
        AppPreferencesHelper.clear();


    }

    void logoutFacebook() {
        LoginManager.getInstance().logOut();
    }

    void logoutGoogle() {
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestEmail()
                .build();
        GoogleSignInClient mGoogleSignInClient = GoogleSignIn.getClient(context, gso);
        mGoogleSignInClient.signOut();
    }

    void logoutKakao() {
        UserManagement.getInstance().requestLogout(new LogoutResponseCallback() {
            @Override
            public void onCompleteLogout() {

            }
        });
    }

    void logoutNaver() {
        OAuthLogin.getInstance().logout(context);

    }

    @Override
    public String getFreeChargingUrl() {
        LoginProfile profile = getUserFromPref();
        Uri.Builder uriBuilder = new Uri.Builder()
                .scheme(AppApiHelper.BASE_URL_SCHEME)
                .authority(AppApiHelper.BASE_URL_HOST)
                .path(AppApiHelper.FREE_CHARGING_URL)
                .appendQueryParameter(AppApiHelper.KEY_DEVICE, Constants.OS_ANDROID_ALL_CAP);
        if (profile.getUser_id() != null && !profile.getUser_id().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UID, profile.getUser_id());
        }
        if (profile.getName() != null && !profile.getName().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UNAME, profile.getName());
        }
        if (profile.getEmail() != null && !profile.getEmail().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UEMAIL, profile.getEmail());
        }
        if (profile.getMobile() != null && !profile.getMobile().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UPHONE, profile.getMobile());
        }
        return uriBuilder.build().toString();
    }


    public String getUserIdx() {

        LoginProfile profile = getUserFromPref();
        return profile.getUser_id();

    }

    private String encodeUrl(String url) {
      /*  try {
            return URLEncoder.encode(url,"utf-8");
        }catch (Exception e){
            e.printStackTrace();
        }*/
        return url;
    }

    @Override
    public String getShopUrl() {
        LoginProfile profile = getUserFromPref();
        Uri.Builder uriBuilder = new Uri.Builder()
                .scheme(AppApiHelper.BASE_URL_SCHEME)
                .authority(AppApiHelper.BASE_URL_HOST)
                .path(AppApiHelper.SHOP_URL)
                .appendQueryParameter(AppApiHelper.KEY_CA_ID, "10");
        if (profile.getUser_id() != null && !profile.getUser_id().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UID, profile.getUser_id());
        }
        if (profile.getName() != null && !profile.getName().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UNAME, profile.getName());
        }
        if (profile.getEmail() != null && !profile.getEmail().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UEMAIL, profile.getEmail());
        }
        if (profile.getMobile() != null && !profile.getMobile().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UPHONE, profile.getMobile());
        }
        return uriBuilder.build().toString();
    }

    @Override
    public String getCouponUrl() {
        LoginProfile profile = getUserFromPref();
        Uri.Builder uriBuilder = new Uri.Builder()
                .scheme(AppApiHelper.BASE_URL_SCHEME)
                .authority(AppApiHelper.BASE_URL_HOST)
                .path(AppApiHelper.COUPON_CHARGING_URL);
        if (profile.getUser_id() != null && !profile.getUser_id().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UID, profile.getUser_id());
        }
        if (profile.getName() != null && !profile.getName().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UNAME, profile.getName());
        }
        if (profile.getEmail() != null && !profile.getEmail().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UEMAIL, profile.getEmail());
        }
        if (profile.getMobile() != null && !profile.getMobile().isEmpty()) {
            uriBuilder.appendQueryParameter(AppApiHelper.KEY_UPHONE, profile.getMobile());
        }
        return uriBuilder.build().toString();
    }

    @Override
    public Uri getAdUrl() {
        Uri.Builder uriBuilder = new Uri.Builder()
                .scheme(AppApiHelper.BASE_URL_SCHEME)
                .authority(AppApiHelper.BASE_URL_HOST)
                .path(AppApiHelper.AD_URL);
        return uriBuilder.build();
    }
}
