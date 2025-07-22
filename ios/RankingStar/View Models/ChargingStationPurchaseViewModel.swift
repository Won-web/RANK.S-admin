//
//  ChargingStationPurchaseViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 15/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class ChargingStationPurchaseViewModel: NSObject {
    
    private var vcRef : WebViewChargingStationPaidVC!
    var arrStarPurchasePlan = [StarPurchasePlan]()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : WebViewChargingStationPaidVC!) {
        super.init()
        vcRef = vc
    }
    
    func getNumberOfRecords() -> Int {
        return arrStarPurchasePlan.count
    }
    
    func getChargingStarPurchaseAPI() {
        let requestHelper = RequestHelper()
        
        requestHelper.getChargingPurchaseStarAPI(resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objStarPurchasePlan = resObj as! StarPurchasePlan
                self.arrStarPurchasePlan = objStarPurchasePlan.arrPlanList
                
                self.vcRef.onSuccessApiResponce()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func createTransation(ForPlan plan:StarPurchasePlan, index: Int) {
        let requestHelper = RequestHelper()
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            
            requestHelper.doStartTransaction(ForPlan: plan, forUser: objUserProfile.strUserId, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

                self.vcRef.onApiSuccessHideFullProgress()
                if resCode == Constant.ResponseStatus.SUCCESS {
                    let transationId = resObj as! String
                    self.vcRef.onCreateTransationComplete(status: true, message: String(), transactionId: transationId, arrIdx: index)
                }
                else{
                    self.vcRef.onCreateTransationComplete(status: false, message: resMessage, transactionId: String(), arrIdx: index)
                }
            })
        }
        else {
            
        }
    }
    
    func completeTransaction(status: TransactionStatus, transactionId: String, paymentTransId: String!, desc: String, otherDetails: [String: String]!, index:Int) {
        let requestHelper = RequestHelper()
            
        requestHelper.doEndTransaction(status: status, transactionId: transactionId, paymentTransId: paymentTransId, desc: desc, otherDetails: otherDetails, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

            self.vcRef.onApiSuccessHideFullProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {

                let objStar = resObj as! VotePopUp
                self.vcRef.onCompleteTransactionComplete(status: true, remainingStar: objStar.remainingStar, message: String(), arrIdx: index)
            }
            else{
                self.vcRef.onCompleteTransactionComplete(status: false, remainingStar: String(), message: resMessage, arrIdx: index)
            }
        })
    }
}
