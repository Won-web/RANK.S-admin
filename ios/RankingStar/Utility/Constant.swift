//
//  Constant.swift
//  HafoosCRM
//
//  Created by etech-9 on 22/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

public enum TransactionStatus: String {
    case success      = "success"
    case fail         = "fail"
    case cancel       = "cancel"
}

class Constant: NSObject {
    
    struct API {
            
        static let BASEURL                           = Constant.ServerBaseURL.CLIENT_LIVE_V3_SECURE
        static let WEB_VIEW_BASEURL                  = Constant.ServerWEBVIEWURL.CLIENT_LIVE_V3_SECURE
        
        static let GET_TOKEN_FROM_REFRESH_TOKEN                     = "getTokenFromRefreshToken"
        static let GET_CONTEST_BANNERI_LIST_URL                     = "getContestBannerList"
        static let GET_SUB_CONTEST_LIST_URL                         = "getContestList"
        static let GET_SEARCH_LIST_URL                              = "contestantBySearch"
        static let GET_USER_PROFILE_DATA                            = "getProfileDetails"
//        static let LOGIN_URL                                        = "login"
        static let LOGIN_URL                                        = "userLogin"
//        static let SIGN_UP_URL                                      = "signup"
//        static let SIGN_UP_URL                                      = "userSignUp"
        static let SIGN_UP_URL                                      = "userSignUpApp"
        static let EDIT_USER_PROFILE_URL                            = "editUserProfile"
        static let DELETE_USER_ACCOUNT_URL                          = "deleteUserAccount"
        static let CHECK_EMAIL_EXISTS_URL                           = "checkEmailExists"
//        static let VERIFY_SOCIAL_LOGIN                              = "verifySocialMediaLogin"
        static let VERIFY_SOCIAL_LOGIN                              = "verifySocialMediaUserLogin"
//        static let SOCIAL_LOGIN_URL                                 = "socialLogin"
        static let SOCIAL_LOGIN_URL                                 = "socialSignUp"
        static let FORGOT_PASSWORD_URL                              = "forgotPassword"
        static let CREATE_NEW_PWD_URL                               = "createNewPassword"
        static let OTP_VERIFICATION_URL                             = "verifyOtp"
        static let OTP_RESEND_URL                                   = "resendOtp"
        static let GET_CONTEST_DETAILS_URL                          = "getContestDetails"
        static let GET_CONTESTANT_DETAILS_URL                       = "getContestantDetails"
        static let GET_CONTESTANT_MEDIA_GALLARY_URL                 = "getContestantMediaGallary"
        static let NOTICE_LIST                                      = "getNotice"
        static let PUSH_NOTIFICATION_LIST                           = "getNotification"
        static let GET_SETTINGS                                     = "getPushSetting"
        static let SET_SETTINGS                                     = "pushSetting"
        static let STAR_HISTORY                                     = "starHistory"
        static let VOTING_HISTORY                                   = "votingHistory"
        static let USER_DETAIL_BY_PHONE                             = "getDetailsByPhone"
        static let GIFT_STAR                                        = "giftstar"
        static let ADD_VOTE                                         = "addVote"
//        static let DEVICE_REGISTER                                  = "registerDevice"
        static let DEVICE_REGISTER                                  = "registerDeviceToken"
        static let PURCHASE_STAR_PLAN_LIST                          = "getPlanList"
//        static let PURCHASE_PROCESS_BIGIN                           = "beginTransaction"
//        static let COMPLATE_TRANSACTION                             = "completeTransaction"
        
        static let IAPP_TRANSACTION_START                           = "startTransaction"
        static let IAPP_TRANSACTION_END                             = "endTransaction"
        
        static let ADD_GALLARY_ITEM                                 = "addGallaryItem"
//        static let ATTENDENCE_CHECK                                 = "dailyCheckIn"
        static let ATTENDENCE_CHECK                                 = "dailyCheckInStar"
        static let EDIT_CONTESTANT_DETAIL_URL                       = "editContestantDetail"
        static let DELETE_GALLERY_ITEM_URL                          = "deleteGallaryItem"
        
