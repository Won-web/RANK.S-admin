package com.etech.starranking.data.network;


import android.net.Uri;
import android.provider.ContactsContract;

import com.etech.starranking.data.DataManager;
import com.etech.starranking.data.network.model.Pagging;
import com.etech.starranking.ui.activity.model.CategoryList;
import com.etech.starranking.ui.activity.model.CommentsModel;
import com.etech.starranking.ui.activity.model.ContestDetailAndContestantListModel;
import com.etech.starranking.ui.activity.model.ContestSliderContents;
import com.etech.starranking.ui.activity.model.ContestantModel;
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
import com.etech.starranking.ui.activity.model.TransactionDetails;
import com.etech.starranking.ui.activity.model.UserFromMobile;
import com.etech.starranking.ui.activity.model.VoteListModel;

import java.io.File;
import java.util.ArrayList;

public interface ApiHelper {

    void getHomeSliderList(Pagging<ContestSliderContents> pagging, String language,
                           DataManager.Callback<Pagging<ContestSliderContents>> homcallback);

    void getHomeSubContestList(Pagging<SubContestList> pagging, String language,
                               DataManager.Callback<Pagging<SubContestList>> homcallback);

    // void getContestantList(String langugae, String contest_id, DataManager.Callback<ArrayList<ContestantList>> callback);

    // void getContestDetails(String langugae, String contest_id, DataManager.Callback<ArrayList<ContestDetails>> callback);

    void getContestContestantList(String language, String contest_id, DataManager.Callback<ContestDetailAndContestantListModel> callback);


    void getContestCategory(Pagging<CategoryList> pagging, DataManager.Callback<Pagging> callback);

    void getContestantDetails(String language, String contestant_id, String contest_id, DataManager.Callback<ContestantModel> callback);


    void getOtherContestantDetails(Pagging<OtherContestantDetails> pagging,
                                   DataManager.Callback<Pagging> callback);

//    void getContestantsImages(Pagging<ContestantMedia> pagging,DataManager.Callback<Pagging> callback);

    void getContestantsImagesForEdit(String language, String contestantId,
                                     DataManager.Callback<ArrayList<ContestantMedia>> callback);

    void getEarningStars(String language, String user_id, DataManager.Callback<StarHistory> callback);

    void getUsedStars(String language, String user_id,
                      DataManager.Callback<StarHistory> callback);

    void getContestantVoteList(String language, String contest_id, String contestant_id,
                               DataManager.Callback<VoteListModel> callback);

    void getCommentLists(Pagging<CommentsModel> pagging, DataManager.Callback<Pagging> callback);


    void doSignup(String language, String email, String password, String name, String mobile, String nickname, int is_termstrue, int is_privacypolicy, int is_newsSubsribe, DataManager.Callback<EmailOtpVerify> callback);

    void getLoginProfile(String language, String email, String password, String auto_login, String login_type, DataManager.Callback<LoginDataModel> callback);

    void getUserProfileAlwasys(String language, String user_id, String user_type, DataManager.Callback<LoginDataModel> callback);

    void getSettings(String language, String user_id, DataManager.Callback<SettingsModel> callback);

    void doubleCheckemail(String language, String email, DataManager.Callback<String> callback);

    void attendanceCheckIn(String language, String user_id, DataManager.Callback<String> callback);

    void setSettings(String language, String user_id, String pushalert, String pushsound, String pushvibrate, DataManager.Callback<String> callback);

    void getAddVoteApi(String language, String contest_id,
                       String contestant_id, String voter_id, String vote,
                       String voter_name, DataManager.Callback<StarDetailsVm> callback);

    void getGiftStarApi(String receiver_id, String sender_id, String sender_name,
                        String star, String language, DataManager.Callback<GiftDetailsVm> callback);

    void getSearchResult(String language, String searchTerm, Pagging<SearchList> pagging, DataManager.Callback<Pagging<SearchList>> onApiCallback);

    void doRegisterDevice(String language, String user_id, String token, DataManager.Callback<String> callback);

    void getDetailsbyPhoneNumber(String mobile, String language, DataManager.Callback<UserFromMobile> callback);

    void getPlanList(Pagging<PaidChargeList> pagging, String language,
                     DataManager.Callback<Pagging<PaidChargeList>> homcallback);

    void getNoticeLists(Pagging<NoticeList> pagging, String language, DataManager.Callback<Pagging<NoticeList>> callback);

    void getNotificationLists(Pagging<NotificationsList> pagging, String language, String user_id, DataManager.Callback<Pagging<NotificationsList>> callback);

    void editContestantDetails(String language, String contestantId, Uri imageUri, File file, String introduction, ArrayList<ContestantMedia> youtubeMedia, DataManager.Callback<String> callback);

    void deleteContestantMedia(String language, String mediaId, DataManager.Callback<String> callback);

    void getUpdateUserProfile(String language, String user_id, String userType, String email,
                              String mobile, String name, String nick_name,
                              String current_password, String password,
                              DataManager.Callback<String> callback);

    void getVerifySocialMedia(String language, String social_id, String login_type, DataManager.Callback<LoginDataModel> callback);

    void socialLogin(String language, String social_id, String name,
                     String nick_name, String email,
                     String login_type, String mobile, DataManager.Callback<LoginDataModel> callback);

    void uploadMedia(String language,
                     String contestantId,
                     Uri uriToFile,
                     File file,
                     String mediaType,
                     DataManager.Callback<ContestantMedia> callback);

    void beginTransaction(String language,
                          String userId,
                          String planId,
                          String amount,
                          String contestId,
                          DataManager.Callback<TransactionDetails> callback);

    void endTransaction(String language,
                        String transactionId,
                        String paymentStatus,
                        String description,
                        String paymentTransationId,
                        String paymentDetails,
                        DataManager.Callback<RestResponseModel<EndTransactionModel>> callback
    );

    void updateTransaction(String language,
                           String transactionId,
                           String paymentStatus,
                           String description,
                           String paymentTransationId,
                           String paymentDetails,
                           DataManager.Callback<Object> callback
    );

    void doVerifyEmailOtp(String email, String otp, String otpFor, DataManager.Callback<LoginDataModel> callback);

    void doResendOtp(String email, String otpFor, DataManager.Callback<EmailOtpVerify> callback);

    void doVerifyEmailForForgotPassword(String email, DataManager.Callback<EmailOtpVerify> callback);

    void doCreateNewPassword(String userId, String password, DataManager.Callback<Object> callback);

    void getTokenFromRefreshToken( DataManager.Callback<Object> callback);

    void deleteUserAccount(String userId, DataManager.Callback<Object> callback);
}
