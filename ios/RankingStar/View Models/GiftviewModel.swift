//
//  GiftviewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 07/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class GiftviewModel: NSObject {
    
    private var vcRef : GiftVC2!
    var objUserDetail = UserDetailByPhone()
    var objGift = Gift()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : GiftVC2!) {
        super.init()
        vcRef = vc
    }
    
    func getDetailsByPhoneAPI() {
        let requestHelper = RequestHelper()

        requestHelper.getUserDetailByPhoneAPI(phone: vcRef!.txtFPhoneNumber.text!, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.objUserDetail = resObj as! UserDetailByPhone
                self.vcRef.onSuccessApiResponce()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func getGiftAPI(objGift : Gift) {
        let requestHelper = RequestHelper()

        requestHelper.getGiftAPI(objGift: objGift, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.objGift = resObj as! Gift
                
                self.vcRef.onSuccessGiftApi()
            }
            else{
                self.vcRef.onFailGiftApi(message: resMessage)
                
//                if resObj != nil {
////                    self.objGift = resObj as! Gift
//                    
////                    self.vcRef.showMessageGift(message: resMessage)
//                }else {
//                    self.vcRef.showMessageGift(message: resMessage)
//                }
            }
        })
    }
}
