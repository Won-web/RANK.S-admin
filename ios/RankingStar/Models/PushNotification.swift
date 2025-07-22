//
//  PushNotification.swift
//  RankingStar
//
//  Created by Hitarthi on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class PushNotification: NSObject {

    var apns_master_id : String!
    var message_title : String!
    var message : String!
    var message_type : String!
    var sender_id : String!
    var created_date : String!
    var arrPushNotification = [PushNotification]()
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> [PushNotification] {
        var arrPushNotification = [PushNotification]()
        
        if let arrData = dictData["notification_list"] as? [[String:Any]] {
            
            arrData.forEach { (objData) in
                let objPushNotification = PushNotification()
                
                if let data = objData["apns_master_id"] as? String {
                    objPushNotification.apns_master_id = data
                }
                if let data = objData["message_title"] as? String {
                    objPushNotification.message_title = data
                }
                if let data = objData["message"] as? String {
                    objPushNotification.message = data
                }
                if let data = objData["message_type"] as? String {
                    objPushNotification.message_type = data
                }
                if let data = objData["sender_id"] as? String {
                    objPushNotification.sender_id = data
                }
                if let data = objData["created_date"] as? String {
                    objPushNotification.created_date = data
                }
                
                arrPushNotification.append(objPushNotification)
            }
        }
        
        return arrPushNotification
    }
    
    
}
