//
//  EditUserProfileViewModel.swift
//  RankingStar
//
//  Created by Jinesh on 06/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class EditUserProfileViewModel: NSObject {
    private var vcRef : EditUserProfileVC!
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : EditUserProfileVC!) {
        super.init()
        vcRef = vc
    }
    
    func editProfileAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.editProfileAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.vcRef.editProfileSuccessApi(message: resMessage)
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func deleteAccountAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.deleteAccountAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.vcRef.deleteAccountSuccessApi(message: resMessage)
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
}