        static let UNDER_CONSTRUCTION                               = "underConstruction"
//        static let NOTICE_DETAIL_WEBVIEW                            = "underConstruction"
//        static let TERMS_OF_USE_AND_PRIVACY_POLICY_WEBVIEW          = "termsAndConditionWebView?language=english"
        static let TERMS_OF_USE_AND_PRIVACY_POLICY_WEBVIEW          = "termsAndCondSignUp"
        static let USER_GUIDE_WEBVIEW                               = "howToUseWebView?language=english"
        
        static let CHARGING_STATION_WEBVIEW                         = "purchaseStarWebView?language=english&os=iOS"
//        static let CHARGING_FREE_POINT_WEBVIEW                      = "underConstruction"
//        static let CHARGING_FREE_POINT_WEBVIEW                      = "shopping/shop/free_charging.php?uid="
        static let CHARGING_FREE_POINT_WEBVIEW                      = "shopping/shop/free_charging.php?uid="
        static let CHARGING_FREE_POINT_WEBVIEW_NAME                 = "&uname="
        static let CHARGING_FREE_POINT_WEBVIEW_EMAIL                = "&uemail="
        static let CHARGING_FREE_POINT_WEBVIEW_PHONE                = "&uphone="
        static let CHARGING_FREE_POINT_WEBVIEW_DEVICE               = "&device=iOS"
        
//        static let CHARGING_COUPAN_WEBVIEW                          = "underConstruction"
//        static let CHARGING_COUPAN_WEBVIEW                          = "shopping/shop/cp.php?uid="
        static let CHARGING_COUPAN_WEBVIEW                          = "shopping/shop/cp.php?uid="
        static let CHARGING_COUPAN_WEBVIEW_NAME                     = "&uname="
        static let CHARGING_COUPAN_WEBVIEW1_EMAIL                   = "&uemail="
        static let CHARGING_COUPAN_WEBVIEW_PHONE                    = "&uphone="
        
//        static let CHARGING_SHOP_WEBVIEW                            = "underConstruction"
//        static let CHARGING_SHOP_WEBVIEW                            = "shopping/shop/list.php?ca_id=10&uid="
        static let CHARGING_SHOP_WEBVIEW                            = "shopping/shop/list.php?ca_id=10&uid="
        static let CHARGING_SHOP_WEBVIEW_NAME                       = "&uname="
        static let CHARGING_SHOP_WEBVIEW_EMAIL                      = "&uemail="
        static let CHARGING_SHOP_WEBVIEW_PHONE                      = "&uphone="
        
        static let PRIVACY_POLICY_WEBVIEW                           = "privacyPolicyForSignUp"
        static let TERM_CONDITION_WEBVIEW                           = "termsAndCondSignUp"
        
    }
    
    struct ServerBaseURL {
        static let CLIENT_LIVE_OLD                              = "http://ranking-star.com/api/"
        static let CLIENT_LIVE_OLD_SECURE                       = "https://ranking-star.com/api/"
        static let CLIENT_DEMO_OLD                              = "http://rankingstar.cafe24.com/api/"
        static let ETECH_DEMO                                   = "http://php.dss.gos.mybluehostin.me/rankingstar/api/"
        static let ETECH_DEMO_V2                                = "http://php.dss.gos.mybluehostin.me/rankingstar/apis/v2/"
        static let CLIENT_LIVE_V2_SECURE                        = "https://ranking-star.com/apis/v2/"
        static let CLIENT_LIVE_V3_SECURE                        = "https://ranking-star.com/apis/v3/"
        
        
    }

    struct ServerWEBVIEWURL {
        static let CLIENT_LIVE_OLD                                  = "http://ranking-star.com/"
        static let CLIENT_LIVE_OLD_SECURE                           = "https://ranking-star.com/"
        static let CLIENT_DEMO_OLD                                  = "http://rankingstar.cafe24.com/"
        static let ETECH_DEMO                                       = "http://php.dss.gos.mybluehostin.me/rankingstar/"
        static let ETECH_DEMO_V2                                    = "http://php.dss.gos.mybluehostin.me/rankingstar/"
        static let CLIENT_LIVE_V2_SECURE                            = "https://ranking-star.com/"
        static let CLIENT_LIVE_V3_SECURE                            = "https://ranking-star.com/"

    }
    
    struct ResponseStatus {
        static let SUCCESS          = 1
        static let SOCIAL_SUCCESS   = 2
        static let FAIL             = 0
        static let FAIL_TOKEN       = 3
    }
    
