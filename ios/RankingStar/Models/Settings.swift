//
//  Settings.swift
//  RankingStar
//
//  Created by Hitarthi on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    var userId : String!
    var pushalert : String!
    var pushsound : String!
    var pushvibrate : String!
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> Settings {
        let objSettings = Settings()
        
        if let objData = dictData["push_setting"] as? [String:Any] {
            
            if let data = objData["push_alert"] as? String {
                objSettings.pushalert = data
            }
            if let data = objData["push_sound"] as? String {
                objSettings.pushsound = data
            }
            if let data = objData["push_vibrate"] as? String {
                objSettings.pushvibrate = data
            }
            if let data = objData["user_id"] as? String {
                objSettings.userId = data
            }
            
        }
 
        return objSettings
    }

}
