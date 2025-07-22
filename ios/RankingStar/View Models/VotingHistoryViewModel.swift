//
//  VotingHistoryViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 06/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class VotingHistoryViewModel: NSObject {
    
    private var vcRef : VotingHistoryVC2!
    var arrVoteHistory = [VoteHistory]()
    var strBannerImgUrl:String! = ""
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : VotingHistoryVC2!) {
        super.init()
        vcRef = vc
    }
    
    func getNumberOfRecords() -> Int {
        return arrVoteHistory.count
    }
    
    func getVotingHistoryListAPI(objVoteHistory : VoteHistory) {
        let requestHelper = RequestHelper()
        
        requestHelper.getVotingHistoryListAPI(objVoteHistory: objVoteHistory, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objVotingHistory = resObj as! VoteHistory
                self.strBannerImgUrl = objVotingHistory.strBannerImgUrl
                self.arrVoteHistory = objVotingHistory.arrVoteHistory
                self.vcRef.onSuccessApiResponce()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
}
