//
//  VoteHistory.swift
//  RankingStar
//
//  Created by Hitarthi on 06/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class VoteHistory: NSObject {
    
    var voter_id : String!
    var vote : String!
    var user_type : String!
    var name : String!
    var nick_name : String!
    var main_image : String!
    var ranking : String!
    var strBannerImgUrl:String!
    var arrVoteHistory = [VoteHistory]()
    
    var strContestID : String!
    var strContestantID : String!
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> VoteHistory {
        let objVoteHistory = VoteHistory()
        //var arrVotingHistory = [VoteHistory]()
        
        if let objDictData = dictData["banner_list"] as? [String:Any] {
            if let data = objDictData["sub_banner"] as? String {
                objVoteHistory.strBannerImgUrl = data
                
            }
        }
        if let arrData = dictData["voting_history"] as? [[String:Any]] {
            objVoteHistory.arrVoteHistory.removeAll()
            arrData.forEach { (voteDic) in
                
                let objVoteHistory1 = VoteHistory()
                
                if let data = voteDic["voter_id"] as? String {
                    objVoteHistory1.voter_id = data
                }
                if let data = voteDic["vote"] as? String {
                    objVoteHistory1.vote = data
                }
                if let data = voteDic["user_type"] as? String {
                    objVoteHistory1.user_type = data
                }
                if let data = voteDic["name"] as? String {
                    objVoteHistory1.name = data
                }
                if let data = voteDic["nick_name"] as? String {
                    objVoteHistory1.nick_name = data
                }
                if let data = voteDic["main_image"] as? String {
                    objVoteHistory1.main_image = data
                }
                if let data = voteDic["ranking"] as? String {
                    objVoteHistory1.ranking = data
                }
                
                objVoteHistory.arrVoteHistory.append(objVoteHistory1)
            }
        }
        return objVoteHistory
    }
}
