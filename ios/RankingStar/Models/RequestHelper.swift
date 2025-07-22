//
//  RequestHelper.swift
//  HafoosCRM
//
//  Created by etech-9 on 22/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

typealias ReqCompletionBlock = (_ resObj : NSObject , _ resCode : Int , _ resMessage : String) ->Void

class RequestHelper: NSObject, ETechAsyncRequestDelegate {
    private var completionBlock:ReqCompletionBlock = { resObj, resCode, resMessage in }
    
    //MARK:- API Response
    func eTechAsyncRequestDelegate(_ action: String, responseData: Response) {
        
        if (responseData.resposeObject as? NSDictionary) == nil {
            completionBlock("" as NSObject, Constant.ResponseStatus.FAIL, "INTERNAL_SERVER_ERROR".localizedLanguage())
            return
        }
        
        var dicResponse = responseData.resposeObject as! [String:Any]
        
        if (dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE] as? String) == nil {
            
            dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE] = ""
        }
        
        
        if (action == Constant.API.GET_TOKEN_FROM_REFRESH_TOKEN) {
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                
            }
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.STAR_HISTORY) {
            var objStarHistoryModel = ChargingHistoryModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objStarHistoryModel = ChargingHistoryModel.dictToUserObjectConvertion(dictData: dic)
                
            }
            completionBlock(objStarHistoryModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }else if (action == Constant.API.GET_CONTEST_BANNERI_LIST_URL) {
            var objContestDetail = ContestDetail()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = (dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary)
                objContestDetail = ContestDetail.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objContestDetail as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }else if (action == Constant.API.GET_SUB_CONTEST_LIST_URL) {
            var objContestDetail = ContestDetail()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objContestDetail = ContestDetail.dictToUserObjectConvertionSubContest(dictData: dic)
                
                if let objRefData = dic["has_more_page"] as? Bool {
                    objContestDetail.hasMoreRecored = objRefData
                }
                
            }
            completionBlock(objContestDetail as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GET_SEARCH_LIST_URL) {
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionSearch(dictData: dic)
                //contestant_list
                objUserProfileModel.hasMoreRecored = false
                if let objRefData = dic["has_more_page"] as? Bool {
                    objUserProfileModel.hasMoreRecored = objRefData
                }
                
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GET_USER_PROFILE_DATA) {
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
                
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.LOGIN_URL) {
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.DEVICE_REGISTER) {
            //            let objUserProfileModel = UserProfileModel()
            
            //            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
            //                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
            //
            ////                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
            //
            //            }
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.VERIFY_SOCIAL_LOGIN) {
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
                
            }else if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SOCIAL_SUCCESS) {
                //                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                //                if let resCode = dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as? Int {
                //                    objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic, resCode: resCode)
                //                }
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.SOCIAL_LOGIN_URL) {
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.NOTICE_LIST) {
            let objNoticeModel = Notice()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                
                objNoticeModel.arrNotice = Notice.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objNoticeModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.PUSH_NOTIFICATION_LIST) {
            let objPushNotificationeModel = PushNotification()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                
                objPushNotificationeModel.arrPushNotification = PushNotification.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objPushNotificationeModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GET_SETTINGS) {
            var objSettingsModel = Settings()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objSettingsModel = Settings.dictToUserObjectConvertionContest(dictData: dic)
                
            }
            completionBlock(objSettingsModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.SET_SETTINGS) {
            let objSettingsModel = Settings()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                //                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                //
                //                objNoticeModel = Notice.dictToUserObjectConvertionSearch(dictData: dic)
                //
                //                objUserProfileModel.hasMoreRecored = false
                //                if let objRefData = dic["has_more_page"] as? Bool {
                //                    objUserProfileModel.hasMoreRecored = objRefData
                //                }
                
            }
            completionBlock(objSettingsModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.VOTING_HISTORY) {
            var objVotingHistoryModel = VoteHistory()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objVotingHistoryModel = VoteHistory.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objVotingHistoryModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.USER_DETAIL_BY_PHONE) {
            var objUserDetailByPhone = UserDetailByPhone()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objUserDetailByPhone = UserDetailByPhone.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objUserDetailByPhone as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GIFT_STAR) {
            var objGift = Gift()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objGift = Gift.dictToUserObjectConvertionContest(dictData: dic)
            }else {
                if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.FAIL) {
                    let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                    
                    if dic != nil {
                        objGift = Gift.dictToUserObjectConvertionContest(dictData: dic)
                    }
                }
            }
            completionBlock(objGift as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.ADD_VOTE) {
            var objVotePopUp = VotePopUp()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objVotePopUp = VotePopUp.dictToUserObjectConvertionContest(dictData: dic)
            }else {
//                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
//                
//                if dic != nil {
//                    objVotePopUp = VotePopUp.dictToUserObjectConvertionContest(dictData: dic)
//                }
            }
            completionBlock(objVotePopUp as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.PURCHASE_STAR_PLAN_LIST) {
            let objStarPurchasePlan = StarPurchasePlan()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objStarPurchasePlan.arrPlanList = StarPurchasePlan.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objStarPurchasePlan as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.ATTENDENCE_CHECK) {
            var objAttendenceCheck = AttendenceCheck()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objAttendenceCheck = AttendenceCheck.dictToUserObjectConvertionContest(dictData: dic)
            }
            completionBlock(objAttendenceCheck as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.SIGN_UP_URL) {
//            var objUserProfileModel = UserProfileModel()
            var objOTP = OTP()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objOTP = OTP.dictToObjectConvertionFrgtPwd(dictData: dic)
//                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
            }
            completionBlock(objOTP as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.FORGOT_PASSWORD_URL) {
            var objOTP = OTP()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objOTP = OTP.dictToObjectConvertionFrgtPwd(dictData: dic)
            }
            completionBlock(objOTP as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.OTP_VERIFICATION_URL) {
//            var objOTP = OTP()
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionLogin(dictData: dic)
//                objOTP = OTP.dictToObjectConvertionVerifyOTP(dictData: dic)
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.CREATE_NEW_PWD_URL) {
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
            }
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.OTP_RESEND_URL) {
            var objOTP = OTP()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objOTP = OTP.dictToObjectConvertionFrgtPwd(dictData: dic)
            }
            completionBlock(objOTP as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.CHECK_EMAIL_EXISTS_URL) {
            
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.EDIT_USER_PROFILE_URL) {
            
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.DELETE_USER_ACCOUNT_URL) {
            
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GET_CONTESTANT_DETAILS_URL) {
            var objUserProfileModel = UserProfileModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objUserProfileModel = UserProfileModel.dictToUserObjectConvertionContestantProfileDetails(dictData: dic)
            }
            completionBlock(objUserProfileModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GET_CONTESTANT_MEDIA_GALLARY_URL) {
            var objMyMediaGallaryModel = MyMediaGallaryModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objMyMediaGallaryModel = MyMediaGallaryModel.dictToUserObjectConvertionMediaGallary(dictData: dic)
            }
            completionBlock(objMyMediaGallaryModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.GET_CONTEST_DETAILS_URL) {
            var objContestantDetailModel = ContestantDetailModel()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                
                objContestantDetailModel = ContestantDetailModel.dictToUserObjectConvertionContestantList(dictData: dic)
            }
            completionBlock(objContestantDetailModel as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.EDIT_CONTESTANT_DETAIL_URL) {
            //            var objContestantDetailModel = ContestantDetailModel()
            //
            //            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
            //                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
            //
            //                objContestantDetailModel = ContestantDetailModel.dictToUserObjectConvertionContestantList(dictData: dic)
            //            }
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.DELETE_GALLERY_ITEM_URL) {
            
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.ADD_GALLARY_ITEM) {
            completionBlock("" as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, "")
        }
        else if (action == Constant.API.IAPP_TRANSACTION_START) {
            var tranjactionId:String = ""
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let objUserDic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! NSDictionary
                if let tranjactionDic = objUserDic["transaction_details"] as? NSDictionary
                {
                    if let objRefData = tranjactionDic["transaction_id"] as? String {
                        tranjactionId = String(objRefData)
                    }
                }
                
            }
            completionBlock(tranjactionId as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        else if (action == Constant.API.IAPP_TRANSACTION_END) {
            var objVotePopUp = VotePopUp()
            
            if (dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int == Constant.ResponseStatus.SUCCESS) {
                let dic = dicResponse[Constant.ResponseParam.RESPONSE_DATA] as! [String:Any]
                objVotePopUp = VotePopUp.dictToUserObjectConvertionContest(dictData: dic)
            }
            
            completionBlock(objVotePopUp as NSObject, dicResponse[Constant.ResponseParam.RESPONSE_FLAG] as! Int, dicResponse[Constant.ResponseParam.RESPONSE_MESSAGE]! as! String)
        }
        
    }
    
    
    
    //MARK:- API Request Call
    func starHistoryAPI(resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            request.dictParamValues["user_id"] = objUserProfile.strUserId
        }
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.STAR_HISTORY, requestData: request)
    }
    
    //    func chargingHistoryAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
    //
    //        completionBlock = resBlock
    //
    //        let request = Request()
    //        request.setDefaultParameter()
    //
    //        //        request.dictParamValues["email"] = objUser.strEmail
    //        //        request.dictParamValues["password"] = objUser.strPwd
    //
    //        let asyncRequest = ETechAsyncRequest()
    //        asyncRequest.delegate = self
    //        asyncRequest.sendPostRequest(Constant.API.CHARGING_HISTORY_URL, requestData: request)
    //    }
    
    func getContestantListAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["contest_id"] = objUser.strContestId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_CONTEST_DETAILS_URL, requestData: request)
    }
    
    
    func getContestantDetailsAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        request.dictParamValues["contestant_id"] = objUser.strContestantId
        request.dictParamValues["contest_id"] = objUser.strContestId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_CONTESTANT_DETAILS_URL, requestData: request)
    }
    
    func getMediaGallaryAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        request.dictParamValues["contestant_id"] = objUser.strContestantId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_CONTESTANT_MEDIA_GALLARY_URL, requestData: request)
    }
    
    func loginWithEmailAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
