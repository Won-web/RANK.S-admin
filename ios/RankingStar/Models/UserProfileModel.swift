//
//  ChargingHistoryModel.swift
//  RankingStar
//
//  Created by Jinesh on 17/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit

class UserProfileModel: NSObject {
    
    var strUserId:String!
    var strUserSocialId:String!
    var strPlanId:String!
    var strAmount:String!
    var strUserName:String!
    var strDetail:String!
    var strImageUrl:String!
    var strThumbImageUrl:String!
    var strEmail:String!
    var strPhoneNumber:String!
    var strContestId:String!
    var strContestName:String!
    var strMobile:String!
    var strUserType:String!
    var strUserNikName:String!
    var strRemainingStar:String!
    var strAutoLogin:String!
    var isMobValid:Int!
    var strAge:String!
    var strHeight:String!
    var strWeight:String!
    var strContestStatus:String!
    var strMyIntro:String!
    var strStatus:String!
    var strCreateDate:String!
    var strUpdatedDate:String!
    var strTotalVote:String!
    var strCurrentRanking:String!
    var strPreviousRanking:String!
    var strContestantId:String!
    
    var strYouTubeID1:String!
    var strYouTubeID2:String!
    var strYouTubeID3:String!
    var strYouTubeUrl1:String!
    var strYouTubeUrl2:String!
    var strYouTubeUrl3:String!
    
    var arrUserProfileModel = [UserProfileModel]()
    
    // parameter
    var strPage:Int!
    var strSearch:String!
    var hasMoreRecored:Bool!
    var strOldPwd:String!
    var strPwd:String!
    var isAutoLogin:Bool!
    var strLoginType:String!
    var isTermAndCondition:String!
    var isPrivacyPolicy:String!
    var isNewsLatter:String!
    var userProfileImg:UIImage!
    var isUserProfileImageChange:Bool!
    var strGalleryMediaId:String!
    var strTranjactionId:String!
    var strTranjactionStatus:String!
    
    
    var objUserHobbiesModel1:[UserHobbiesModel] = []
    var objUserHobbiesModel2:[UserHobbiesModel] = []
    
    static func dictToUserObjectConvertionSearch(dictData : NSDictionary) -> UserProfileModel {
        
        let arrData = dictData["contestant_list"] as! NSArray
        let objUserProfileModel = UserProfileModel()
        objUserProfileModel.arrUserProfileModel.removeAll()
        for objContest in arrData
        {
            let objRef = UserProfileModel()
            
            let objContestDict = objContest as! NSDictionary
            if let objRefData = objContestDict["contestant_id"] as? String {
                objRef.strUserId = String(objRefData)
            }
            if let objRefData = objContestDict["name"] as? String {
                objRef.strUserName = String(objRefData)
            }
            if let objRefData = objContestDict["contest_id"] as? String {
                objRef.strContestId = String(objRefData)
            }
            if let objRefData = objContestDict["contest_name"] as? String {
                objRef.strContestName = String(objRefData)
            }
            if let objRefData = objContestDict["main_image"] as? String {
                objRef.strImageUrl = String(objRefData)
            }
            
            objUserProfileModel.arrUserProfileModel.append(objRef)
        }
        
        return objUserProfileModel
    }
    
    static func userModelToDictConvertion (objRef : UserProfileModel) -> [String:Any] {
        
        var dictData = [String: Any]()
        dictData["user_id"] = objRef.strUserId
        dictData["email"] = objRef.strEmail
        dictData["mobile"] = objRef.strMobile
        dictData["user_type"] = objRef.strUserType
        dictData["is_autologin"] = objRef.strAutoLogin
        dictData["login_type"] = objRef.strLoginType
        dictData["name"] = objRef.strUserName
        dictData["nick_name"] = objRef.strUserNikName
        dictData["main_image"] = objRef.strImageUrl
        dictData["remaining_star"] = objRef.strRemainingStar
        dictData["is_mobile_valid"] = objRef.isMobValid
        return dictData
    }
    
