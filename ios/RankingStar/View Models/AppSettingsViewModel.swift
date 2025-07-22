//
//  AppSettingsViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class AppSettingsViewModel: NSObject {
    private var vcRef : SettingVC!
    var objSettings = Settings()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : SettingVC!) {
        super.init()
        vcRef = vc
    }
    
    func getSettingsAPI(objSettings : Settings) {
        let requestHelper = RequestHelper()
        
        requestHelper.getSettingsAPI(objSettings: objSettings, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objSettings = resObj as! Settings
                self.objSettings = objSettings
                
                self.vcRef.onSuccessApiGetSettingsResponce()
            }
            else{
                self.vcRef.onFailApiResponce(message: resMessage)
            }
        })
    }
    
    func setSettingsAPI(objSettings : Settings) {
        let requestHelper = RequestHelper()
        
        requestHelper.setSettingsAPI(objSettings: objSettings, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                //                let objContestDetail = resObj as! ContestDetail
                //                self.hasMoreRecored = objContestDetail.hasMoreRecored
                //                self.arrContestList += objContestDetail.arrContestDetail
                self.vcRef.onSuccessApiResponce(message: resMessage)
            }
            else{
                self.vcRef.onFailApiResponce(message: resMessage)
            }
        })
    }
}
