//
//  LeadViewModel.swift
//  HafoosCRM
//
//  Created by etech-9 on 26/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

class ChargingStarHistoryViewModel: NSObject {

    private var vcRef : ChargingStarHistoryVC!
    
    var objChargingHistoryModel = ChargingHistoryModel()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : ChargingStarHistoryVC!) {
        super.init()
        vcRef = vc
    }
    
    func getStarHistoryAPI() {
        let requestHelper = RequestHelper()
            
        requestHelper.starHistoryAPI(resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.objChargingHistoryModel = resObj as! ChargingHistoryModel
                
                self.vcRef.onApiResponseSuccess()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    
}