    static func dictToUserObjUserDefaultUserProfile(dictData : [String:Any]) -> UserProfileModel {
        
        let objRef = UserProfileModel()
        if let objRefData = dictData["user_id"] as? String {
            objRef.strUserId = String(objRefData)
        }else
        {
            objRef.strUserId = ""
        }
        if let objRefData = dictData["email"] as? String {
            objRef.strEmail = String(objRefData)
        }else
        {
            objRef.strEmail = ""
        }
        if let objRefData = dictData["mobile"] as? String {
            objRef.strMobile = String(objRefData)
        }else
        {
            objRef.strMobile = ""
        }
        if let objRefData = dictData["user_type"] as? String {
            objRef.strUserType = String(objRefData)
        }else
        {
            objRef.strUserType = ""
        }
        if let objRefData = dictData["is_autologin"] as? String {
            objRef.strAutoLogin = String(objRefData)
        }else
        {
            objRef.strAutoLogin = ""
        }
        if let objRefData = dictData["login_type"] as? String {
            objRef.strLoginType = String(objRefData)
        }else
        {
            objRef.strLoginType = ""
        }
        if let objRefData = dictData["name"] as? String {
            objRef.strUserName = String(objRefData)
        }else
        {
            objRef.strUserName = ""
        }
        if let objRefData = dictData["nick_name"] as? String {
            objRef.strUserNikName = String(objRefData)
        }else
        {
            objRef.strUserNikName = ""
        }
        if let objRefData = dictData["main_image"] as? String {
            objRef.strImageUrl = String(objRefData)
        }else
        {
            objRef.strImageUrl = ""
        }
        if let objRefData = dictData["remaining_star"] as? String {
            objRef.strRemainingStar = String(objRefData)
        }else
        {
            objRef.strRemainingStar = "0"
        }
        return objRef
    }
    
    static func dictToUserObjectConvertionLogin(dictData : NSDictionary) -> UserProfileModel {
        
        let objDataDic = dictData["profile_details"] as! NSDictionary
        //        let objUserProfileModel = UserProfileModel()
        //        objUserProfileModel.arrUserProfileModel.removeAll()
        
        let objRef = UserProfileModel()
        
        // let objContestDict = objContest as! NSDictionary
        
        if let objRefData = objDataDic["social_id"] as? String {
            objRef.strUserSocialId = String(objRefData)
        }
        
        if let objRefData = objDataDic["user_id"] as? String {
            objRef.strUserId = String(objRefData)
        }
        if let objRefData = objDataDic["email"] as? String {
            objRef.strEmail = String(objRefData)
        }
        if let objRefData = objDataDic["mobile"] as? String {
            objRef.strMobile = String(objRefData)
        }
        
        if let objRefData = objDataDic["user_type"] as? String {
            objRef.strUserType = String(objRefData)
        }
        if let objRefData = objDataDic["is_autologin"] as? String {
            objRef.strAutoLogin = String(objRefData)
        }
        
        if let objRefData = objDataDic["is_mobile_valid"] as? Int {
            objRef.isMobValid = objRefData
        }
        
        if let objRefData = objDataDic["login_type"] as? String {
            objRef.strLoginType = String(objRefData)
        }
        if let objRefData = objDataDic["name"] as? String {
            objRef.strUserName = String(objRefData)
        }
        if let objRefData = objDataDic["nick_name"] as? String {
            objRef.strUserNikName = String(objRefData)
        }
        if let objRefData = objDataDic["main_image"] as? String {
            objRef.strImageUrl = String(objRefData)
        }
        if let objRefData = objDataDic["remaining_star"] as? String {
            objRef.strRemainingStar = String(objRefData)
        }
        
        let dictData:[String: Any] = userModelToDictConvertion(objRef: objRef)
        Util.setUserProfileDict(strValue: dictData)
        //        let dictData1:[String: Any]? = Util.getUserProfileDict()
        //        if(dictData1 != nil)
        //        {
        //           let objUserProfile = dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
        //        }
        
        
        return objRef
    }
    
