//
//  PushNotificationListViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class PushNotificationListViewModel: NSObject {
    
    private var vcRef : PushNotificationListVC!
    var arrPushNotificationList = [PushNotification]()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : PushNotificationListVC!) {
        super.init()
        vcRef = vc
    }
    
    func getNumberOfRecords() -> Int {
        return arrPushNotificationList.count
    }
    
    func getPushNotificationListAPI(userID : String) {
        let requestHelper = RequestHelper()
        
        requestHelper.getPushNotificationListAPI(userID: userID, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objPushNotification = resObj as! PushNotification
                self.arrPushNotificationList = objPushNotification.arrPushNotification
                
                self.vcRef.onSuccessApiResponce()
            }
            else{
                self.vcRef.onFailApiResponce(message: resMessage)
            }
        })
    }
}
