//
//  Notice.swift
//  RankingStar
//
//  Created by Hitarthi on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import Foundation

class Notice : NSObject {
    
//    var apns_master_id : String!
//    var message_title : String!
//    var message : String!
//    var message_type : String!
//    var sender_id : String!
//    var created_date : String!
    
    
    var notice_id : String!
    var notice_title : String!
    var notice_description : String!
    var sender_id : String!
    var notice_date : String!
    var web_view_url : String!
    var arrNotice = [Notice]()
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> [Notice] {
        var arrNotice = [Notice]()
        
        if let arrData = dictData["notice_list"] as? [[String:Any]] {
            
            arrData.forEach { (objData) in
                let objNotice = Notice()
                
                if let data = objData["notice_id"] as? String {
                    objNotice.notice_id = data
                }
                if let data = objData["notice_title"] as? String {
                    objNotice.notice_title = data
                }
                if let data = objData["notice_description"] as? String {
                    objNotice.notice_description = data
                }
                if let data = objData["sender_id"] as? String {
                    objNotice.sender_id = data
                }
                if let data = objData["notice_date"] as? String {
                    objNotice.notice_date = data
                }
                if let data = objData["web_view_url"] as? String {
                    objNotice.web_view_url = data
                }
                
                arrNotice.append(objNotice)
            }
        }
        
        return arrNotice
    }
}