//        request.dictParamValues["email"] = objUser.strEmail
        request.dictParamValues["username"] = objUser.strEmail
        request.dictParamValues["password"] = objUser.strPwd
        request.dictParamValues["auto_login"] = String(objUser.isAutoLogin)
        request.dictParamValues["login_type"] = objUser.strLoginType
//        request.dictParamValues["device_id"] = Util.appDelegate.uniqueDeviceId
        request.dictParamValues["grant_type"] = "password"
        request.dictParamValues["client_id"] = "ranking-star"
        request.dictParamValues["client_secret"] = "b4bca6aa25828cf702d06cbc9656d4e3"
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.LOGIN_URL, requestData: request)
    }
    
    func getDeviceRegisterAPI(resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["client_id"] = "rankingstar"
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            request.dictParamValues["user_id"] = objUserProfile.strUserId
        }
        request.dictParamValues["device_uid"] = UIDevice.current.identifierForVendor!
        request.dictParamValues["device_token"] = Util.appDelegate.token
        request.dictParamValues["device_name"] = "iPhone"
        request.dictParamValues["device_model"] = UIDevice.modelName
        request.dictParamValues["device_version"] = UIDevice.current.systemVersion
        request.dictParamValues["app_name"] = Util.applicationName
//        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            request.dictParamValues["app_version"] = version
//        }
        request.dictParamValues["push_alert"] = "enabled"
        request.dictParamValues["push_sound"] = "enabled"
        request.dictParamValues["push_badge"] = "enabled"
        request.dictParamValues["push_vibrate"] = "enabled"
        #if DEBUG
        request.dictParamValues["environment"] = "Sandbox"
        #else
        request.dictParamValues["environment"] = "Production"
        #endif
        request.dictParamValues["os"] = "ios"
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.DEVICE_REGISTER, requestData: request)
    }
    
    func signUpAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["email"] = objUser.strEmail
        request.dictParamValues["password"] = objUser.strPwd
        request.dictParamValues["mobile"] = objUser.strMobile
        request.dictParamValues["name"] = objUser.strUserName
        request.dictParamValues["nick_name"] = objUser.strUserNikName
        request.dictParamValues["terms_condition"] = objUser.isTermAndCondition
        request.dictParamValues["privacy_policy"] = objUser.isPrivacyPolicy
        request.dictParamValues["newslatter_subscribe"] = objUser.isNewsLatter
        request.dictParamValues["device_id"] = Util.appDelegate.uniqueDeviceId
        request.dictParamValues["otp_for"] = Constant.ResponseParam.OTP_FOR_REGISTER
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.SIGN_UP_URL, requestData: request)
    }
    
    func forgotPwdAPI(email : String, resBlock : @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["email"] = email
        request.dictParamValues["otp_for"] = "forgotpassword"
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.FORGOT_PASSWORD_URL, requestData: request)
    }
    
    func otpVerificationAPI(objOTP : OTP, resBlock : @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["email"] = objOTP.email
        request.dictParamValues["otp"] = objOTP.otp
        request.dictParamValues["otp_for"] = objOTP.otpFor
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.OTP_VERIFICATION_URL, requestData: request)
    }
    
    func createNewPwdAPI(objOTP : OTP, resBlock : @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["password"] = objOTP.password
        request.dictParamValues["user_id"] = objOTP.userID
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.CREATE_NEW_PWD_URL, requestData: request)
    }
    
    func otpResendAPI(objOTP : OTP, resBlock : @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["email"] = objOTP.email
        request.dictParamValues["otp_for"] = objOTP.otpFor
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.OTP_RESEND_URL, requestData: request)
    }
    
    func editProfileAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        //        language:english
        //        user_id:2
        //        user_type:contestant
        //        nick_name:Contestant 2
        //        password:a
        //        mobile:1212121212
        
        request.dictParamValues["user_id"] = objUser.strUserId
        request.dictParamValues["user_type"] = objUser.strUserType
        request.dictParamValues["email"] = objUser.strEmail
        request.dictParamValues["mobile"] = objUser.strMobile
        request.dictParamValues["name"] = objUser.strUserName
        request.dictParamValues["nick_name"] = objUser.strUserNikName
        request.dictParamValues["current_password"] = objUser.strOldPwd
        request.dictParamValues["password"] = objUser.strPwd
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.EDIT_USER_PROFILE_URL, requestData: request)
    }
    
    func deleteAccountAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["user_id"] = objUser.strUserId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.DELETE_USER_ACCOUNT_URL, requestData: request)
    }
    
    func checkAvailableEmailAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["email"] = objUser.strEmail
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.CHECK_EMAIL_EXISTS_URL, requestData: request)
    }
    
    func verifySocialLoginAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["social_id"] = objUser.strUserId
        request.dictParamValues["login_type"] = objUser.strLoginType
        request.dictParamValues["username"] = objUser.strUserId
        request.dictParamValues["password"] = objUser.strUserId
        request.dictParamValues["grant_type"] = "password"
        request.dictParamValues["client_id"] = "ranking-star"
        request.dictParamValues["client_secret"] = "b4bca6aa25828cf702d06cbc9656d4e3"
        //request.dictParamValues["device_id"] = Util.appDelegate.uniqueDeviceId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.VERIFY_SOCIAL_LOGIN, requestData: request)
    }
    
    func socialLoginAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        request.dictParamValues["social_id"] = objUser.strUserId
        request.dictParamValues["name"] = objUser.strUserName
        request.dictParamValues["nick_name"] = objUser.strUserNikName
        request.dictParamValues["email"] = objUser.strEmail
        request.dictParamValues["login_type"] = objUser.strLoginType
        request.dictParamValues["mobile"] = objUser.strMobile
        //request.dictParamValues["device_id"] = Util.appDelegate.uniqueDeviceId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.SOCIAL_LOGIN_URL, requestData: request)
    }
    
    
    func contentListAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_CONTEST_BANNERI_LIST_URL, requestData: request)
    }
    
    func subContentListAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        request.dictParamValues["page"] = objUser.strPage
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_SUB_CONTEST_LIST_URL, requestData: request)
    }
    
    func getSearchListAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        request.dictParamValues["searchTerm"] = objUser.strSearch
        request.dictParamValues["page"] = objUser.strPage
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_SEARCH_LIST_URL, requestData: request)
    }
    func getUserProfileAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["user_id"] = objUser.strUserId
        request.dictParamValues["user_type"] = objUser.strUserType
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_USER_PROFILE_DATA, requestData: request)
    }
    func getNoticeListAPI(resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.NOTICE_LIST, requestData: request)
    }
    func getPushNotificationListAPI(userID : String, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["user_id"] = userID
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.PUSH_NOTIFICATION_LIST, requestData: request)
    }
    func getSettingsAPI(objSettings : Settings, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["user_id"] = objSettings.userId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GET_SETTINGS, requestData: request)
    }
    func setSettingsAPI(objSettings : Settings, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["user_id"] = objSettings.userId
        request.dictParamValues["push_alert"] = objSettings.pushalert
        request.dictParamValues["push_sound"] = objSettings.pushsound
        request.dictParamValues["push_vibrate"] = objSettings.pushvibrate
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.SET_SETTINGS, requestData: request)
    }
    
    func getVotingHistoryListAPI(objVoteHistory : VoteHistory, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        request.dictParamValues["contest_id"] = objVoteHistory.strContestID
        request.dictParamValues["contestant_id"] = objVoteHistory.strContestantID
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.VOTING_HISTORY, requestData: request)
    }
    func getUserDetailByPhoneAPI(phone : String, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["mobile"] = phone
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.USER_DETAIL_BY_PHONE, requestData: request)
    }
    func getGiftAPI(objGift : Gift, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["receiver_id"] = objGift.strReceiverID
        request.dictParamValues["sender_id"] = objGift.strSenderID
        request.dictParamValues["star"] = objGift.strStar
        request.dictParamValues["sender_name"] = objGift.strSenderName
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.GIFT_STAR, requestData: request)
    }
    func getVoTePopUpAPI(objVote : VotePopUp, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["contest_id"] = objVote.strContestID
        request.dictParamValues["contestant_id"] = objVote.strContestantID
        request.dictParamValues["voter_id"] = objVote.strVoterID
        request.dictParamValues["vote"] = objVote.strVote
        request.dictParamValues["voter_name"] = objVote.strVoterName
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.ADD_VOTE, requestData: request)
    }
    func getChargingPurchaseStarAPI(resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithoutLogin()
        request.setDefaultParameter()
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.PURCHASE_STAR_PLAN_LIST, requestData: request)
    }
    
    func doStartTransaction(ForPlan plan:StarPurchasePlan, forUser userId:String, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["user_id"] = userId
        request.dictParamValues["plan_id"] = plan.plan_id
        request.dictParamValues["amount"] =  plan.price
        request.dictParamValues["contest_id"] =  ""
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.IAPP_TRANSACTION_START, requestData: request)
    }
    
    func doEndTransaction(status: TransactionStatus, transactionId: String, paymentTransId: String!, desc: String, otherDetails: [String: String]!, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["payment_status"] = status.rawValue
        request.dictParamValues["transaction_id"] = transactionId
        
        if paymentTransId != nil {
            request.dictParamValues["payment_transaction_id"] = paymentTransId
        }
        else {
            request.dictParamValues["payment_transaction_id"] = ""
        }
        
        request.dictParamValues["description"] = desc
        
        request.dictParamValues["payment_details"] = String()
        
        if otherDetails != nil {
            if let theJSONData = try? JSONSerialization.data(withJSONObject: otherDetails, options: [.prettyPrinted]) {
                if let str = String(data: theJSONData, encoding: .ascii) {
                    request.dictParamValues["payment_details"] = str
                }
            }
        }
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.IAPP_TRANSACTION_END, requestData: request)
    }
    
    
    
    func getAttendenceCheckAPI(userID : String, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["user_id"] = userID
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.ATTENDENCE_CHECK, requestData: request)
    }
    
    func setUserProfileSelfAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["contestant_id"] = objUser.strUserId
        request.dictParamValues["introduction"] = objUser.strMyIntro
        
        request.dictParamValues["youtube_id_1"] = objUser.strYouTubeID1
        request.dictParamValues["youtube_url_1"] = objUser.strYouTubeUrl1
        
        request.dictParamValues["youtube_id_2"] = objUser.strYouTubeID2
        request.dictParamValues["youtube_url_2"] = objUser.strYouTubeUrl2
        
        request.dictParamValues["youtube_id_3"] = objUser.strYouTubeID3
        request.dictParamValues["youtube_url_3"] = objUser.strYouTubeUrl3
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        if(objUser.isUserProfileImageChange == false)
        {
            request.dictParamValues["main_image"] = ""
            asyncRequest.sendPostRequest(Constant.API.EDIT_CONTESTANT_DETAIL_URL, requestData: request)
        }else
        {
            asyncRequest.sendPostRequestWithImage(Constant.API.EDIT_CONTESTANT_DETAIL_URL, withImageParamName: "main_image", image: objUser.userProfileImg, requestData: request)
        }
    }
    
    func imageArrayUploadApi(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        
        request.dictParamValues["contestant_id"] = objUser.strUserId
        request.dictParamValues["media_type"] = Constant.ResponseParam.MEDIA_TYPE_IMAGE
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        
        asyncRequest.sendPostRequestWithImage(Constant.API.ADD_GALLARY_ITEM, withImageParamName: "media_path", image: objUser.userProfileImg, requestData: request)
        
    }
    
    func deleteMediaGalleryItemAPI(objUser:UserProfileModel, resBlock:  @escaping ReqCompletionBlock) {
        
        completionBlock = resBlock
        
        let request = Request()
        request.setDefaultHeaderParamWithLogin()
        request.setDefaultParameter()
        request.dictParamValues["media_id"] = objUser.strGalleryMediaId
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = self
        asyncRequest.sendPostRequest(Constant.API.DELETE_GALLERY_ITEM_URL, requestData: request)
    }
    
}

