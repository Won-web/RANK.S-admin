//
//  VotePopUpViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 10/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class VotePopUpViewModel: NSObject {
    
    private var vcRef : VotePopupVC!
    var objVotePopUp = VotePopUp()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : VotePopupVC!) {
        super.init()
        vcRef = vc
    }
    
//    func getNumberOfRecords() -> Int {
//        return arrNoticeList.count
//    }
    
    func getVotePopUpAPI(objVote: VotePopUp) {
        let requestHelper = RequestHelper()
        
        requestHelper.getVoTePopUpAPI(objVote: objVote, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.objVotePopUp = resObj as! VotePopUp
                
                self.vcRef.onSuccessApiResponce(message: resMessage)
            }
            else{
                
                
                if resObj != nil {
                    self.objVotePopUp = resObj as! VotePopUp
                    self.vcRef.onFailVoteApi(message: resMessage)
                    //                    self.vcRef.showMessageGift(message: resMessage)
                }else {
                    self.vcRef.showMessage(message: resMessage)
                }
            }
        })
    }
}
