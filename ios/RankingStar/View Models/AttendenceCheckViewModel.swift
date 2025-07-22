//
//  AttendenceCheckViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 19/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class AttendenceCheckViewModel: NSObject {
    
    private var vcRef : AttendanceCheckVC!
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : AttendanceCheckVC!) {
        super.init()
        vcRef = vc
    }
    
  /*  func getAttendenceCheckAPI(userId : String) {
        let requestHelper = RequestHelper()
        
        requestHelper.getAttendenceCheckAPI(userID: userId, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.objAttendenceCheck = resObj as! AttendenceCheck
                
                self.vcRef.onSuccessApiResponce(message: resMessage)
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    } */

}
