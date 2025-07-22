//
//  ForgotPasswordViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 28/02/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class ForgotPasswordViewModel: NSObject {

    private var vcRef : ForgotPasswordVC!
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : ForgotPasswordVC!) {
        super.init()
        vcRef = vc
    }
    
    func getForgotPwdAPI(email : String) {
        
        let requestHelper = RequestHelper()
        
        requestHelper.forgotPwdAPI(email: email, resBlock: { (_ resObj : NSObject, _ resCode : Int, _ resMessage : String) -> Void in
            
            self.vcRef.onForgotPwdApiComplete()
            
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objOTP = resObj as! OTP
                self.vcRef.onForgotPwdApiSuccess(objOTP: objOTP, message: resMessage)
                
            }else {
                self.vcRef.showMessage(message: resMessage)
            }
            
        })
    }
}