    struct ResponseParam {
        static let RESPONSE_FLAG                  = "res_code"
        static let RESPONSE_MESSAGE               = "res_message"
        static let RESPONSE_DATA                  = "res_data"
        
        static let PageLimit                      = 25
        
        static let CONTEST_STATUS_OPEN            = "open"
        static let CONTEST_STATUS_PREPARING       = "preparing"
        static let CONTEST_STATUS_CLOSE           = "close"
        static let LOGIN_TYPE_AUTH                = "auth"
        static let LOGIN_TYPE_APPLE               = "apple"
        static let LOGIN_TYPE_FACEBOOK            = "facebook"
        static let LOGIN_TYPE_GMAIL               = "google"
        static let LOGIN_TYPE_KAKAO               = "kakao"
        static let LOGIN_TYPE_NAVER               = "naver"
        static let MEDIA_TYPE_IMAGE               = "image"
        static let MEDIA_TYPE_VIDEO               = "video"
        static let MEDIA_TYPE_YOUTUBE_VIDEO       = "youtube"
        static let FILTER_CATEGORY_ACTIVE         = "active"
        static let APPLICATION_OS                 = "iOS"
        static let STAR_HISTORY_TYPE_VOTE         = "Vote"
        static let STAR_HISTORY_TYPE_GIFT         = "Gift"
        
        static let OTP_FOR_FRGT_PWD               = "forgotpassword"
        static let OTP_FOR_REGISTER               = "register"
        
    }
    
    struct API_ARR_NAME {
    }
    
    struct API_PERA_NAME {
        static let english                      = "english"
        static let korean                       = "korean"
        static let IN_APP_SUCCESS               = "success"
        static let IN_APP_FAIL                  = "fail"
    }
    
    struct CellIdentifier {
        
        static let TABLEVIEW_HEADER_SECTION             = "TableViewSectionHeader"
        static let CELL_CHARGING_HISTORY                = "ChargingHistoryCell"
        static let MAIN_CONTENT_BANNER                  = "MainContentBannerCell"
        static let CONTEST_LIST                         = "ContestListCell"
        static let CONTESTANT_LIST                      = "ContestantListCell"
        static let CONTESTANT_LIST2                     = "ContestantListCell2"
        static let SIDE_MENU_CELL                       = "SideMenuCell"
        static let VOTING_HISTORY_CELL                  = "VotingHistoryCell"
        static let EDIT_PROFILE_IMAGE_VIDEO_CELL        = "EditProfileImageVideoCell"
        static let CONTESTANT_PROFILE_IMAGE_VIDEO_CELL  = "ContestantProfileImageVideoCell"
        static let CONTESTANT_PROFILE_VIDEO_LIST_CELL   = "ContestantProfileVideoCell"
        static let EDIT_PROFILE_MSG_CELL                = "EditProfileMsgCell"
        static let EDIT_PROFILE_SUB_MSG_CELL            = "EditProfileSubMsgCell"
        static let PUSH_NOTIFICATION_CELL               = "PushNotificationCell"
        static let NOTICE_CELL                          = "NoticeCell"
        static let PAGE_VIEW_CELL                       = "PagerViewCell"
        static let PAGE_VIEW_SLIDER_CELL                = "SliderPagerViewCell"
        static let CONTESTANT_LIST_HEADER_VIEW          = "ContestantListHeaderView"
        static let CONTEST_BANNER_CELL                  = "ContestBannerCell"
        static let SEARCH_LIST_CELL                     = "SearchListCell"
        static let CHARGING_POINT_PURCHASE_CELL         = "ChargingPurchasePointCell"
        static let CHARGING_STATION_CATEGORY_CELL       = "ChargingStationCategoryCell"
       
        
    }
    
    struct UserDefaultKey {
//        static let LOGIN_KEY = "RS_IS_LOGIN_RS"
        static let KEY_IS_USER_LOGIN_WITH_FACEBOOK = "USER_LOGIN_WITH_FACEBOOK"
        static let KEY_IS_USER_AUTO_LOGIN = "USER_AUTO_LOGIN"
        static let KEY_IS_USER_EMAIL_LOGIN = "RS_IS_USER_EMAIL_LOGIN"
        static let KEY_LOGIN_TYPE = "USER_LOGIN_TYPE"
        static let KEY_USER_PROFILE_DICT = "USER_PROFILE_DICT"
        static let UNIQUE_DEVICE_ID = "IS_DEVICE_VENDER_ID"
        static let KEY_FORCE_UPDATE_APP = "forceUpdateApp"
        static let KEY_FORCE_UPDATE_SKIP_TAPPED = "isSkipTapped"
        static let RS_KEY_TOKENS = "RS_KEY_TOKENS"
    }
    
