//
//  UserDetailByPhone.swift
//  RankingStar
//
//  Created by Hitarthi on 07/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class UserDetailByPhone: NSObject {
    
    var user_id : String!
    var mobile : String!
    var user_type : String!
    var name : String!
    var main_image : String!
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> UserDetailByPhone {
        
        let objDetail = UserDetailByPhone()
        
        if let userDetails = dictData["user_details"] as? [String:Any] {
            
            if let data = userDetails["user_id"] as? String {
                objDetail.user_id = data
            }
            if let data = userDetails["mobile"] as? String {
                objDetail.mobile = data
            }
            if let data = userDetails["user_type"] as? String {
                objDetail.user_type = data
            }
            if let data = userDetails["name"] as? String {
                objDetail.name = data
            }
            if let data = userDetails["main_image"] as? String {
                objDetail.main_image = data
            }
        }
        
        return objDetail
    }
}