    static func dictToUserObjectConvertionContestantProfileDetails(dictData : NSDictionary) -> UserProfileModel {
        
        let arrData = dictData["contestant_details"] as! NSArray
        let objRef = UserProfileModel()
        
        for objContest in arrData
        {
            let objContestDict = objContest as! NSDictionary
            
            // let objContestDict = objContest as! NSDictionary
            if let objRefData = objContestDict["contestant_id"] as? String {
                objRef.strContestantId = String(objRefData)
            }
            if let objRefData = objContestDict["user_id"] as? String {
                objRef.strUserId = String(objRefData)
            }
            if let objRefData = objContestDict["name"] as? String {
                objRef.strUserName = String(objRefData)
            }
            
            if let objRefData = objContestDict["nick_name"] as? String {
                objRef.strUserNikName = String(objRefData)
            }
            if let objRefData = objContestDict["main_image"] as? String {
                objRef.strImageUrl = String(objRefData)
            }
            if let objRefData = objContestDict["thumb_image"] as? String {
                objRef.strThumbImageUrl = String(objRefData)
            }
            
            if let objRefData = objContestDict["age"] as? String {
                objRef.strAge = String(objRefData)
            }
            if let objRefData = objContestDict["height"] as? String {
                objRef.strHeight = String(objRefData)
            }
            if let objRefData = objContestDict["contest_status"] as? String {
                objRef.strContestStatus = String(objRefData)
            }
            if let objRefData = objContestDict["weight"] as? String {
                objRef.strWeight = String(objRefData)
            }
//            if let refDataDict = objContestDict["profile_2"] as? NSDictionary {
//                objRef.objUserHobbiesModel2.removeAll()
//                for (key, value) in refDataDict {
//                    let objUserHobbiesModel = UserHobbiesModel()
//                    objUserHobbiesModel.strHobbiesName = key as! String
//                    objUserHobbiesModel.strHobbiesDetail = value as! String
//                    objRef.objUserHobbiesModel2.append(objUserHobbiesModel)
//                }
//            }
            
            if let refDataDict = objContestDict["profile_formatted"] as? [[String:Any]] {
                objRef.objUserHobbiesModel2.removeAll()
                
                refDataDict.forEach { objProfileFormat in
                    
                    for (key, value) in objProfileFormat {
                        
                        let objUserHobbiesModel = UserHobbiesModel()
                        objUserHobbiesModel.strHobbiesName = key as! String
                        objUserHobbiesModel.strHobbiesDetail = value as! String
                        objRef.objUserHobbiesModel2.append(objUserHobbiesModel)
                    }
                }
            }
            
            if let objRefData = objContestDict["introduction"] as? String {
                objRef.strMyIntro = String(objRefData)
            }else
            {
                objRef.strMyIntro = ""
            }
            if let objRefData = objContestDict["status"] as? String {
                objRef.strStatus = String(objRefData)
            }
            if let objRefData = objContestDict["created_date"] as? String {
                objRef.strCreateDate = String(objRefData)
            }
            if let objRefData = objContestDict["updated_date"] as? String {
                objRef.strUpdatedDate = String(objRefData)
            }
            if let objRefData = objContestDict["total_vote"] as? String {
                objRef.strTotalVote = String(objRefData)
            }
            if let objRefData = objContestDict["current_ranking"] as? String {
                objRef.strCurrentRanking = String(objRefData)
            }
            if let objRefData = objContestDict["previous_ranking"] as? String {
                objRef.strPreviousRanking = String(objRefData)
            }
            if let objRefData = objContestDict["contest_id"] as? String {
                objRef.strContestId = String(objRefData)
            }
            if let objRefData = objContestDict["contest_name"] as? String {
                objRef.strContestName = String(objRefData)
            }
        }
        return objRef
    }
    
}


