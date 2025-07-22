//
//  OTPVerificationViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 01/03/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class OTPVerificationViewModel: NSObject {
    
    private var vcRef : OTPVerificationVC!
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : OTPVerificationVC!) {
        super.init()
        vcRef = vc
    }
    
    func getOTPVerificationAPI(objOTP : OTP) {
        
        let requestHelper = RequestHelper()
        
        requestHelper.otpVerificationAPI(objOTP: objOTP, resBlock: { (_ resObj : NSObject, _ resCode : Int, _ resMessage : String) -> Void in
            
            self.vcRef.onOTPVerificationApiComplete()

            if resCode == Constant.ResponseStatus.SUCCESS {

                self.vcRef.onOTPVerificationApiSuccess()

            }else {
                self.vcRef.showMessage(message: resMessage)
            }
            
        })
    }
    
    func getOTPResendAPI(objOTP : OTP) {
        
        let requestHelper = RequestHelper()
        
        requestHelper.otpResendAPI(objOTP: objOTP, resBlock: { (_ resObj : NSObject, _ resCode : Int, _ resMessage : String) -> Void in
            
            self.vcRef.onOTPVerificationApiComplete()

            if resCode == Constant.ResponseStatus.SUCCESS {

                let objOTP = resObj as! OTP
                
                self.vcRef.onOTPResendVerificationSuccess(objOTP: objOTP)
                self.vcRef.showMessage(message: resMessage)

            }else {
                self.vcRef.showMessage(message: resMessage)
            }
            
        })
    }
}
