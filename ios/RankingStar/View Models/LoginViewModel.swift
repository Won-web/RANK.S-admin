//
//  LoginViewModel.swift
//  RankingStar
//
//  Created by Jinesh on 03/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
    
    private var vcRef : LoginVC!
    var objUserSocialLoginDetails = UserProfileModel()
 
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : LoginVC!) {
        super.init()
        vcRef = vc
    }
    
    func loginWithEmailAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.loginWithEmailAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.vcRef.loginSuccessWithAuth()
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
            var isVerified = false
            
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.objUserSocialLoginDetails = resObj as! UserProfileModel
                isVerified = true
                
                if self.objUserSocialLoginDetails.isMobValid == 0 {
                    self.vcRef.loginSuccessWithSocialAccount(isVerified: isVerified, isMobValid: false)
                }else {
                    self.vcRef.loginSuccessWithSocialAccount(isVerified: isVerified, isMobValid: true)
                }
            }else if resCode == Constant.ResponseStatus.SOCIAL_SUCCESS {
                isVerified = false
                self.vcRef.loginSuccessWithSocialAccount(isVerified: isVerified, isMobValid: false)
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
                
                self.objUserSocialLoginDetails = resObj as! UserProfileModel
                if self.objUserSocialLoginDetails.isMobValid == 0 {
                    self.vcRef.SignUpSuccessWithSocialAccount(isMobValid: false)
                }else {
                    self.vcRef.SignUpSuccessWithSocialAccount(isMobValid: true)
                }
            }
            else{
                self.vcRef.showMessage(message: resMessage)
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
