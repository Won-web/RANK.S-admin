//
//  CreateNewPwdViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 01/03/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class CreateNewPwdViewModel: NSObject {
    
    private var vcRef : CreateNewPwdVC!
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : CreateNewPwdVC!) {
        super.init()
        vcRef = vc
    }
    
    func getCreateNewPwdAPI(objOTP : OTP) {
        
        let requestHelper = RequestHelper()
        
        requestHelper.createNewPwdAPI(objOTP: objOTP, resBlock: { (_ resObj : NSObject, _ resCode : Int, _ resMessage : String) -> Void in
            
            self.vcRef.onCreatePwdApiComplete()

            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.onCreatePwdApiSuccess(message: resMessage)

            }else {
                self.vcRef.showMessage(message: resMessage)
            }
            
        })
    }
}