    struct DateFormat {
        static let DateFormatYYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss"
        static let Simple_Date_Format = "yyyy-MM-dd"
        static let DateTimeFormat = "MM.dd (E) hh:mm a"
    }
    
    struct Color {
        
        // COMMON COLORS
//        static let DARK_THEME_BLUE_COLOR = UIColor(red: 23/255, green: 100/255, blue: 160/255, alpha: 1)
        // NAVIGATION
//        static let NAVIGATION_BAR_BG_COLOR                      = UIColor(red:245/255, green:67/255, blue:134/255, alpha:1.0) // #f54387
        static let BLACK                                        = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.87)
        static let NAVIGATION_BAR_BG_COLOR                      = UIColor(red:255/255, green:75/255, blue:136/255, alpha:1.0)
        static let NAVIGATION_BAR_BG_BLACK_COLOR                = UIColor(red:29/255, green:29/255, blue:65/255, alpha:1.0)
        static let NAVIGATIONBAR_TEXT_COLOR                     = UIColor.white
        
        static let BTN_LOGIN_WITH_EMAIL_COLOR                   = NAVIGATION_BAR_BG_COLOR
        static let BTN_EDIT_USER_PROFILE_COLOR                  = UIColor(red:244/255, green:175/255, blue:60/255, alpha:1.0)
        
