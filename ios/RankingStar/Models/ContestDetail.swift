//
//  ContestDetail.swift
//  RankingStar
//
//  Created by Jinesh on 31/01/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class ContestDetail :NSObject
{
    var strId:String!
    var strName:String!
    var strDetail:String!
    var strVoteStartDate:String!
    var strVoteEndDate:String!
    var strDate:String!
    var strStatus:String!
    var strStatusLabel:String!
    var strImageUrl:String!
    var strSubImageUrl:String!
    
    var strHomePage:String!
    var strPartner:String!
    var strCost:String!
    var strFeesPercent:String!
    var strMemo:String!
    var strCreatedDate:String!
    var strUpdatedDate:String!
    var hasMoreRecored:Bool!
    var strTotalVote:String!
    var strWebViewUrl:String!
    
    var arrContestDetail = [ContestDetail]()
    
    var strAddress:String!
    
    static func dictToUserObjectConvertionContest(dictData : NSDictionary) -> ContestDetail {
        
        let arrData = dictData["banner_list"] as! NSArray
        let objContestDetail = ContestDetail()
        objContestDetail.arrContestDetail.removeAll()
        for objContest in arrData
        {
            let objRef = ContestDetail()
            let objContestDict = objContest as! NSDictionary
            if let objRefData = objContestDict["contest_id"] as? String {
                objRef.strId = String(objRefData)
            }
            if let objRefData = objContestDict["contest_name"] as? String {
                objRef.strName = String(objRefData)
            }
            if let objRefData = objContestDict["main_banner"] as? String {
                objRef.strImageUrl = String(objRefData)
            }
            
            objContestDetail.arrContestDetail.append(objRef)
        }
        
        return objContestDetail
    }
    
    static func dictToUserObjectConvertionSubContest(dictData : NSDictionary) -> ContestDetail {
        
        let arrData = dictData["contest_list"] as! NSArray
        let objContestDetail = ContestDetail()
        objContestDetail.arrContestDetail.removeAll()
        for objContest in arrData
        {
            
            let objRef = ContestDetail()
            let objContestDict = objContest as! NSDictionary
            if let objRefData = objContestDict["contest_id"] as? String {
                objRef.strId = String(objRefData)
            }
            if let objRefData = objContestDict["contest_name"] as? String {
                objRef.strName = String(objRefData)
            }
            if let objRefData = objContestDict["description"] as? String {
                objRef.strDetail = String(objRefData)
            }
            if let objRefData = objContestDict["address"] as? String {
                objRef.strAddress = String(objRefData)
            }
            if let objRefData = objContestDict["vote_open_date"] as? String {
                objRef.strVoteStartDate = String(objRefData)
            }
            if let objRefData = objContestDict["vote_close_date"] as? String {
                objRef.strVoteEndDate = String(objRefData)
            }
            if let objRefData = objContestDict["status"] as? String {
                objRef.strStatus = String(objRefData)
            }
            if let objRefData = objContestDict["status_label"] as? String {
                objRef.strStatusLabel = String(objRefData)
            }
            if let objRefData = objContestDict["main_banner"] as? String {
                objRef.strImageUrl = String(objRefData)
            }
            if let objRefData = objContestDict["sub_banner"] as? String {
                objRef.strSubImageUrl = String(objRefData)
            }
            if let objRefData = objContestDict["home_page"] as? String {
                objRef.strHomePage = String(objRefData)
            }
            if let objRefData = objContestDict["partner"] as? String {
                objRef.strPartner = String(objRefData)
            }
            if let objRefData = objContestDict["status"] as? String {
                objRef.strStatus = String(objRefData)
            }
            if let objRefData = objContestDict["cost"] as? String {
                objRef.strCost = String(objRefData)
            }
            if let objRefData = objContestDict["fees_percent"] as? String {
                objRef.strFeesPercent = String(objRefData)
            }
            if let objRefData = objContestDict["memo"] as? String {
                objRef.strMemo = String(objRefData)
            }
            if let objRefData = objContestDict["created_date"] as? String {
                objRef.strCreatedDate = String(objRefData)
            }
            if let objRefData = objContestDict["updated_date"] as? String {
                objRef.strUpdatedDate = String(objRefData)
            }
            if let objRefData = objContestDict["total_vote"] as? String {
                objRef.strTotalVote = String(objRefData)
            }
//            if let objRefData = objContestDict["web_view_url"] as? String {
//                objRef.strWebViewUrl = String(objRefData)
//            }
            if let objRefData = objContestDict["web_page_url"] as? String {
                objRef.strWebViewUrl = String(objRefData)
            }else {
                objRef.strWebViewUrl = ""
            }
//            if let objRefData = objContestDict["home_page_url"] as? String {
//                objRef.strWebViewUrl = String(objRefData)
//            }
            
            objContestDetail.arrContestDetail.append(objRef)
        }
        
        return objContestDetail
    }
    
    static func dictToUserObjectConvertionSubContest2(dictData : NSDictionary) -> ContestDetail {
        
        let arrData = dictData["contest_details"] as! NSArray
        let objRef = ContestDetail()
        
        for objContest in arrData
        {
            
            let objContestDict = objContest as! NSDictionary
            if let objRefData = objContestDict["contest_id"] as? String {
                objRef.strId = String(objRefData)
            }
            if let objRefData = objContestDict["contest_name"] as? String {
                objRef.strName = String(objRefData)
            }
            if let objRefData = objContestDict["description"] as? String {
                objRef.strDetail = String(objRefData)
            }
            if let objRefData = objContestDict["address"] as? String {
                objRef.strAddress = String(objRefData)
            }
            if let objRefData = objContestDict["vote_open_date"] as? String {
                objRef.strVoteStartDate = String(objRefData)
            }
            if let objRefData = objContestDict["vote_close_date"] as? String {
                objRef.strVoteEndDate = String(objRefData)
            }
            if let objRefData = objContestDict["status"] as? String {
                objRef.strStatus = String(objRefData)
            }
            if let objRefData = objContestDict["main_banner"] as? String {
                objRef.strImageUrl = String(objRefData)
            }
            if let objRefData = objContestDict["sub_banner"] as? String {
                objRef.strSubImageUrl = String(objRefData)
            }
            if let objRefData = objContestDict["home_page"] as? String {
                objRef.strHomePage = String(objRefData)
            }
            if let objRefData = objContestDict["partner"] as? String {
                objRef.strPartner = String(objRefData)
            }
            if let objRefData = objContestDict["cost"] as? String {
                objRef.strCost = String(objRefData)
            }
            if let objRefData = objContestDict["fees_percent"] as? String {
                objRef.strFeesPercent = String(objRefData)
            }
            if let objRefData = objContestDict["memo"] as? String {
                objRef.strMemo = String(objRefData)
            }
            if let objRefData = objContestDict["created_date"] as? String {
                objRef.strCreatedDate = String(objRefData)
            }
            if let objRefData = objContestDict["updated_date"] as? String {
                objRef.strUpdatedDate = String(objRefData)
            }
            if let objRefData = objContestDict["total_vote"] as? String {
                objRef.strTotalVote = String(objRefData)
            }
//            if let objRefData = objContestDict["web_view_url"] as? String {
//                objRef.strWebViewUrl = String(objRefData)
//            }
//            if let objRefData = objContestDict["home_page_url"] as? String {
//                objRef.strWebViewUrl = String(objRefData)
//            }
            if let objRefData = objContestDict["web_page_url"] as? String {
                objRef.strWebViewUrl = String(objRefData)
            }else {
                objRef.strWebViewUrl = ""
            }
        }
        
        return objRef
    }
}
