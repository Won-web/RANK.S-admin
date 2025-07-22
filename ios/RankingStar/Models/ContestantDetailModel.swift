//
//  ContestantDetailModel.swift
//  RankingStar
//
//  Created by Jinesh on 06/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class ContestantDetailModel: NSObject {
    var strId:String!
    var strName:String!
    var strDetail:String!
    var strVoteCoin:Int!
    var strUserProfileImgUrl:String!
    var strThumbImgUrl:String!
    var strRank:String!
    var strPreviousRank:String!
   // var strTotalVote:String!
    var strContestId:String!
    var objContestDetail:ContestDetail!
    var arrContestantDetailModel = [ContestantDetailModel]()
    var strContestCategoryId:String!
//    var arrCategorys:[String] = [String]()
    var arrMyFilterModel:[MyFilterModel] = [MyFilterModel]()
    
    static func dictToUserObjectConvertionContestantList(dictData : NSDictionary) -> ContestantDetailModel {
        
        let objContestantDetailModel = ContestantDetailModel()
        objContestantDetailModel.objContestDetail = ContestDetail()
        objContestantDetailModel.objContestDetail = ContestDetail.dictToUserObjectConvertionSubContest2(dictData: dictData)
        
        let arrDataCategory = dictData["categoryItems"] as! NSArray
//        objContestantDetailModel.arrCategorys.removeAll()
        objContestantDetailModel.arrMyFilterModel.removeAll()
        
        for objCategory in arrDataCategory
        {
            let objContestDict = objCategory as! NSDictionary
            let objMyFilterModel = MyFilterModel()
            if let objRefData = objContestDict["contest_category_id"] as? String {
                objMyFilterModel.strCategoryId = objRefData
            }
            if let objRefData = objContestDict["contest_id"] as? String {
                objMyFilterModel.strContestId = objRefData
            }
            if let objRefData = objContestDict["category_name"] as? String {
                objMyFilterModel.strCategoryName = objRefData
            }
            if let objRefData = objContestDict["status"] as? String {
                if(objRefData == Constant.ResponseParam.FILTER_CATEGORY_ACTIVE)
                {
                    objMyFilterModel.isStatusActive = true
                }else
                {
                    objMyFilterModel.isStatusActive = false
                }
            }else
            {
                objMyFilterModel.isStatusActive = false
            }
            objMyFilterModel.isSelected = false
            objContestantDetailModel.arrMyFilterModel.append(objMyFilterModel)
        }
        
        let arrData = dictData["contestant_details"] as! NSArray
        objContestantDetailModel.arrContestantDetailModel.removeAll()
        for objContest in arrData
        {
            let objRef = ContestantDetailModel()
            let objContestDict = objContest as! NSDictionary
            
            // let objContestDict = objContest as! NSDictionary
            if let objRefData = objContestDict["contestant_id"] as? String {
                objRef.strId = String(objRefData)
            }
            if let objRefData = objContestDict["name"] as? String {
                objRef.strName = String(objRefData)
            }
            if let objRefData = objContestDict["total_vote"] as? String {
                objRef.strVoteCoin = Int(objRefData) ?? 0
            }
            
            if let objRefData = objContestDict["main_image"] as? String {
                objRef.strUserProfileImgUrl = String(objRefData)
            }
            
            if let objRefData = objContestDict["thumb_image"] as? String {
                objRef.strThumbImgUrl = String(objRefData)
            }
            
            if let objRefData = objContestDict["current_ranking"] as? String {
                objRef.strRank = String(objRefData)
            }
            
            if let objRefData = objContestDict["previous_ranking"] as? String {
                objRef.strPreviousRank = String(objRefData)
            }
            if let objRefData = objContestDict["contest_id"] as? String {
                objRef.strContestId = String(objRefData)
            }
            
            if let objRefData = objContestDict["contest_category_id"] as? String {
                objRef.strContestCategoryId = String(objRefData)
            }
            
            objContestantDetailModel.arrContestantDetailModel.append(objRef)
        }
        return objContestantDetailModel
    }
}