        static let BTN_LOGIN_WITH_GOOGLE_COLOR                  = UIColor.white
        static let BTN_LOGIN_WITH_FACEBOOK_COLOR                = UIColor(red:0/255, green:117/255, blue:235/255, alpha:1.0)
        static let BTN_LOGIN_WITH_KAKAO_COLOR                   = UIColor(red:255/255, green:191/255, blue:77/255, alpha:1.0)
        static let BTN_LOGIN_WITH_NAVER_COLOR                   = UIColor(red:77/255, green:180/255, blue:85/255, alpha:1.0)
        
        
        static let  APP_TXT_SEMI_BLACK                          = UIColor(red:30/255, green:30/255, blue:30/255, alpha:1.0)
        static let APP_TXT_LIGHT_GREY                           = UIColor(red:132/255, green:132/255, blue:132/255, alpha:1.0)
        static let DARK_BLACK_COLOR                             = UIColor(red: 64/255, green: 70/255, blue: 83/255, alpha: 1)
        static let LIGHT_GREY                                   = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        static let LIGHT_GREY11                                  = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        static let LIGHT_GREY_DARK_BORDER                                   = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        static let BTN_BACKGROUND_PINK                          = NAVIGATION_BAR_BG_COLOR
        static let SWITCH_BG_COLOR                              = NAVIGATION_BAR_BG_COLOR
        static let BTN_WHITE_TEXT_COLOR                         = UIColor.white
        static let BTN_SEND_MSG_COLOR                           = UIColor(red: 34/255, green: 135/255, blue: 238/255, alpha: 1)
        static let BTN_PINK_TEXT_COLOR                          = NAVIGATION_BAR_BG_COLOR
        static let BTN_WHITE_BORDER_COLOR                       = UIColor.white
        static let BTN_WHITE_BORDER_PINK_COLOR                  = NAVIGATION_BAR_BG_COLOR
        static let BTN_BLACK_TEXT_COLOR                         = UIColor.black
        static let WHITE_COLOR                                  = UIColor.white
        static let TXTF_TXT_WHITE_COLOR                         = UIColor.white
        static let BTN_GREDIENT_PINK_LEFT                       = UIColor(red: 221/255, green: 44/255, blue: 139/255, alpha: 1)
        static let BTN_GREDIENT_PINK_RIGHT                      = UIColor(red: 255/255, green: 84/255, blue: 136/255, alpha: 1)
        static let BTN_GREDIENT_GRAY_LEFT                       = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        static let BTN_SEND_GIFT                                = UIColor(red: 104/255, green: 173/255, blue: 84/255, alpha: 1)
        static let BTN_GREDIENT_GRAY_RIGHT                      = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        
        // TEXTFIELD
        static let TXT_TEXT                                     = Constant.Color.DARK_BLACK_COLOR
        static let TXT_PLACEHOLDER_SEMI_BLACK                   = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.8)
        static let TXT_PLACEHOLDER                              = Constant.Color.LIGHT_GREY
        static let IMG_BG_VIEW_CLOSE                            = UIColor(red: 62/255, green: 69/255, blue: 81/255, alpha: 0.8)
        
        static let LBL_LOGIN_NORMAL                             = Constant.Color.LIGHT_GREY
        static let LBL_CELL_PINK_COLOR                          = Constant.Color.NAVIGATION_BAR_BG_COLOR
        static let LBL_TXT_PINK_COLOR                           = Constant.Color.NAVIGATION_BAR_BG_COLOR
        static let TXTF_PLACE_HOL_PINK_COLOR                    = Constant.Color.NAVIGATION_BAR_BG_COLOR
        static let TXTF_TXT_PINK_COLOR                          = Constant.Color.NAVIGATION_BAR_BG_COLOR
        static let LBL_WHITE = UIColor.white
        static let LBL_TXT_CURRENT_LOGIN                        = UIColor(red: 41/255, green: 109/255, blue: 242/255, alpha: 1.0)
        static let LBL_TXT_EMAIL_NOT_AVAILABLE                  = UIColor.red
        static let LBL_LOGIN_DARK_BLACK_COLOR                   = Constant.Color.DARK_BLACK_COLOR
        static let LBL_LOGIN_DARK_GREY_COLOR                    = UIColor(red: 80/255, green: 85/255, blue: 92/255, alpha: 1.0)
        static let LBL_LIKE_COUNT_PINK                          = Constant.Color.NAVIGATION_BAR_BG_COLOR
        static let LBL_GRAY_COLOR                               = UIColor(red: 163/255, green: 163/255, blue: 163/255, alpha: 1.0)
        static let LBL_SEMI_BLACK_POPUP_COLOR                   = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
        
        static let EDIT_TEXT_COLOR                              = APP_TXT_SEMI_BLACK
        static let CELL_TEXT_LIKE_NAC_COLOR                     = NAVIGATION_BAR_BG_COLOR
        static let BTN_TXTF_SELECTED_PLACE_HOLDER_COLOR         = APP_TXT_LIGHT_GREY// Text color Dark grey
        static let BTN_TXTF_UNSELECTED_PLACE_HOLDER_COLOR       = APP_TXT_LIGHT_GREY // Text color Dark grey
        static let VIEW_BORDER_COLOR                            = Constant.Color.LIGHT_GREY
        static let VIEW_SEMI_GRAY_BORDER_COLOR                  = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        static let VIEW_IMG_BG_GRAY_COLOR                       = VIEW_SEMI_GRAY_BORDER_COLOR //UIColor(red: 254/255, green: 209/255, blue: 244/255, alpha: 0.5)
        static let VIEW_BORDER_USER_EDIT_PROFILE_COLOR          = UIColor(red: 172/255, green: 180/255, blue: 188/255, alpha: 1.0)
        static let VIEW_SEPRETOR_COLOR                          = UIColor(red: 204/255, green: 205/255, blue: 204/255, alpha: 1.0)
        static let VIEW_TRANSPERENT_BG_POPUP_COLOR              = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        static let VIEW_BG_IMG_PRIVIEW_COLOR                    = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        static let TXTV_BORDER_COLOR                            = Constant.Color.DARK_BLACK_COLOR
        static let VIEW_BORDER_PINK_COLOR                       = Constant.Color.NAVIGATION_BAR_BG_COLOR
        static let VIEW_BORDER_SEME_LIGHT_COLOR                 = UIColor(red:132/255, green:132/255, blue:132/255, alpha:0.5)
        static let BTN_BORDER_COLOR                             = Constant.Color.LIGHT_GREY
        static let VIEW_BG_TOTAL_QUANTITY_COLOR                 = UIColor(red:240/255, green:240/255, blue:240/255, alpha:1.0)
        static let TXTF_BG_COLOR                                = UIColor(red:240/255, green:240/255, blue:240/255, alpha:1.0)
        static let LBL_BG_COLOR                                 = APP_TXT_LIGHT_GREY
        static let LBL_CELL_BG_PINK_TEXT                        = NAVIGATION_BAR_BG_COLOR
        static let LBL_CELL_DARK_BLACK_COLOR                    = Constant.Color.DARK_BLACK_COLOR
        static let VIEW_BG_TAB_BAR_COLOR                        = NAVIGATION_BAR_BG_COLOR
        static let VIEW_BG_EDIT_PROFILE_DETAIL_COLOR            = UIColor(red:255/255, green:247/255, blue:250/255, alpha:1.0)
        static let VIEW_BG_CELL_PINK_COLOR                      = NAVIGATION_BAR_BG_COLOR
        static let VIEW_BG_FACEBOOK_COLOR                       = BTN_LOGIN_WITH_FACEBOOK_COLOR
        static let BTN_TXTF_ERROR_COLOR                         = UIColor.red
        static let BTN_ERROR_TXTF_SELECTED_PLACE_HOLDER_COLOR   = UIColor.red
        static let BTN_ERROR_TXTF_UNSELECTED_PLACE_HOLDER_COLOR = UIColor.red
        
        static let  APP_VIEW_BG_GRAY                            = UIColor(red:203/255, green:203/255, blue:203/255, alpha:1.0)
        static let  VIEW_BG_GIFT_GRAY                            = UIColor(red:216/255, green:216/255, blue:216/255, alpha:1.0)
        
        static let  APP_VIEW_BG_HISTORY_TITLE                   = UIColor(red:22/255, green:12/255, blue:57/255, alpha:1.0)
        static let  CONTESTANT_LIST_CELL_ONE_COLOR              = NAVIGATION_BAR_BG_COLOR
        static let  CONTESTANT_LIST_CELL_SECOND_COLOR           = UIColor(red:49/255, green:53/255, blue:65/255, alpha:1.0)
        static let  CONTESTANT_LIST_CELL_THIRD_COLOR            = UIColor(red:172/255, green:180/255, blue:188/255, alpha:1.0)
        static let  CONTEST_LIST_CELL_ONE_COLOR                 = NAVIGATION_BAR_BG_COLOR
        static let  CONTEST_LIST_CELL_SECOND_COLOR              = UIColor(red:49/255, green:52/255, blue:65/255, alpha:1.0)
        static let  CONTEST_LIST_CELL_THIRD_COLOR               = UIColor(red:158/255, green:164/255, blue:175/255, alpha:1.0)
        static let  TABLE_VIEW_BG_COLOR                         = UIColor(red:231/255, green:231/255, blue:231/255, alpha:1.0)
        
        // base view controller
        static let COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR   = UIColor(red: 127.0/255.0, green: 136.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        static let TEXT_BLACK_COLOR                             = APP_TXT_SEMI_BLACK
        static let BTN_SUBMIT_BACKGROUND_COLOR                  = UIColor(red:255/255, green:88/255, blue:139/255, alpha:1.0)
//        static let BTN_WHITE_TEXT_COLOR                           = UIColor.white
        static let TXTF_LIKE_PLACE_HOLDER_COLOR                 = APP_TXT_LIGHT_GREY
        static let LIGHT_GREY1                                  = UIColor(red:89/255, green:92/255, blue:101/255, alpha:1.0)
        static let VIEW_BACKGROUND                              = UIColor(red:240/255, green:237/255, blue:237/255, alpha:1.0)
        
        static let COLLECTION_CATE_1                            = UIColor(red:255/255, green:103/255, blue:156/255, alpha:1.0)
        static let COLLECTION_CATE_2                            = UIColor(red:255/255, green:120/255, blue:0/255, alpha:1.0)
        
        static let IMAGE_SHADE                                  = UIColor(red:32/255, green:0/255, blue:0/255, alpha:0.5)
//        static let STATUS_BAR_GREY_COLOR                        = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.16)
        static let STATUS_BAR_GREY_COLOR                        = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
    }
    
    struct Font {
        
//        <string>NanumGothic-Bold.ttf</string>
//        <string>NanumGothic-ExtraBold.ttf</string>
//        <string>NanumGothic-Regular.ttf</string>
//        <string>NanumBarunGothic.ttf</string>
//        <string>NanumBarunGothicBold.ttf</string>
//        <string>NanumBarunGothicLight.ttf</string>
//        <string>NanumBarunGothicUltraLight.ttf</string>

        
        //MARK:Font Size
//        static let FONT_REGULAR                     =   "Signika-Regular"
//        static let FONT_BOLD                        =   "Signika-Bold"
//        static let FONT_LIGHT                       =   "Signika-Regular"
        
        static let FONT_REGULAR                     =   "NanumBarunGothic"
        static let FONT_BOLD                        =   "NanumBarunGothicBold"
        static let FONT_LIGHT                       =   "NanumBarunGothic"
        
        
        // NAVIGATION
        static let NAVIGATIONBAR_TEXT                        = UIFont (name: FONT_BOLD, size: 18)
        
        // LABEL
        static let FONT_LOGIN_WITH_EMAIL                     = UIFont (name: FONT_BOLD, size: 15)
        
        static let FONT_SIMPLE_DETAILS_BTN                   = UIFont (name: FONT_BOLD, size: 14)
        static let TXTFIELD_PLACEHOLDER                      = UIFont (name: FONT_REGULAR, size: 15)
        static let TXTFIELD_PLACEHOLDER_BIG                  = UIFont (name: FONT_REGULAR, size: 20)
        static let BTN_NORMAL_LOGIN_TEXT                     = UIFont (name: FONT_REGULAR, size: 15)
        static let BTN_NORMAL_LOGIN_TEXT1                     = UIFont (name: FONT_BOLD, size: 15)
        static let BTN_BOLD_SIGNUP_ID                        = UIFont (name: FONT_BOLD, size: 15)
        
        static let LBL_NORMAL_TEXT                           = UIFont (name: FONT_REGULAR, size: 15)
        static let LBL_NORMAL_TEXT1                          = UIFont (name: FONT_BOLD, size: 16)
        static let LBL_NORMAL_THIRD_TEXT                     = UIFont (name: FONT_REGULAR, size: 14)
        static let LBL_NORMAL_THIRD_TEXT1                    = UIFont (name: FONT_BOLD, size: 14)
        static let LBL_NORMAL_BOLD_TEXT                      = UIFont (name: FONT_BOLD, size: 15)
        static let LBL_NORMAL_BOLD_TEXT11                    = UIFont (name: FONT_REGULAR, size: 13)
        static let LBL_NORMAL_BOLD_TEXT1                     = UIFont (name: FONT_REGULAR, size: 15)
        static let LBL_NORMAL_THIRD_BOLD_TEXT                = UIFont (name: FONT_BOLD, size: 14)
        static let LBL_SMALL_TEXT                            = UIFont (name: FONT_REGULAR, size: 13)
        static let LBL_NORMAL_TEXT_VIEW                      = UIFont (name: FONT_REGULAR, size: 15)
        static let LBL_SMALL_TEXT2                           = UIFont (name: FONT_REGULAR, size: 12)
        static let LBL_BIG_TEXT                              = UIFont (name: FONT_BOLD, size: 20)
        static let LBL_VERY_BIG_TEXT                         = UIFont (name: FONT_REGULAR, size: 22)
        static let LBL_VERY_BIG_TEXT_BOLD                    = UIFont (name: FONT_BOLD, size: 22)
        static let LBL_HEADER_TEXT                           = UIFont (name: FONT_BOLD, size: 17)
        static let LBL_HEADER_TEXT_REG                       = UIFont (name: FONT_REGULAR, size: 17)
        static let LBL_HEADER_TEXT_CELL                      = UIFont (name: FONT_BOLD, size: 17)
        static let LBL_BIG_TEXT_CELL                         = UIFont (name: FONT_BOLD, size: 19)
        static let LBL_EDIT_PROFILE_SEND_TEXT                = UIFont (name: FONT_BOLD, size: 15)
        
        //Base View controller
        static let FONT_BOLD_ERROR_TITLE                    = UIFont (name: FONT_BOLD, size: 14)
        static let FONT_BOLD_ERROR_MEG                      = UIFont (name: FONT_BOLD, size: 12)
        static let FONT_BASE_VC_REGULAR                     = UIFont (name: FONT_BOLD, size: 17)
        static let FONT_TBLV_CELL_DETAILS_LBL               = UIFont (name: FONT_LIGHT, size: 13)
        static let FONT_NORMAL_HEADER                       = UIFont (name: FONT_BOLD, size: 15)
        static let FONT_SIGN_UP                             = UIFont (name: FONT_BOLD, size: 14)
        static let FONT_NAVIGATION_HEADER                   = UIFont (name: FONT_BOLD, size: 15)
        static let LBL_EDIT_PROFILE_TITLE                   = UIFont (name: FONT_BOLD, size: 15)
        static let LBL_EDIT_PROFILE_DETAIL                  = UIFont (name: FONT_REGULAR, size: 14)
        static let LBL_COLLECTION_TEXT                       = UIFont (name: FONT_BOLD, size: 18)
    }
    
    struct Image {
        static let user_email = "user"
        static let user_lock = "padlock"
        static let check_box_check = "check_box_check"
        static let check_box_empt = "check_box_empt"
        static let back = "back"
        static let home = "home"
        static let search = "search"
        static let search_black = "search_black"
        static let menu = "menu"
        static let menu_black = "menu_black"
        static let rating_star = "rating_star"
        //static let vote_history_star = "vote_history_star"
        static let close = "close"
        static let right_arrow = "right_arrow"
        static let up_arrow = "up_arrow"
        static let down_arrow = "down_arrow"
        static let user_profile = "user_profile"
        static let next = "next"
        static let close_white = "close_white"
        static let round_closed = "round_closed"
        static let vote_star1 = "vote_star1"
        static let vote_star10 = "vote_star10"
        static let vote_star_all = "vote_star_all"
        static let facebook = "facebook"
        static let insta = "insta"
        static let kakao = "kakao"
        static let talk = "talk"
        static let history = "history"
        static let free_charge = "free_charge"
        static let ic_note = "ic_note"
        static let play = "play"
        static let add_pink = "add_pink"
        static let logo_kor = "logo_kor"
        static let kakao_btn = "kakao_btn"
        static let naver = "naver"
        static let facebook_white = "facebook_white"
        static let google = "google"
        static let next_white = "next_white"
        static let star_shop = "star_shop"
        static let home_black = "home_black"
        static let up_arrow_pink = "up_arrow_pink"
        static let tab_share = "tab_share"
        static let tab_star_charging = "tab_star_charging"
        static let tab_vote_recored = "tab_vote_history"
        static let tab_vote = "tab_vote"
        static let tab_gift = "tab_gift"
        static let history_profile = "history_profile"
        static let history_star = "history_star"
        static let user_send_msg = "user_send_msg"
        static let heart_like = "heart_like"
        static let heart_dislike = "heart_dislike"
        static let naver_green = "naver_green"
        static let notification = "notification"
        static let setting = "setting"
        static let like = "like"
        static let logo_white_kor = "logo_white_kor"
        static let charge_station = "charge_station"
        static let gift_black = "gift_black"
        static let charge_station_black = "charge_station_black"
        static let question = "question"
        static let back_black = "back_black"
        static let logo_white_side_menu_kor = "logo_white_side_menu_kor"
        static let nav_gradient_pink = "nav_gradient_pink"
        static let btn_gradient_pink = "btn_gradient_pink"
        static let slider_pause = "slider_pause"
        static let slider_play = "slider_play"
        static let close1 = "close1"
        static let STAR_BACKGROUND = "star_background"
        static let user_default_gift = "user_default_gift"
        static let Default_iOS = "Home_main_iOS"
        static let Banner_iOS = "Home_samll_iOS"
        static let Video_iOS = "profile_video_iOS"
        static let close_white_thin_side_menu = "close_white_thin"
        static let splace_screen1 = "splace_screen1"
        static let apple = "apple_logo_black"
        static let apple_white = "apple_logo_white"
    }
    
    static let NETWORK_HOST_NAME        =   "www.google.in"
    static let GOOGL_CLIENT_ID          = "233608466577-rfs86nredkt2ph973fc3uuqvr01a4711.apps.googleusercontent.com"
    static let KEY_DEVICE_TOKEN         = "pushnotification_token"
    static let FACEBOOK_AUTH_TOKEN      = "fb467507857286658"
    static let NAVER_AUTH_TOKEN         = "thirdparty20samplegame"
    
}

