//
//  SignUpViewModel.swift
//  RankingStar
//
//  Created by Jinesh on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class SignUpViewModel: NSObject {
    
    private var vcRef : SignUpVC!
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : SignUpVC!) {
        super.init()
        vcRef = vc
    }
    
    func signUpAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.signUpAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objOTP = resObj as! OTP
                self.vcRef.loginSuccessWithSignUp(objOTP: objOTP, message: resMessage)
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func socialLoginAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        requestHelper.socialLoginAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.vcRef.SignUpSuccessWithSocialAccount()
                
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func verifySocialLoginAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        requestHelper.verifySocialLoginAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.onSuccessVerifyLoginSocialAccount()
            }
            else{
                self.vcRef.onFailVerifyUserSocialLogin(message: resMessage)
            }
        })
    }
    
    func checkAvailableEmailAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.checkAvailableEmailAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.vcRef.availableEmailSuccessApi(isSuccess: true, message: resMessage)
            }
            else{
                self.vcRef.availableEmailSuccessApi(isSuccess: false, message: resMessage)
            }
        })
    }
    
    func getDeviceRegisterAPI() {
        let requestHelper = RequestHelper()
        
        requestHelper.getDeviceRegisterAPI(resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.vcRef.onDeviceRegisterSuccessApi()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
}
