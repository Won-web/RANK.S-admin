//
//  VotePopUp.swift
//  RankingStar
//
//  Created by Hitarthi on 10/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class VotePopUp: NSObject {
    
    var strContestID : String!
    var strContestantID : String!
    var strVoterID : String!
    var strVote : String!
    var strVoterName : String!
    
    var remainingStar : String!
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> VotePopUp {
            
        let objVotePopUp = VotePopUp()
        
        if let starDetails = dictData["star_details"] as? [String:Any] {
                
            if let data = starDetails["remaining_star"] as? String {
                
                objVotePopUp.remainingStar = data
            }
        }
        
        return objVotePopUp
    }
    
    
}
